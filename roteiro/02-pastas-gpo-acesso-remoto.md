# 2. Pastas, permissões, GPO e acesso remoto

[Voltar ao README](../README.md)

## Pastas

```powershell
mkdir C:\Amparo\api\App_Data, C:\Amparo\logs\iis, C:\Amparo\logs\api, C:\Amparo\Compartilhado\Relatorios
```

| Pasta | Para quê |
|---|---|
| `C:\Amparo\api` | arquivos da API (o site do IIS aponta para cá) |
| `C:\Amparo\api\App_Data` | banco SQLite `amparo.db` |
| `C:\Amparo\logs\iis` e `logs\api` | logs do IIS e da API |
| `C:\Amparo\Compartilhado\Relatorios` | pasta compartilhada com os operadores |

## Permissões NTFS

Em `C:\Amparo` > Properties > Security > **Advanced**:

1. **Disable inheritance** > "Convert inherited permissions".
2. Remova o grupo **Users**. Ficam Administrators e SYSTEM com Full control.
3. Adicione `GG-Amparo-Admins` com **Modify**.

Em `Compartilhado\Relatorios`, adicione `GG-Amparo-Operadores` com **Modify**. Assim os operadores só enxergam essa pasta, e não a API nem o banco.

A permissão do pool do IIS na pasta da API é dada no [passo 3](03-iis-api.md), porque o pool ainda não existe.

## Compartilhamento

`Relatorios` > Properties > Sharing > **Advanced Sharing** > compartilhar como `AmparoRelatorios`. Em Permissions: `GG-Amparo-Operadores` com Change e `GG-Amparo-Admins` com Full Control.

## GPO

Abra **Server Manager > Tools > Group Policy Management**.

**Senha e bloqueio do domínio.** Botão direito em **Default Domain Policy** > Edit > Computer Configuration > Policies > Windows Settings > Security Settings > Account Policies:

| Política | Valor |
|---|---|
| Minimum password length | 10 |
| Password must meet complexity requirements | Enabled |
| Maximum password age | 90 dias |
| Account lockout threshold | 5 tentativas |
| Account lockout duration | 15 minutos |

**Restrições dos operadores.** Botão direito na OU `Operadores` > **Create a GPO in this domain, and Link it here** > nome `GPO-Amparo-Operadores` > Edit > User Configuration > Policies > Administrative Templates:

| Onde | Política | Valor |
|---|---|---|
| Control Panel | Prohibit access to Control Panel and PC settings | Enabled |
| Control Panel > Personalization | Password protect the screen saver | Enabled |
| Control Panel > Personalization | Screen saver timeout | Enabled, 600 segundos |
| System > Removable Storage Access | All Removable Storage classes: Deny all access | Enabled |

O operador vê dados de saúde dos idosos: a tela bloqueia quando ele sai da mesa e ele não consegue copiar nada para pendrive.

Depois rode `gpupdate /force`.

## Acesso remoto

1. `sysdm.cpl` > aba **Remote** > "Allow remote connections to this computer", com "Allow connections only from computers running Remote Desktop with Network Level Authentication". O Windows já abre a porta 3389 no firewall.
2. Os administradores do domínio já podem entrar. Os operadores não.
3. Teste no host: `mstsc /v:192.168.56.10`, usuário `AMPARO\adm.rafael`.

Para o `Test-NetConnection` responder ao ping, ligue no `wf.msc` a regra de entrada "File and Printer Sharing (Echo Request - ICMPv4-In)".

## Firewall

No `wf.msc`, a placa NAT (a que fica de frente para a rede dos clientes) só aceita entrada nas portas 80 e 443. O RDP só é aceito a partir do host (`192.168.56.1`). Pela rede interna `192.168.56.x` continuam abertas as portas de DNS (53), AD (389), compartilhamento (445) e RDP (3389).

Não instalamos a função Remote Desktop Services: ela pede licenças e não deve ficar no controlador de domínio. O RDP de administração basta para o projeto.
