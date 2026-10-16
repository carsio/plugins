# Run, Forrest, Run!

Plugin para **analisar qualquer projeto**, **verificar dependências**, **diagnosticar e configurar a máquina do usuário**, **recomendar configurações** e **instalar tudo para colocar o projeto para rodar** — sempre protegido por um **Gate de Confirmação obrigatório** antes de qualquer alteração no sistema ou no repositório.

Compatível com **Cursor**, **Claude Code** e **BitHub** (incluindo instalação como skills para **Codex**, **Antigravity CLI** e **Copilot CLI**).

---

## Como Funciona (Fluxo em 4 Fases)

1. **Diagnóstico (Somente Leitura)**
   - Analisa o repositório: stack, arquitetura (monólito/monorepo), lockfiles (`pnpm`, `yarn`, `bun`, `npm`, `uv`, `poetry`, `cargo`, `go.mod`, `gradlew`, `bundle`, `composer`), versões exigidas (`.nvmrc`, `.python-version`, `.tool-versions`, `mise.toml`), templates `.env.example`, containers Docker e scripts de migração/start.
   - Verifica a máquina do usuário: sistema operacional, versões de runtimes instalados, gerenciadores de versão (`mise`, `asdf`, `fnm`, `nvm`, `pyenv`, `uv`), status do Docker e portas em uso.
2. **Recomendações + Gate de Confirmação (Parada Obrigatória)**
   - Apresenta um relatório claro com o que está `[✓] OK`, `[!] Divergente` e `[✗] Ausente`.
   - Recomenda as melhores configurações para a máquina do usuário (ex.: usar gerenciador de versão em vez de alterar binários globais, subir bancos via Docker Compose, variáveis `.env` obrigatórias vs. opcionais).
   - **Explica passo a passo o que será feito** e aguarda a confirmação explícita do usuário antes de tocar na máquina ou no projeto.
3. **Configuração e Instalação (Pós-Confirmação)**
   - Configura runtimes e ferramentas autorizadas, cria/ajusta o `.env` sem sobrescrever segredos existentes, sobe serviços Docker, instala dependências respeitando o lockfile e executa codegen/migrations.
4. **Execução ("Run, Forrest, Run!")**
   - Sobe o projeto, valida os logs iniciais e a resposta da porta, e entrega o resumo com URLs locais e instruções de uso.

---

## Comandos Rápidos

Slash commands e a skill principal possuem nomes distintos de propósito para evitar colisão de roteamento nos agentes:

| Slash Command | Sintaxe `$forrest` | Skill Acionada | O que faz |
| :--- | :--- | :--- | :--- |
| `/rodar` | `$forrest run` | `run-forrest-run` | Fluxo completo: diagnostica → **Gate de Confirmação** → configura máquina → instala dependências → roda o projeto. |
| `/preparar` | `$forrest setup` | `run-forrest-run` | Diagnostica → **Gate de Confirmação** → configura máquina, `.env`, containers e instala dependências (sem iniciar o servidor). |
| `/diagnosticar` | `$forrest check` | `run-forrest-run` | Somente leitura: analisa o projeto e a máquina, aponta o que falta e recomenda configurações. |
| `/forrest` | `$forrest [modo]` | `run-forrest-run` | Comando curinga: aceita `check`, `setup`, `run`, `env`, `doctor` ou o nome de um serviço específico (ex: `/forrest api`). |

---

## Subagente

- **`forrest`** (`agents/forrest.md`) — Subagente somente-leitura especializado em inspecionar rapidamente o repositório e o ambiente da máquina para montar o relatório do Gate de Confirmação.

---

## Exemplos de Uso

### 1. Subir um projeto recém-clonado
```text
/rodar
```
O agente analisa o projeto e sua máquina, mostra o que falta (ex: Node 20, `pnpm`, `.env`, container do Postgres), recomenda a configuração ideal e pergunta: *"Posso prosseguir com essas etapas?"*. Após sua confirmação, instala tudo e sobe a aplicação.

### 2. Apenas diagnosticar o ambiente sem instalar nada
```text
/diagnosticar
```
Exibe o checklist completo de dependências, versões, portas ocupadas e recomendações sem modificar nenhum arquivo.

### 3. Preparar apenas um pacote do monorepo
```text
/forrest setup backend
```

---

## Estrutura do Plugin

- `assets/logo.png` — logo oficial do plugin.
- `skills/run-forrest-run/` — skill principal com o fluxo em 4 fases e matriz de referência por stack (`references/diagnostico-e-stacks.md`).
- `commands/` — slash commands (`/forrest`, `/rodar`, `/preparar`, `/diagnosticar`).
- `agents/forrest.md` — subagente de diagnóstico rápido do projeto e da máquina.
- `rules/gate-confirmacao-forrest.mdc` — regra sempre ativa que garante o diagnóstico prévio e o Gate de Confirmação quando o usuário pede para rodar ou configurar o projeto em linguagem natural.
