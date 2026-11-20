# Passo 5: recuperação automática dos serviços do IIS e do pool da API.
# Rodar dentro da VM, no PowerShell como Administrador, depois de criar o pool AmparoApiPool.
Import-Module WebAdministration

# Serviços: se o processo cair, o Windows reinicia depois de 5 s, 10 s e 30 s (a contagem zera em 1 dia)
sc.exe failure W3SVC reset= 86400 actions= restart/5000/restart/10000/restart/30000
sc.exe failure WAS reset= 86400 actions= restart/5000/restart/10000/restart/30000
Set-Service W3SVC -StartupType Automatic
Set-Service WAS -StartupType Automatic

# Pool: sobe junto com o IIS, não desliga por ociosidade e o IIS confere se ele está respondendo
$pool = "IIS:\AppPools\AmparoApiPool"
Set-ItemProperty $pool -Name autoStart -Value $true
Set-ItemProperty $pool -Name startMode -Value "AlwaysRunning"
Set-ItemProperty $pool -Name processModel.idleTimeout -Value ([TimeSpan]::Zero)
Set-ItemProperty $pool -Name processModel.pingingEnabled -Value $true
Set-ItemProperty $pool -Name failure.rapidFailProtection -Value $true

# Conferência (print para as evidências)
sc.exe qfailure W3SVC
sc.exe qfailure WAS
Get-ItemProperty $pool | Select-Object name, autoStart, startMode
