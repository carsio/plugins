# plugins

Marketplace público de plugins para **Cursor**, **Claude Code** e **Bithub**.

O catálogo vive em três manifests na raiz do repositório. Mantenha os arrays `plugins` alinhados ao adicionar um plugin novo.

| Produto | Manifesto |
| --- | --- |
| Cursor | [`.cursor-plugin/marketplace.json`](.cursor-plugin/marketplace.json) |
| Claude Code | [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json) |
| Bithub | [`.bithub-plugin/marketplace.json`](.bithub-plugin/marketplace.json) |

Cada plugin fica em `plugins/<nome>` e precisa de um manifesto próprio (`.cursor-plugin/plugin.json`, `.claude-plugin/plugin.json` e/ou `.bithub-plugin/plugin.json`), além dos recursos em `skills/`, `commands/`, `agents/`, `rules/`, `hooks/` e `mcp.json` quando existirem.

## Como adicionar este marketplace

**Cursor** — em Customize, adicione `https://github.com/carsio/plugins`.

**Claude Code**

```text
/plugin marketplace add https://github.com/carsio/plugins.git
```

**Bithub** — em Personalizar › Explorar, importe a mesma URL do repositório.

## Estrutura

```text
.cursor-plugin/marketplace.json
.claude-plugin/marketplace.json
.bithub-plugin/marketplace.json
plugins/
  <plugin>/
    .cursor-plugin/plugin.json
    .claude-plugin/plugin.json
    .bithub-plugin/plugin.json
    skills/
    commands/
    agents/
    rules/
    hooks/
    mcp.json
```
