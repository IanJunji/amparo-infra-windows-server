# 1. VM, rede e domínio

[Voltar ao README](../README.md)

## Criar a VM

- Hyper-V ou VirtualBox, com 2 vCPU, 4 GB de RAM e disco de 60 GB.
- ISO: Windows Server 2022 Standard Evaluation, baixada em <https://www.microsoft.com/evalcenter>. Instalar a versão **Desktop Experience**, em inglês.
- Duas placas de rede:
  - placa 1 em NAT (Default Switch no Hyper-V, NAT no VirtualBox), para ter internet;
  - placa 2 em rede interna (switch interno no Hyper-V, Host-Only no VirtualBox). No host, essa rede fica com o IP `192.168.56.1`.
- Copie a pasta `scripts` para `C:\Instaladores\scripts` dentro da VM.

Para rodar os scripts na VM, abra o PowerShell como Administrador e libere a execução só nessa janela:

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
cd C:\Instaladores\scripts
```

## IP fixo e hostname

Rode `Get-NetAdapter` para ver qual placa é a interna. Na nossa VM a interna ficou `Ethernet` e a NAT `Ethernet 2`. Para ter certeza, compare o MAC com o que aparece no Hyper-V (VM > Settings > placa > Advanced Features). Se for outro nome, troque `$placa` no script. Depois:

```powershell
.\01-ip-hostname.ps1
Restart-Computer
```

Ficam: IP `192.168.56.10/24` sem gateway na placa interna, DNS `127.0.0.1` e nome `SRV-AMPARO01`.

Pela interface dá para conferir em `ncpa.cpl` (placa interna > Properties > IPv4) e em `sysdm.cpl` (nome do computador).

## Instalar as funções e criar o domínio

```powershell
.\02-instalar-funcoes.ps1
```

Depois, no **Server Manager**:

1. Clique na bandeira amarela > **Promote this server to a domain controller**.
2. **Add a new forest**, nome `amparo.local`.
3. Defina a senha do DSRM (anote fora do repositório) e avance até **Install**. O servidor reinicia.
4. Entre como `AMPARO\Administrator`.

## OUs, grupos e usuários

Em **Server Manager > Tools > Active Directory Users and Computers**:

```text
amparo.local
└── Amparo                 (OU)
    ├── Operadores         (OU)  carla.mendes, joaquim.prates
    ├── Administradores    (OU)  adm.rafael
    └── grupos             GG-Amparo-Operadores, GG-Amparo-Admins
```

- Coloque os operadores no grupo `GG-Amparo-Operadores` e o `adm.rafael` no `GG-Amparo-Admins`.
- Coloque o `GG-Amparo-Admins` dentro do grupo **Domain Admins**.
- Marque "User must change password at next logon" nos operadores. No `adm.rafael` deixe desmarcado: com NLA ligado, o `mstsc` não deixa trocar a senha na hora do login e o acesso remoto falharia.

## DNS

Em **Server Manager > Tools > DNS**:

1. Forward Lookup Zones > `amparo.local` > botão direito > **New Host (A)**: nome `api`, IP `192.168.56.10`.
2. Reverse Lookup Zones > **New Zone** > rede `192.168.56`. Depois crie o PTR do `192.168.56.10` (ou marque "Create associated PTR record" no registro `api`).
3. Botão direito no servidor > Properties > **Forwarders**: `8.8.8.8` e `1.1.1.1`.

Para o DNS não responder pela placa NAT, deixe-o escutar só no IP interno: `dnscmd /ResetListenAddresses 192.168.56.10`.

Se o `nslookup amparo.local` também devolver o IP da placa NAT, apague esse registro na zona e, na placa NAT, desmarque IPv4 > Advanced > DNS > "Register this connection's addresses in DNS".

## Conferir

```powershell
ipconfig /all
hostname
nslookup api.amparo.local
nslookup 192.168.56.10
```

Prints: veja a lista em [evidencias](../evidencias/README.md).
