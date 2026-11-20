# Passo 1: IP fixo, DNS e hostname.
# Rodar dentro da VM, no PowerShell como Administrador.
# Antes, veja o nome da placa interna com Get-NetAdapter e troque abaixo se for outro.
$placa = "Ethernet"

# Tira o IP automático da placa interna e coloca o IP fixo (sem gateway: a internet sai pela placa NAT)
Set-NetIPInterface -InterfaceAlias $placa -Dhcp Disabled
Remove-NetIPAddress -InterfaceAlias $placa -AddressFamily IPv4 -Confirm:$false -ErrorAction SilentlyContinue
New-NetIPAddress -InterfaceAlias $placa -IPAddress 192.168.56.10 -PrefixLength 24

# O próprio servidor vai ser o DNS depois que virar controlador de domínio
Set-DnsClientServerAddress -InterfaceAlias $placa -ServerAddresses 127.0.0.1

Rename-Computer -NewName "SRV-AMPARO01"

ipconfig /all
Write-Host "Tire o print do ipconfig e reinicie com: Restart-Computer"
