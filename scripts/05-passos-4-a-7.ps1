# Passos 4 a 7 de uma vez: alertas, recuperação + teste de falha, auditoria, logs do IIS e validação.
# Rodar dentro da VM, no PowerShell como Administrador, na mesma pasta dos scripts 03 e 04.
# A saída inteira fica em C:\Amparo\evidencias\passos-4-a-7-<data>.txt
$ErrorActionPreference = "Continue"
New-Item -ItemType Directory -Path C:\Amparo\evidencias -Force | Out-Null
Start-Transcript -Path "C:\Amparo\evidencias\passos-4-a-7-$(Get-Date -Format yyyyMMdd-HHmm).txt"
$inicio = Get-Date

Write-Host "`n===== PASSO 4: alertas de CPU, disco e memória =====" -ForegroundColor Cyan
logman stop Amparo-Alertas 2>$null | Out-Null
logman delete Amparo-Alertas 2>$null | Out-Null
logman create alert Amparo-Alertas -th "\Processor(_Total)\% Processor Time>80" "\LogicalDisk(C:)\% Free Space<15" "\Memory\Available MBytes<500" -si 00:00:15 -el
logman start Amparo-Alertas
logman query Amparo-Alertas
Write-Host "Ocupando a CPU por 45 segundos para disparar o alerta..."
$jobs = 1..2 | ForEach-Object { Start-Job { $f = (Get-Date).AddSeconds(45); while ((Get-Date) -lt $f) {} } }
$jobs | Wait-Job | Remove-Job
Start-Sleep -Seconds 20
Get-WinEvent -FilterHashtable @{ LogName = "Microsoft-Windows-Diagnosis-PLA/Operational"; Id = 2031; StartTime = $inicio } -ErrorAction SilentlyContinue |
    Select-Object -First 3 | Format-List TimeCreated, Id, Message

Write-Host "`n===== PASSO 5: recuperação automática e teste de falha =====" -ForegroundColor Cyan
Stop-Transcript | Out-Null
& "$PSScriptRoot\03-recuperacao-automatica.ps1"
& "$PSScriptRoot\04-teste-falha.ps1"
Start-Transcript -Path "C:\Amparo\evidencias\passos-4-a-7-$(Get-Date -Format yyyyMMdd-HHmm)-b.txt"

Write-Host "`n===== PASSO 6: auditoria =====" -ForegroundColor Cyan
foreach ($sub in "Logon", "Account Lockout", "User Account Management", "File System") {
    auditpol /set /subcategory:"$sub" /success:enable /failure:enable | Out-Null
}
auditpol /get /subcategory:"Logon","Account Lockout","User Account Management","File System"

# Auditoria da pasta do banco: apagar, mudar permissão ou tomar posse
$pasta = "C:\Amparo\api\App_Data"
$acl = Get-Acl $pasta -Audit
$direitos = [Security.AccessControl.FileSystemRights]"Delete, ChangePermissions, TakeOwnership"
$regra = New-Object Security.AccessControl.FileSystemAuditRule("Everyone", $direitos, "ContainerInherit, ObjectInherit", "None", "Success, Failure")
$acl.AddAuditRule($regra)
Set-Acl $pasta $acl
(Get-Acl $pasta -Audit).Audit | Format-Table IdentityReference, FileSystemRights, AuditFlags -AutoSize

# Gera os eventos para mostrar
"teste" | Set-Content "$pasta\teste-auditoria.txt"; Remove-Item "$pasta\teste-auditoria.txt"          # 4663
Remove-ADUser teste.auditoria -Confirm:$false -ErrorAction SilentlyContinue
New-ADUser teste.auditoria -Path "OU=Amparo,DC=amparo,DC=local" -Enabled $false                          # 4720
$errado = New-Object DirectoryServices.DirectoryEntry("LDAP://192.168.56.10", "AMPARO\carla.mendes", "senha-errada-de-proposito")
try { $null = $errado.NativeObject } catch { Write-Host "Login errado de carla.mendes gerado (4625)." }   # 4625
Start-Sleep -Seconds 5
Get-WinEvent -FilterHashtable @{ LogName = "Security"; Id = 4625, 4720, 4663; StartTime = $inicio } -ErrorAction SilentlyContinue |
    Select-Object -First 8 | Format-Table TimeCreated, Id, @{n="Resumo"; e={ ($_.Message -split "`n")[0] }} -AutoSize

Write-Host "`n===== Logs do IIS =====" -ForegroundColor Cyan
foreach ($u in "/api/alertas", "/nao-existe") {
    try { Invoke-WebRequest "http://api.amparo.local$u" -UseBasicParsing | Out-Null } catch {}
}
netsh http flush logbuffer | Out-Null
Start-Sleep -Seconds 3
Get-ChildItem C:\Amparo\logs\iis -Recurse -Filter *.log | Sort-Object LastWriteTime | Select-Object -Last 1 | Get-Content -Tail 6

Write-Host "`n===== PASSO 7: validação =====" -ForegroundColor Cyan
ipconfig | Select-String "IPv4"
nslookup api.amparo.local
foreach ($p in 80, 53, 389, 3389) {
    Test-NetConnection 192.168.56.10 -Port $p | Select-Object ComputerName, RemotePort, TcpTestSucceeded
}
curl.exe -s -i http://api.amparo.local/api/alertas | Select-Object -First 1
$login = Invoke-RestMethod -Method Post http://api.amparo.local/api/auth/login -ContentType "application/json" -Body '{"usuario":"operador","senha":"amparo123"}'
Write-Host "Login OK como $($login.nome) ($($login.perfil)). Token não exibido."
$r = Invoke-WebRequest http://api.amparo.local/api/alertas -UseBasicParsing -Headers @{ Authorization = "Bearer $($login.token)" }
Write-Host "GET /api/alertas com token: HTTP $($r.StatusCode)"
$login = $null

Stop-Transcript
Write-Host "Pronto. Copie a pasta C:\Amparo\evidencias para infra-windows-server/evidencias/ do repositório." -ForegroundColor Green
