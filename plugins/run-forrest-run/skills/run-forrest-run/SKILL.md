---
name: run-forrest-run
description: Analisa o projeto, verifica dependências, diagnostica e configura a máquina do usuário, recomenda ajustes de ambiente e instala dependências para colocar o projeto para rodar, exigindo um gate obrigatório de confirmação antes de qualquer alteração ou instalação. Use quando o usuário pedir para rodar o projeto, subir o ambiente, configurar a máquina para o repositório, diagnosticar por que não roda ou acionar /forrest, /rodar, /preparar, /diagnosticar ou $forrest.
---

# Run, Forrest, Run!

Coloque qualquer projeto para rodar na máquina do usuário com segurança, diagnóstico preciso e transparência total.

> **Regra de Ouro (Gate Obrigatório):** Nunca instale pacotes globais, não altere configurações da máquina, não crie/sobrescreva arquivos `.env`, não instale dependências e não suba containers/servidores sem antes apresentar o **Relatório de Diagnóstico + Plano de Execução** e receber a confirmação explícita do usuário.

---

## Fluxo em 4 Fases

### Fase 1: Diagnóstico do Projeto e da Máquina (100% Somente Leitura)

Antes de propor ou executar qualquer ação, inspecione o repositório e o ambiente local sem modificar nada:

1. **Raio-X do Projeto**:
   - Leia `README.md`, `CONTRIBUTING.md`, `AGENTS.md`, `Makefile`, `Justfile`, `Taskfile.yml`, `Procfile` e scripts em `scripts/` ou `bin/`.
   - Identifique a(s) linguagem(ns), framework(s), arquitetura (monólito, monorepo, workspaces) e gerenciador de pacotes exato pelo lockfile (`pnpm-lock.yaml`, `yarn.lock`, `bun.lock`/`bun.lockb`, `package-lock.json`, `uv.lock`, `poetry.lock`, `Pipfile.lock`, `Cargo.lock`, `go.sum`, `Gemfile.lock`, `composer.lock`).
   - Detecte versões exigidas de runtime (`.nvmrc`, `.node-version`, `.python-version`, `.ruby-version`, `.tool-versions`, `mise.toml`, `rust-toolchain.toml`, `.sdkmanrc`, `global.json`, campo `engines` no `package.json`, `requires-python` no `pyproject.toml`, diretiva `go` no `go.mod`).
   - Mapeie variáveis de ambiente necessárias lendo `.env.example`, `.env.sample`, `.env.template` ou schemas de validação (ex.: `env.ts`, `settings.py`, `config/`). Nunca leia nem exponha valores sensíveis de um `.env` real já preenchido — apenas verifique se o arquivo existe e quais chaves do `.env.example` estão ausentes.
   - Identifique serviços de infraestrutura (`docker-compose.yml`, `compose.yaml`, `Dockerfile`, bancos como PostgreSQL, MySQL, Redis, MongoDB, filas como RabbitMQ/Kafka, Supabase, LocalStack) e etapas de preparação (migrations, seeds, codegen como `prisma generate`).

2. **Verificação da Máquina do Usuário**:
   - Verifique o sistema operacional e arquitetura (`uname -s -m` ou equivalente).
   - Cheque se os runtimes e gerenciadores exigidos estão instalados e em qual versão (`node -v`, `python3 --version`, `go version`, `rustc --version`, `java -version`, `docker --version`, `docker info`, etc.).
   - Verifique gerenciadores de versão e pacotes disponíveis na máquina (`mise`, `asdf`, `fnm`, `nvm`, `volta`, `pyenv`, `uv`, `sdkman`, `brew`, `apt`, `winget`, etc.).
   - Verifique se as dependências do projeto já estão instaladas localmente (`node_modules`, `.venv`, `vendor`, `target`) e se estão sincronizadas.
   - Verifique se as portas necessárias pelo projeto e pelos containers já estão em uso (`lsof -i :<porta>`).

Para detalhes de detecção por linguagem e comandos de verificação, consulte [references/diagnostico-e-stacks.md](references/diagnostico-e-stacks.md).

---

### Fase 2: Recomendações e Gate de Confirmação (PARADA OBRIGATÓRIA)

Apresente ao usuário um resumo estruturado e claro antes de tocar no sistema:

```markdown
## 🏃‍♂️ Diagnóstico Run, Forrest, Run!

### 1. Projeto Detectado
- **Stack / Arquitetura:** <ex: Monorepo Turborepo com Next.js 15 + API Fastify (Node >= 20) + PostgreSQL + Redis>
- **Gerenciador de Pacotes:** <ex: pnpm 9.x (detectado via pnpm-lock.yaml)>
- **Comandos de Execução:** <ex: `pnpm dev` (portas 3000 e 3333)>

### 2. Estado da Máquina e Ambiente
- [✓] <Item OK — ex: macOS arm64, Homebrew instalado, Docker rodando>
- [!] <Divergência — ex: Node atual é v18.19.0, mas o `.nvmrc` pede v20.x>
- [✗] <Ausente — ex: `pnpm` não encontrado, arquivo `.env` não existe, `node_modules` ausente>

### 3. Recomendações de Configuração
- <Recomendação 1 — ex: Usar `fnm` ou `nvm` já presente na máquina para ativar Node 20 sem sobrescrever binários globais>
- <Recomendação 2 — ex: Subir PostgreSQL e Redis via `docker compose up -d` em vez de instalar serviços nativos na máquina>
- <Recomendação 3 — ex: Preencher a chave `STRIPE_SECRET_KEY` no `.env` caso vá testar pagamentos (opcional para boot inicial)>

### 4. O que será feito (Plano de Execução)
1. **Máquina / Runtime:** `<comando exato>` — <explicação curta>
2. **Variáveis de Ambiente:** `<ação em .env>` — <explicação curta>
3. **Dependências:** `<comando exato>` — <explicação curta>
4. **Infra / Banco de Dados:** `<comando exato>` — <explicação curta>
5. **Inicialização:** `<comando para rodar o projeto>`

---
**Posso prosseguir com essas etapas?** (Você pode aprovar tudo, pedir ajustes ou escolher apenas parte dos passos).
```

> **Importante:** Se o usuário acionou apenas o modo de diagnóstico (`/diagnosticar` ou `$forrest check`), encerre após exibir o relatório acima sem executar alterações.Nos demais modos (`/rodar`, `/preparar`, `/forrest`), **aguarde a confirmação do usuário** antes de passar para a Fase 3.

---

### Fase 3: Configuração da Máquina e Instalação de Dependências (Pós-Confirmação)

Assim que o usuário confirmar (total ou parcialmente), execute apenas o que foi autorizado, seguindo estas diretrizes de segurança:

1. **Configuração da Máquina e Runtimes**:
   - Prefira sempre gerenciadores de versão de espaço de usuário (`mise`, `asdf`, `fnm`, `nvm`, `pyenv`, `uv`, `rustup`, `sdkman` ou `corepack`) em vez de alterar instalações globais do sistema operacional.
   - Nunca execute comandos com `sudo` sem que isso tenha sido destacado explicitamente no Gate de Confirmação.
2. **Arquivos de Configuração e `.env`**:
   - Se o `.env` não existir e houver `.env.example` (ou equivalente), crie o `.env` preenchendo valores seguros de desenvolvimento local (URLs de banco local, portas padrão, secrets de dev gerados localmente).
   - Se o `.env` já existir, **nunca sobrescreva** o arquivo inteiro; apenas adicione chaves novas que estejam faltando (com backup ou aviso prévio).
3. **Infraestrutura Local e Containers**:
   - Suba containers necessários (`docker compose up -d`) e aguarde até que os serviços estejam saudáveis (`healthy` / porta respondendo) antes de rodar migrations.
4. **Instalação de Dependências e Preparação**:
   - Use estritamente o gerenciador correspondente ao lockfile do projeto.
   - Execute etapas pós-instalação necessárias (codegen, build de pacotes compartilhados em monorepos, migrations de desenvolvimento e seeds iniciais).

---

### Fase 4: Rodar o Projeto e Verificar Saúde

*(Se o usuário pediu apenas `/preparar` ou `$forrest setup`, pare ao final da Fase 3 e informe o comando pronto para rodar).*

Quando o objetivo incluir rodar o projeto (`/rodar`, `/forrest run` ou pedido direto):

1. Inicie o comando principal de desenvolvimento/execução do projeto.
2. Acompanhe os primeiros segundos dos logs de inicialização para garantir que não houve erro de compilação, variável ausente ou falha de conexão com banco.
3. Confirme se a porta da aplicação está respondendo.
4. Entregue o resumo final com:
   - **Status da aplicação** (rodando / portas ativas);
   - **URLs de acesso** (frontend, API, Swagger/Docs, dashboard do banco/filas);
   - **Credenciais de teste** (se geradas por seed local);
   - **Como parar ou reiniciar** os serviços.

---

## Comandos Rápidos e Sintaxe Conversacional

Os slash commands em `commands/` possuem nomes distintos da skill `run-forrest-run` para evitar colisão no roteamento do agente:

| Slash Command | Sintaxe `$forrest` | Comportamento |
| :--- | :--- | :--- |
| `/forrest` | `$forrest [modo]` | Orquestrador geral (`check`, `setup`, `run`, `env`, `doctor` ou alvo como `api`, `web`). |
| `/rodar` | `$forrest run` | Fluxo completo: diagnostica → **Gate de Confirmação** → configura máquina → instala deps → roda o projeto. |
| `/preparar` | `$forrest setup` | Diagnostica → **Gate de Confirmação** → configura máquina, `.env`, banco e instala dependências (sem subir o servidor final). |
| `/diagnosticar` | `$forrest check` | Somente leitura: analisa o projeto e a máquina, lista dependências faltantes e recomenda configurações. |
