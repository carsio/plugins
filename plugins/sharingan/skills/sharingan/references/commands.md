# Comandos do Sharingan

Use a forma:

```text
$sharingan <comando> [argumentos] [opcoes]
```

Esses comandos sao uma sintaxe conversacional interpretada pela skill. Nao os execute diretamente no PowerShell, Bash ou CMD.

## Resumo dos comandos

Sempre que o usuario executar `$sharingan help`, mostre esta tabela com o comando, sua traducao em portugues e uma explicacao curta:

| Comando | Traducao | O que faz |
| --- | --- | --- |
| `$sharingan help` | Ajuda | Mostra os comandos disponiveis, opcoes e exemplos de uso. |
| `$sharingan list` | Listar funcionalidades | Analisa o projeto de origem e cria um catalogo das funcionalidades com IDs e dependencias. |
| `$sharingan inspect` | Inspecionar funcionalidade | Explica uma funcionalidade ponta a ponta, incluindo fluxo, arquivos, configuracoes e testes. |
| `$sharingan compare` | Comparar compatibilidade | Compara a funcionalidade de origem com o projeto de destino e aponta lacunas e adaptacoes. |
| `$sharingan plan` | Planejar integracao | Cria um plano de integracao com etapas, dependencias, riscos, testes e criterios de conclusao. |
| `$sharingan integrate` | Integrar funcionalidade | Copia, adapta ou reimplementa a funcionalidade na tecnologia e arquitetura do projeto de destino. |
| `$sharingan mirror` | Espelhar projeto | Cria uma replica completa e segura do projeto em outro destino. |
| `$sharingan brand` | Personalizar identidade | Altera nome, marca, cores, textos, imagens, dominios e identificadores do projeto. |
| `$sharingan validate` | Validar integracao | Executa verificacoes, testes, lint, tipos e build, alem de revisar a qualidade da integracao. |
| `$sharingan audit` | Auditar projeto | Revisa licencas, segredos, referencias antigas, dependencias, acoplamento, duplicacao e codigo morto. |

## Skills e slash commands correspondentes

Os slash commands nao reutilizam o nome da skill. Nao invoque `/sharingan-catalog`, `/sharingan-mirror`, `/sharingan-transplant`, `/sharingan-brand` nem `/sharingan-validate` — esses nomes sao so de skills.

| `$sharingan` | Slash command | Skill | Subagente |
| --- | --- | --- | --- |
| `help` | `/sharingan-help` | `sharingan` | — |
| `list` | `/sharingan-list` | `sharingan-catalog` | `kakashi` |
| `inspect` | `/sharingan-inspect` | `sharingan-catalog` | `kakashi` |
| `compare` | `/sharingan-compare` | `sharingan-transplant` | `madara` |
| `plan` | `/sharingan-plan` | `sharingan-transplant` | `madara` |
| `integrate` | `/sharingan-integrate` | `sharingan-transplant` | `madara`, `danzo` |
| `mirror` | `/sharingan-clone` | `sharingan-mirror` | `danzo` |
| `brand` | `/sharingan-rebrand` | `sharingan-brand` | `obito` |
| `validate` | `/sharingan-check` | `sharingan-validate` | `itachi` |
| `audit` | `/sharingan-audit` | `sharingan-validate` | `itachi` |

## Regras de interpretacao

- Aceite caminhos locais e URLs Git. Coloque caminhos com espacos entre aspas.
- Aceite opcoes como `--nome valor` ou texto natural depois do comando.
- Infira a origem ou o destino a partir do projeto atual somente quando nao houver ambiguidade.
- O texto explicito do usuario prevalece sobre valores padrao e aliases.
- `--dry-run` proibe edicao de arquivos, instalacao de dependencias, inicializacao Git e outros efeitos persistentes. Entregue apenas analise e plano.
- `help`, `list`, `inspect`, `compare`, `plan` e `audit` sao somente leitura por padrao.
- `mirror`, `integrate` e `brand` autorizam alteracoes somente no destino indicado.
- `validate` pode executar verificacoes e builds, mas nao deve usar formatadores ou linters em modo de escrita sem pedido explicito.
- Para comando desconhecido, sugira o comando valido mais proximo. Se a intencao continuar clara em linguagem natural, execute-a conforme as regras gerais da skill.

## Opcoes comuns

- `--source <caminho-ou-url>`: projeto de origem.
- `--target <caminho>`: projeto de destino.
- `--feature <ID-ou-nome>`: funcionalidade; pode ser repetida ou receber IDs separados por virgula.
- `--ref <branch-tag-commit>`: estado Git da origem.
- `--output <arquivo>`: arquivo de saida para catalogo ou plano.
- `--depth quick|full`: profundidade da analise; `full` exige rastreabilidade ate o codigo.
- `--strategy auto|copy|adapt|reimplement`: estrategia de transplante.
- `--include-uncommitted`: inclui alteracoes locais nao commitadas da origem.
- `--checks <lista>`: verificacoes como `lint,types,test,build`.
- `--dry-run`: simula e produz um plano sem modificar projetos.

## `help`

Mostre primeiro a tabela de **Resumo dos comandos** exatamente com as tres colunas: comando, traducao e o que faz. Em seguida, liste aliases, opcoes comuns e um exemplo curto de cada comando. Para `$sharingan help <comando>`, mostre a traducao, a descricao detalhada, os parametros aceitos e exemplos apenas do comando solicitado.

```text
$sharingan help
$sharingan help integrate
```

## `list`

Aliases: `catalog`, `catalogar`.

Catalogue as funcionalidades da origem, atribua IDs estaveis e gere o mapa de dependencias. Nao altere codigo.

```text
$sharingan list --source "C:\projetos\projeto-a" --depth full
$sharingan list --source https://github.com/exemplo/projeto.git --output docs/catalogo.md
```

## `inspect`

Aliases: `show`, `detail`, `analisar`.

Analise uma funcionalidade do catalogo ponta a ponta, incluindo fluxo, arquivos, dependencias, configuracoes, testes e pontos de personalizacao.

```text
$sharingan inspect AI-01 --source "C:\projetos\projeto-a"
```

## `compare`

Aliases: `compat`, `compatibility`.

Compare uma funcionalidade da origem com a arquitetura do destino. Informe compatibilidade, lacunas e estrategia recomendada sem implementar.

```text
$sharingan compare AI-01 --source "C:\projeto-a" --target "C:\projeto-b"
```

## `plan`

Alias: `planejar`.

Produza um plano executavel de integracao, com fechamento de dependencias, etapas, riscos, testes e criterios de conclusao. Nao altere codigo.

```text
$sharingan plan AI-01,EDITOR-02 --source "C:\projeto-a" --target "C:\projeto-b"
```

## `integrate`

Aliases: `copy`, `transplant`, `integrar`.

Integre as funcionalidades selecionadas no destino. Calcule suas dependencias, adapte ou reimplemente na tecnologia do destino, aplique as praticas de qualidade da skill e valide o resultado.

```text
$sharingan integrate AI-01 --source "C:\projeto-a" --target "C:\projeto-b" --strategy auto
$sharingan integrate AI-01,GIT-02 --source "C:\projeto-a" --target "C:\projeto-b" --dry-run
```

## `mirror`

Aliases: `clone`, `replicate`, `espelhar`.

Crie uma replica completa em um destino novo, respeitando licencas e exclusoes de seguranca. Nao mantenha o historico ou o remoto de publicacao da origem por padrao.

```text
$sharingan mirror --source "C:\projeto-a" --target "C:\novo-projeto"
$sharingan mirror --source https://github.com/exemplo/projeto.git --ref v2.0.0 --target "C:\novo-projeto"
```

## `brand`

Aliases: `rebrand`, `personalizar`.

Mapeie e altere identidade visual, nome, textos, IDs tecnicos, dominios e metadados no destino. Preserve atribuicoes obrigatorias.

```text
$sharingan brand --target "C:\projeto-b" --name "Minha Marca" --primary "#6D28D9"
```

Opcoes livres de identidade, como `--logo`, `--domain`, `--support-email` e `--description`, podem ser usadas quando fizerem sentido para o projeto.

## `validate`

Aliases: `check`, `verificar`.

Execute as verificacoes relevantes do destino e revise a integracao quanto a comportamento, arquitetura, Clean Code, referencias antigas, segredos e licencas.

```text
$sharingan validate --target "C:\projeto-b" --checks lint,types,test,build
$sharingan validate AI-01 --target "C:\projeto-b"
```

## `audit`

Aliases: `review`, `auditar`.

Faca uma revisao somente leitura. Sem um foco explicito, cubra licencas, segredos, referencias a marca antiga, dependencias desnecessarias, acoplamento, duplicacao e codigo morto.

```text
$sharingan audit --target "C:\projeto-b"
$sharingan audit --target "C:\projeto-b" foco em licencas e atribuicoes
```

## Composicao

Execute comandos separados em ordem somente quando o usuario os combinar explicitamente. Interrompa a cadeia se um comando falhar de modo que torne o seguinte inseguro ou invalido.

```text
$sharingan list --source "C:\projeto-a"; depois integrate AI-01 --target "C:\projeto-b"; depois validate
```
