# Amparo: servidor Windows (Operating Systems)

Servidor Windows Server numa VM que hospeda a API do Amparo no IIS, com domínio, DNS, permissões, GPO, acesso remoto, monitoramento, recuperação automática e auditoria.

## Ficha da CitizenTech

| | |
|---|---|
| **Nome** | Amparo |
| **Cidade e bairro** | São Paulo (SP), Santana |
| **Cidadão beneficiado** | Idosos que moram sozinhos e suas famílias |
| **Problema** | O idoso que mora sozinho cai em casa e pode ficar horas no chão até alguém perceber. |
| **Como funciona** | A pulseira (ESP32 com acelerômetro) percebe a queda, ou o idoso aperta o botão de pânico, e manda as leituras para a API. A API confirma com um modelo de Machine Learning e abre um alerta. O operador da central vê o alerta, liga para o idoso ou para a família e, se precisar, chama o SAMU. A família acompanha pelo app. |
| **O que cada parte faz** | **Pulseira** (ESP32 no Wokwi): detecta a queda e tem botão de pânico. **API** (ASP.NET Core): guarda idosos, pulseiras, alertas e atendimentos. **Modelo de ML** (Python): confirma se foi queda. **Central** (C# Windows Forms): o operador atende o alerta. **App** (React Native): a família acompanha. **Servidor** (Windows Server com IIS): hospeda a API. |
| **Link do repositório** | https://github.com/IanJunji/amparo-infra-windows-server |
| **Indicador de impacto** | Tempo entre a queda e o primeiro atendimento da central, em minutos. A API grava a hora em que o alerta abre e a hora da primeira ação do operador. |
| **ODS conectados** | 3 (Saúde e bem-estar), 10 (Redução das desigualdades) e 11 (Cidades e comunidades sustentáveis) |

### Como o Amparo contribui para os ODS

| ODS | Meta da ONU | Como o Amparo contribui |
|---|---|---|
| **3. Saúde e bem-estar** | 3.8: acesso a serviços de saúde essenciais de qualidade para todos | A queda é detectada na hora e a central chama a família ou o SAMU. O idoso deixa de ficar horas no chão esperando alguém perceber, e o socorro chega antes das complicações. |
| **10. Redução das desigualdades** | 10.2: inclusão social de todos, independentemente da idade | O idoso que mora sozinho passa a ter a mesma segurança de quem mora acompanhado. Ele pode continuar vivendo na própria casa, com autonomia. |
| **11. Cidades e comunidades sustentáveis** | 11.1: moradia segura e acesso aos serviços básicos | A casa do idoso fica ligada à rede de atendimento da cidade (central da prefeitura, família e SAMU). O piloto começa em Santana e pode ser ampliado para outros bairros. |

## Integrantes

| Nome | RM |
|---|---|
| Cilas Pinto Macedo | RM560745 |
| Ian Junji Maluvayshi Matsushita | RM560588 |
| Leandro Kamada Pesce Dimov | RM560381 |

## O servidor

| Item | Valor |
|---|---|
| Sistema | Windows Server 2022 Standard Evaluation (Desktop Experience, em inglês) |
| VM | Hyper-V ou VirtualBox, 2 vCPU, 4 GB, 60 GB, uma placa NAT e uma interna |
| Hostname / IP | `SRV-AMPARO01` / `192.168.56.10` |
| Domínio | `amparo.local` (o servidor é o controlador de domínio e o DNS) |
| Funções | AD DS, DNS, File Server, IIS |
| Aplicação | API do Amparo (ASP.NET Core .NET 10, SQLite) em `http://api.amparo.local` |
| Site / pool | `Amparo` / `AmparoApiPool` |
| Pasta | `C:\Amparo` |

## Passo a passo

A maior parte é feita pela interface (Server Manager, IIS Manager, Group Policy Management, Performance Monitor). Os scripts em [`scripts/`](scripts/) só adiantam as partes repetitivas e rodam dentro da VM, no PowerShell como Administrador.

| Passo | Guia | Script |
|---|---|---|
| 1 | [VM, rede e domínio](roteiro/01-vm-rede-dominio.md) | `01-ip-hostname.ps1`, `02-instalar-funcoes.ps1` |
| 2 | [Pastas, permissões, GPO e acesso remoto](roteiro/02-pastas-gpo-acesso-remoto.md) | |
| 3 | [IIS e publicação da API](roteiro/03-iis-api.md) | |
| 4 | [Monitoramento](roteiro/04-monitoramento.md) | |
| 5 | [Tolerância a falhas e teste de falha](roteiro/05-tolerancia-falhas.md) | `03-recuperacao-automatica.ps1`, `04-teste-falha.ps1` |
| 6 | [Auditoria e logs](roteiro/06-auditoria-logs.md) | |
| 7 | [Validação final](roteiro/07-validacao.md) | |

Os scripts estão salvos em UTF-8 com BOM, para o PowerShell da VM mostrar os acentos certo. Nenhuma senha fica nos arquivos.

## Evidências e vídeo

- Lista de prints: [`evidencias/README.md`](evidencias/README.md).
- Roteiro do vídeo: [`roteiro-video.md`](roteiro-video.md). Vídeo (3 min, com legendas): https://github.com/IanJunji/amparo-infra-windows-server/blob/main/video/amparo-infra-windows-server.mp4
- Requisitos da disciplina: [`REQUISITOS.md`](REQUISITOS.md).
