# FeedbackBoard

Plugin que sobe o MCP remoto do [FeedbackBoard](https://feedbackboard.space) e pede o token na instalação (`userConfig`).

## Configuração

Na instalação (Claude Code / Bithub), informe o **Token MCP** pessoal.

1. Entre em [feedbackboard.space](https://feedbackboard.space).
2. Abra **Conectar IA**.
3. Crie um token (prefixo `fbmcp_`) e cole no plugin.

O valor fica no cofre; o repositório só referencia `${user_config.api_token}`.

## MCP

```json
{
  "mcpServers": {
    "feedbackboard": {
      "type": "http",
      "url": "https://feedbackboard.space/api/mcp",
      "headers": {
        "Authorization": "Bearer ${user_config.api_token}"
      }
    }
  }
}
```

## Tools

| Tool | Uso |
| --- | --- |
| `list_projects` | Projetos acessíveis |
| `list_feedbacks` | Filtrar relatos |
| `get_feedback` | Detalhe + anexos |
| `update_feedback` | Status / tipo / resolução |
| `summarize_project` | Contagens da fila |
