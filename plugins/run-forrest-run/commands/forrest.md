---
name: forrest
description: "Analisa o projeto, verifica a máquina, recomenda configurações e roda o projeto após gate de confirmação (ex: /forrest, /forrest check, /forrest setup, /forrest run)."
---

Aplique a skill `run-forrest-run`. Este slash command chama-se `forrest`; a skill orquestradora chama-se `run-forrest-run`.

Interprete os argumentos (`$ARGUMENTS`) conforme abaixo:
- Sem argumentos ou `run`: executa o diagnóstico completo do projeto e da máquina, apresenta as recomendações e o **Gate de Confirmação**, e após aprovação do usuário configura o ambiente, instala dependências e coloca o projeto para rodar.
- `check` / `doctor` / `diagnostico`: executa apenas a Fase 1 e Fase 2 (somente leitura), entregando o diagnóstico detalhado do projeto e da máquina com recomendações de configuração, sem alterar nada.
- `setup` / `install` / `preparar`: executa o diagnóstico, apresenta o **Gate de Confirmação** e, após aprovação, configura a máquina, `.env`, banco de dados e instala as dependências, parando antes de iniciar o servidor.
- `env`: foca na análise e preparação segura das variáveis de ambiente (`.env.example` → `.env`) com confirmação prévia.
- `<alvo>` (ex: `web`, `api`, `backend`, `docker`): foca a análise, configuração e execução no pacote/serviço especificado.

Lembrete obrigatório: nunca execute instalações, mudanças na máquina ou alterações de arquivos antes de exibir o Plano de Execução no Gate de Confirmação e receber o "sim" do usuário.
