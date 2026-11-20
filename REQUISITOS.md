# Requisitos: Operating Systems

Fonte: slides 32 a 34 do PDF da GS. Requisitos comuns a todas as disciplinas em [`REQUISITOS-GERAIS.md`](../REQUISITOS-GERAIS.md).

## Objetivo

Montar e administrar uma infraestrutura **Windows Server** que sustente a CitizenTech, usando os serviços vistos no semestre (DNS, Active Directory, File Server, IIS, GPO, RDS e DFS). A infraestrutura precisa hospedar a **aplicação web** da solução, ser monitorada e responder a falhas.

## Percurso sugerido pelo professor

1. **Preparar o ambiente:** Windows Server numa VM (VirtualBox, VMware, Hyper-V ou Azure) com domínio, DNS e IP fixo.
2. **Hospedar a aplicação:** instalar e configurar no IIS tudo o que a aplicação web precisa (funções, runtime, dependências, site, pool de aplicativos).
3. **Preparar a infraestrutura:** DNS, pastas e permissões NTFS, GPO, acesso remoto, monitoramento e auditoria.
4. **Apresentar o resultado:** o ambiente configurado dentro da VM, com evidências de cada etapa, rodando a aplicação web.

## Requisitos

### Rede e identidade
- [ ] **OS-01** IP fixo.
- [ ] **OS-02** Hostname definido.
- [ ] **OS-03** DNS configurado.
- [ ] **OS-04** Domínio no Active Directory.

### Aplicação no IIS
- [ ] **OS-05** Site criado no IIS.
- [ ] **OS-06** Pool de aplicativos configurado.
- [ ] **OS-07** Runtime e dependências da aplicação instalados.
- [ ] **OS-08** Pasta da aplicação com permissões NTFS.

### Administração
- [ ] **OS-09** Políticas de grupo (GPO).
- [ ] **OS-10** Acesso remoto.

### Monitoramento
- [ ] **OS-11** Alertas de consumo de CPU no Monitor de Desempenho.
- [ ] **OS-12** Alertas de consumo de disco.
- [ ] **OS-13** Alertas de consumo de memória.

### Tolerância a falhas
- [ ] **OS-14** Recuperação automática do serviço.
- [ ] **OS-15** Recuperação automática do pool do IIS.
- [ ] **OS-16** Teste de falha documentado.

### Auditoria
- [ ] **OS-17** Logs no Visualizador de Eventos.
- [ ] **OS-18** Logs do IIS.

### Evidências
- [ ] **OS-19** Prints e saídas de `ipconfig`, `nslookup` e `Test-NetConnection`.

## Entregáveis

- [ ] **Repositório GitHub** com o README.md (com a Ficha da CitizenTech), o roteiro de configuração e as evidências técnicas.
- [ ] **Vídeo de até 7 minutos** mostrando a infraestrutura configurada (funções, serviços, dependências e permissões), o teste de falha e a aplicação hospedada no IIS funcionando por completo.

## Como entregar

Link do repositório no GitHub, enviado por um único integrante na tarefa do Teams.

## Avaliação (10,0)

| Critério | Pontos |
|---|---|
| Infraestrutura de rede e identidade (IP fixo, hostname, DNS, domínio no AD) | 2 |
| Aplicação hospedada no IIS (site, pool, dependências, pasta e permissões NTFS) | 2 |
| Monitoramento com alertas de CPU, disco e memória | 2 |
| Serviços tolerantes a falhas e teste de falha | 1 |
| Logs de auditoria e acompanhamento | 1 |
| Funcionamento completo da proposta | 2 |

## Ligação com as outras partes

- Hospeda a aplicação web feita em outra disciplina, provavelmente o **backend (SOA)** ou um painel web que use essa API.
- A varredura com nmap deste servidor pode servir de evidência para **Cybersecurity**.

## Em aberto

### Decisões

- Aplicação hospedada: a API do Amparo (`backend-soa/`), ASP.NET Core .NET 10 com SQLite, no IIS com o Hosting Bundle 10.
- VM: Windows Server 2022 Evaluation em inglês, no Hyper-V ou VirtualBox de um integrante. Configuração quase toda pela interface, com poucos scripts.
- Nomes: `SRV-AMPARO01`, `192.168.56.10`, `amparo.local`, `api.amparo.local`, site `Amparo`, pool `AmparoApiPool`, pasta `C:\Amparo`.
- Acesso remoto por RDP de administração; sem a função RDS e sem DFS.

### Pendente

- Qual integrante hospeda a VM; fazer o passo a passo nela e tirar os prints.
