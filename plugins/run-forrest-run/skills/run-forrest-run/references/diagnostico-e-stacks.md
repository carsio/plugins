# Referência de Diagnóstico, Stacks e Configuração de Máquina

Este guia apoia a skill `run-forrest-run` na detecção precisa de dependências, ferramentas de sistema e boas práticas de configuração por ecossistema.

---

## 1. Matriz de Detecção de Ecossistemas e Lockfiles

Sempre respeite o gerenciador de pacotes definido pelo lockfile do repositório:

| Ecossistema | Arquivos de Detecção | Regra de Gerenciador / Runtime | Comando de Instalação Padrão |
| :--- | :--- | :--- | :--- |
| **Node.js / TS** | `package.json` + `pnpm-lock.yaml` | Usar `pnpm` (ativar via `corepack enable` se necessário). Checar `.nvmrc` / `.node-version` / `engines`. | `pnpm install` |
| **Node.js / TS** | `package.json` + `yarn.lock` | Usar `yarn` (checar `packageManager` no `package.json` para Yarn Classic vs Berry). | `yarn install` |
| **Node.js / TS** | `package.json` + `bun.lock` ou `bun.lockb` | Usar `bun`. | `bun install` |
| **Node.js / TS** | `package.json` + `package-lock.json` | Usar `npm`. | `npm install` |
| **Python** | `pyproject.toml` + `uv.lock` | Usar `uv` (gerencia Python e virtualenv automaticamente). | `uv sync` |
| **Python** | `pyproject.toml` + `poetry.lock` | Usar `poetry`. | `poetry install` |
| **Python** | `Pipfile` / `Pipfile.lock` | Usar `pipenv`. | `pipenv install --dev` |
| **Python** | `requirements.txt` / `requirements-dev.txt` | Criar e ativar `.venv` (`python3 -m venv .venv` ou `uv venv`) antes de instalar. Nunca instalar direto no Python global do sistema. | `.venv/bin/pip install -r requirements.txt` |
| **Go** | `go.mod`, `go.sum` | Checar versão mínima na diretiva `go` do `go.mod`. Verificar ferramentas extras (`air`, `golangci-lint`, `sqlc`, `migrate`). | `go mod download` |
| **Rust** | `Cargo.toml`, `rust-toolchain.toml` | Usar `rustup` / `cargo`. Verificar componentes ou targets exigidos e bibliotecas nativas (`pkg-config`, `openssl`). | `cargo fetch` / `cargo build` |
| **Java / Kotlin** | `pom.xml`, `build.gradle(.kts)`, `.sdkmanrc` | Preferir wrappers do projeto (`./mvnw`, `./gradlew`) sobre binários globais. Checar versão do JDK (`java -version`). | `./gradlew classes` ou `./mvnw test-compile` |
| **Ruby** | `Gemfile`, `Gemfile.lock`, `.ruby-version` | Usar `bundle` com a versão do Ruby indicada (`rbenv` / `asdf` / `mise`). | `bundle install` |
| **PHP** | `composer.json`, `composer.lock` | Usar `composer` (ou Laravel Sail / Docker se presente). | `composer install` |
| **Elixir** | `mix.exs`, `mix.lock` | Verificar Elixir + Erlang/OTP (`asdf` / `mise`). | `mix deps.get` |
| **.NET** | `*.sln`, `*.csproj`, `global.json` | Verificar `dotnet --list-sdks` contra `global.json`. | `dotnet restore` |

---

## 2. Diagnóstico da Máquina do Usuário

Execute apenas comandos rápidos e não-destrutivos durante a Fase 1:

### Sistema e Gerenciadores Base
- **OS / Arch**: `uname -s -m` (Unix/macOS) ou variáveis de ambiente no Windows.
- **Gerenciadores de versão universais**: `which mise asdf` — se o usuário já utiliza `mise` ou `asdf`, recomende sempre instalar runtimes faltantes por meio deles (`mise install` / `asdf install`).
- **Gerenciadores de pacotes do SO**:
  - **macOS**: `brew --version`
  - **Linux**: `apt --version`, `dnf --version`, `pacman --version`, `apk --version`
  - **Windows**: `winget --version`, `scoop --version`, `choco --version`

### Containers e Virtualização
- Se o projeto possuir `docker-compose.yml`, `compose.yaml` ou `Dockerfile`:
  1. Verifique se o CLI existe: `docker --version` e `docker compose version`.
  2. Verifique se o daemon está rodando: `docker info >/dev/null 2>&1`.
  3. Se o daemon estiver parado no macOS/Linux, identifique se o usuário tem **OrbStack**, **Docker Desktop**, **Colima** ou **Rancher Desktop** instalado e recomende iniciá-lo.

### Portas e Processos Conflitantes
- Identifique as portas padrão do projeto (ex: `3000`, `5173`, `8000`, `8080`, `5432`, `6379`, `27017`).
- Verifique se já estão ocupadas:
  - macOS / Linux: `lsof -nP -iTCP:<porta> -sTCP:LISTEN`
  - Informe no diagnóstico qual processo (nome e PID) está ocupando a porta e recomende no plano mudar a porta no `.env` ou encerrar o processo conflitante.

---

## 3. Boas Práticas de Recomendação de Configuração

Ao montar a seção **Recomendações de Configuração** no Gate de Confirmação:

1. **Isolamento de Runtimes**:
   - Se o projeto pede uma versão de Node, Python, Java ou Ruby diferente da instalada globalmente, recomende usar um gerenciador de versão (`fnm`, `nvm`, `mise`, `asdf`, `uv`, `pyenv`, `sdkman`) para não quebrar outros projetos da máquina do usuário.
2. **Isolamento de Serviços de Dados**:
   - Se o projeto precisa de banco de dados (Postgres, MySQL, Mongo) ou cache/fila (Redis, RabbitMQ) e há `docker-compose.yml`, recomende subir apenas os serviços de infra via Docker (`docker compose up -d postgres redis`) e rodar a aplicação em modo dev no host para ter hot-reload rápido, ou rodar tudo via Docker se o usuário preferir não instalar o runtime no host.
3. **Variáveis de Ambiente Seguras**:
   - Separe claramente variáveis que possuem valor padrão de desenvolvimento (ex: `PORT=3000`, `DATABASE_URL=postgresql://postgres:postgres@localhost:5432/app_dev`, `JWT_SECRET=dev-secret-local`) daquelas que exigem credenciais externas reais (ex: `OPENAI_API_KEY`, `AWS_ACCESS_KEY_ID`).
   - Avise o usuário quando uma chave externa for opcional para o projeto subir vs. obrigatória no boot.
4. **Monorepos (Turborepo, Nx, pnpm workspaces, Lerna, Cargo workspace)**:
   - Identifique se pacotes internos (`packages/ui`, `packages/shared`, `packages/db`) precisam de um `build` inicial ou geração de tipos (`prisma generate`) antes que o comando `dev` funcione sem erros.

---

## 4. Tratamento de Problemas Comuns (Modo Doctor)

Se o projeto falhar ao instalar dependências ou ao subir na Fase 4:

- **Conflito de peer dependencies no npm**: explique o conflito e pergunte se pode usar `--legacy-peer-deps` ou se o projeto deveria usar outro gerenciador.
- **Módulos nativos falhando no build (`node-gyp`, `psycopg2`, `mysqlclient`, `sharp`, `openssl-sys`)**: identifique a biblioteca de sistema ausente (ex: `Xcode Command Line Tools` no macOS, `build-essential` / `libpq-dev` no Linux, `pkg-config`) e proponha a correção exata.
- **Banco de dados recusando conexão (`ECONNREFUSED 5432`)**: verifique se o container subiu, se a porta mapeada no `docker-compose.yml` bate com a porta do `.env` e se as migrations já foram executadas.
