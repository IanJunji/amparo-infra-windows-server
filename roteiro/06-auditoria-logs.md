# 6. Auditoria e logs

[Voltar ao README](../README.md)

## Política de auditoria (GPO)

Group Policy Management > Domain Controllers > botão direito em **Default Domain Controllers Policy** > Edit > Computer Configuration > Policies > Windows Settings > Security Settings > **Advanced Audit Policy Configuration** > Audit Policies. Marque **Success** e **Failure** em:

| Categoria | Subcategoria |
|---|---|
| Logon/Logoff | Audit Logon, Audit Account Lockout |
| Account Management | Audit User Account Management |
| Object Access | Audit File System |

Depois:

```powershell
gpupdate /force
auditpol /get /category:*
```

## Auditoria da pasta do banco

`C:\Amparo\api\App_Data` > Properties > Security > Advanced > aba **Auditing** > Add:

- Principal: **Everyone**, Type: All;
- Permissões avançadas: **Delete**, **Change permissions** e **Take ownership**.

A gravação comum fica de fora, porque a API grava no banco a cada chamada e encheria o log.

## Gerar eventos para mostrar

| Ação | Evento no log Security |
|---|---|
| Errar a senha de `carla.mendes` no `mstsc` | 4625 |
| Criar um usuário de teste no AD | 4720 |
| Apagar um arquivo de teste dentro de App_Data | 4663 |

No Event Viewer, crie um **Custom View** chamado `Amparo` com os logs System, Security e Application, para mostrar tudo numa tela só no vídeo.

## Logs do IIS

IIS Manager > site `Amparo` > **Logging**: formato **W3C**, diretório `C:\Amparo\logs\iis`, um arquivo por dia. Clique em Apply.

O IIS demora até um minuto para gravar as linhas. Para ver na hora, abra a API no navegador (e uma rota que não existe, para aparecer um 404) e rode:

```powershell
netsh http flush logbuffer
Get-ChildItem C:\Amparo\logs\iis -Recurse -Filter *.log | Sort-Object LastWriteTime | Select-Object -Last 1 | Get-Content -Tail 10
```
