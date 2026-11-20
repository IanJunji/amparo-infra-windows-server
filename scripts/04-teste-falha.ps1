# Passo 5: teste de falha. Derruba a API de dois jeitos e mede quanto tempo ela leva para voltar.
# Rodar dentro da VM, no PowerShell como Administrador. Só na VM do laboratório.
$url = "http://api.amparo.local/api/alertas"
$inicioTeste = Get-Date

New-Item -ItemType Directory -Path C:\Amparo\evidencias -Force | Out-Null
Start-Transcript -Path "C:\Amparo\evidencias\teste-falha-$(Get-Date -Format yyyyMMdd-HHmm).txt"

# A rota exige login, então a resposta normal sem token é 401: quem respondeu foi a própria API, ou seja, ela está no ar.
# Com o IIS ou o pool caído, a resposta é 503 ou nenhuma.
function StatusApi {
    try { return [int](Invoke-WebRequest $url -UseBasicParsing -TimeoutSec 5).StatusCode }
    catch {
        if ($_.Exception.Response) { return [int]$_.Exception.Response.StatusCode }
        return "fora do ar"
    }
}

function ApiNoAr($status) { return $status -eq 200 -or $status -eq 401 }

function EsperarApiVoltar {
    $inicio = Get-Date
    while (-not (ApiNoAr ($status = StatusApi))) {
        if (((Get-Date) - $inicio).TotalSeconds -gt 120) { Write-Host "A API não voltou em 2 minutos."; return }
        Start-Sleep -Seconds 2
    }
    $segundos = [math]::Round(((Get-Date) - $inicio).TotalSeconds)
    Write-Host "API voltou: HTTP $status (a API respondeu) depois de $segundos segundos." -ForegroundColor Green
}

Write-Host "Antes do teste: HTTP $(StatusApi)"

# Falha 1: mata o processo do pool (w3wp.exe). O IIS deve subir outro sozinho.
$w3wp = Get-CimInstance Win32_Process -Filter "Name='w3wp.exe'" | Where-Object { $_.CommandLine -like "*AmparoApiPool*" }
Write-Host "Falha 1: matando o w3wp.exe do AmparoApiPool (PID $($w3wp.ProcessId))" -ForegroundColor Red
Stop-Process -Id $w3wp.ProcessId -Force
Write-Host "Logo depois da falha: HTTP $(StatusApi)"
EsperarApiVoltar

# Falha 2: mata o processo do serviço W3SVC. A recuperação do serviço deve reiniciá-lo.
$pidServico = (Get-CimInstance Win32_Service -Filter "Name='W3SVC'").ProcessId
Write-Host "Falha 2: matando o processo do serviço W3SVC (PID $pidServico)" -ForegroundColor Red
Stop-Process -Id $pidServico -Force
Start-Sleep -Seconds 2
Get-Service W3SVC, WAS
EsperarApiVoltar
Get-Service W3SVC, WAS

# Eventos que mostram a recuperação (7031 = serviço caiu e o Windows tomou a ação de recuperação)
Get-WinEvent -FilterHashtable @{ LogName = "System"; StartTime = $inicioTeste; ProviderName = "Service Control Manager", "Microsoft-Windows-WAS" } -ErrorAction SilentlyContinue |
    Format-Table TimeCreated, Id, Message -Wrap

Stop-Transcript
