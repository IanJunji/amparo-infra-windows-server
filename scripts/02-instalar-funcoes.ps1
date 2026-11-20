# Passo 1: instala as funções do servidor (AD DS, DNS, Servidor de Arquivos e IIS).
# Rodar dentro da VM, no PowerShell como Administrador, depois de reiniciar com o nome novo.
# O IIS precisa estar instalado ANTES do ASP.NET Core Hosting Bundle (passo 3).

Install-WindowsFeature AD-Domain-Services, DNS, FS-FileServer -IncludeManagementTools

Install-WindowsFeature Web-Server, Web-Http-Logging, Web-Request-Monitor, Web-Mgmt-Console -IncludeManagementTools

Get-WindowsFeature | Where-Object Installed | Format-Table Name, DisplayName
Write-Host "Agora promova o servidor a controlador de domínio pelo Server Manager (bandeira amarela)."
