---
name: sharingan
description: Analisar e catalogar funcionalidades de um projeto autorizado, replica-lo por completo ou transplantar funcionalidades selecionadas para outro projeto, adaptando codigo, estrutura e identidade sem carregar historico Git, segredos ou artefatos descartaveis. Use quando o usuario quiser inventariar, clonar, integrar, renomear, rebrandear ou criar uma variante de um projeto existente. Nao use para copiar software sem permissao ou contornar licencas.
---

# Sharingan

Replique o projeto com fidelidade primeiro; personalize depois. O resultado deve manter o comportamento original, salvo quando o usuario pedir mudancas funcionais.

## Escolher o modo

Determine pelo pedido qual resultado o usuario quer:

- **Espelho completo:** replicar o projeto inteiro em um novo destino. Use a skill `sharingan-mirror` e o subagente `danzo` para a copia.
- **Catalogo de funcionalidades:** analisar o projeto e listar capacidades separadas, sem modificar codigo. Use a skill `sharingan-catalog` e o subagente `kakashi`.
- **Transplante seletivo:** integrar uma ou mais funcionalidades escolhidas em outro projeto. Use a skill `sharingan-transplant` e os subagentes `madara` e `danzo`.
- **Personalizacao:** alterar marca, textos, visuais e identificadores de uma replica ou integracao. Use a skill `sharingan-brand` e o subagente `obito`.
- **Validacao e auditoria:** conferir licencas, segredos, testes e qualidade. Use a skill `sharingan-validate` e o subagente `itachi`.

Combine modos quando solicitado. Nao interprete um pedido de analise ou listagem como autorizacao para copiar ou alterar codigo.

## Skills e subagentes

Leia a skill especializada do modo escolhido por completo antes de modificar arquivos. Delegue trabalho isolado aos subagentes quando a tarefa for grande, somente leitura ou puder rodar em paralelo:

| Skill | Subagente | Quando |
| --- | --- | --- |
| `sharingan-catalog` | `kakashi` | Inventariar e fichar funcionalidades |
| `sharingan-mirror` | `danzo` | Espelhar o projeto inteiro |
| `sharingan-transplant` | `madara`, `danzo` | Planejar e integrar funcionalidades |
| `sharingan-brand` | `obito` | Mapear e aplicar identidade |
| `sharingan-validate` | `itachi` | Validar, auditar e revisar qualidade |

Aplique a regra `sharingan-safety` em qualquer modo que copie ou altere arquivos.

## Skills, slash commands e `$sharingan`

Sao tres coisas diferentes. Nunca trate o nome de uma skill como slash command, nem o inverso:

- **Skills** (`sharingan`, `sharingan-catalog`, `sharingan-mirror`, `sharingan-transplant`, `sharingan-brand`, `sharingan-validate`) sao lidas e aplicadas.
- **Slash commands** em `commands/` disparam a skill certa. Os nomes sao propositalmente distintos dos nomes das skills, porque agentes se perdem quando os dois coincidem.
- **`$sharingan <comando>`** e sintaxe conversacional interpretada por esta skill, nao um executavel de shell.

| Slash command | `$sharingan` | Skill |
| --- | --- | --- |
| `/sharingan-help` | `help` | `sharingan` |
| `/sharingan-list` | `list` | `sharingan-catalog` |
| `/sharingan-inspect` | `inspect` | `sharingan-catalog` |
| `/sharingan-compare` | `compare` | `sharingan-transplant` |
| `/sharingan-plan` | `plan` | `sharingan-transplant` |
| `/sharingan-integrate` | `integrate` | `sharingan-transplant` |
| `/sharingan-clone` | `mirror` | `sharingan-mirror` |
| `/sharingan-rebrand` | `brand` | `sharingan-brand` |
| `/sharingan-check` | `validate` | `sharingan-validate` |
| `/sharingan-audit` | `audit` | `sharingan-validate` |

## Comandos curtos

Aceite invocacoes no formato `$sharingan <comando>`. Quando o usuario usar esse formato, leia [references/commands.md](references/commands.md) por completo e aplique a semantica do comando e de seus parametros.

Os comandos `$sharingan` sao atalhos conversacionais da skill, nao executaveis do shell. Continue aceitando pedidos em linguagem natural. Se o texto explicito do usuario complementar ou contrariar um valor padrao do comando, o texto explicito prevalece.

## Definir a operacao

Identifique:

- a origem, que pode ser uma pasta local ou um repositorio Git;
- o destino;
- o novo nome e os elementos de identidade desejados;
- se deve partir do ultimo commit ou incluir alteracoes locais ainda nao commitadas.

Infira valores evidentes a partir do pedido e do repositorio. Pergunte apenas quando uma escolha ausente alterar materialmente o resultado ou houver risco de sobrescrever dados.

## Verificar permissao e limites

Antes de copiar, procure `LICENSE`, `COPYING`, avisos de copyright e regras do repositorio. Prossiga quando o usuario for dono do codigo, tiver autorizacao, ou a licenca permitir a reutilizacao pretendida. Preserve atribuicoes, avisos e termos obrigatorios. Se nao houver licenca ou houver incompatibilidade, explique a restricao e limite o trabalho a uma estrutura original ou a uma adaptacao permitida.

Nunca transfira automaticamente:

- `.git` e historico do repositorio original;
- `.env`, chaves, tokens, certificados, credenciais ou dados pessoais;
- dependencias instaladas, caches, logs, binarios e artefatos de build;
- backups, dumps ou dados de producao.

Mantenha arquivos de exemplo, como `.env.example`, depois de confirmar que nao contem valores reais.

## Inventariar antes de modificar

Inspecione a arvore completa, incluindo arquivos ocultos, submodulos e links simbolicos. Leia primeiro as instrucoes do repositorio, especialmente `AGENTS.md`, e identifique:

- linguagens, gerenciadores de pacotes, workspaces e pontos de entrada;
- arquivos rastreados e arquivos locais relevantes;
- configuracoes de build, teste, lint, CI, containers e deploy;
- nomes de pacote, namespaces, IDs de aplicativo, dominios, URLs e variaveis;
- textos, logos, icones, cores, metadados, documentacao e fixtures com a marca antiga;
- integracoes externas que precisam continuar intactas ou ser reconfiguradas.

Registre riscos antes da alteracao: destino existente, arquivos grandes, submodulos privados, LFS, codigo gerado e referencias que nao podem ser renomeadas mecanicamente.

## Entrega

Resuma:

- origem, ref ou estado copiado e caminho do destino;
- itens excluidos por seguranca ou por serem regeneraveis;
- alteracoes de identidade realizadas;
- licenca e atribuicoes preservadas;
- comandos de verificacao e resultados;
- referencias antigas restantes e proximos ajustes que dependem do usuario.

Para catalogos e transplantes, inclua tambem as funcionalidades escolhidas, dependencias trazidas, decisoes de copiar/adaptar/reimplementar e lacunas ainda nao integradas.
