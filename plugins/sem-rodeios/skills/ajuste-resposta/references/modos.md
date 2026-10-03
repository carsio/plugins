# Referência Detalhada dos Modos do Sem Rodeios

Este documento contém os parâmetros estritos e exemplos de saída para cada modo do plugin **Sem Rodeios**.

---

## 1. Modo Curto (`/curto`, `$tom curto`)

### Parâmetros
- **Limite de linhas/bullets**: 3 a 5 linhas ou bullets objetivos.
- **Formato**: Markdown direto, sem saudações ou despedidas.
- **Proibições**:
  - Frases como "Com certeza, vou te ajudar!", "Espero ter respondido sua dúvida!", "Segue abaixo a explicação:".
  - Explicações redundantes de sintaxe óbvia.

### Exemplo
```markdown
* JWT armazena claims assinadas criptograficamente em Base64URL no formato `header.payload.signature`.
* Não armazene segredos ou dados sensíveis no payload (ele é decodificável por qualquer cliente).
* Valide sempre a assinatura e a expiração (`exp`) no servidor antes de autorizar qualquer requisição.
```

---

## 2. Modo Técnico (`/tech`, `$tom tech`)

### Parâmetros
- **Linguagem**: Dev sênior / Arquiteto de software.
- **Foco**:
  - Complexidade de tempo ($O(n)$) e espaço.
  - Tipagem estrita e contratos de interface.
  - Comportamento de concorrência e memória.
  - Comandos Unix / CLI exatos.
- **Proibições**: Metáforas infantis ("Imagine que a internet é uma rodovia..."), rodeios corporativos.

---

## 3. Modo Negócio (`/biz`, `$tom biz`)

### Parâmetros
- **Linguagem**: Executiva, clara e orientada a produto / PM.
- **Foco**:
  - Custo operacional e financeiro (infraestrutura, horas de desenvolvimento).
  - Experiência do usuário (UX) e conversão/retenção.
  - Riscos de compliance (LGPD, segurança) e SLA.
  - Prazos e viabilidade de entrega.
- **Proibições**: Siglas técnicas sem tradução para impacto de negócio; detalhes de baixo nível irrelevantes para tomada de decisão.

---

## 4. Modo Didático (`/didatico`, `$tom didatico`)

### Parâmetros
- **Linguagem**: Mentor / Professor atencioso.
- **Foco**:
  - Explicar o *problema* que a tecnologia resolve antes de mostrar o código.
  - Usar analogias práticas do mundo real.
  - Dividir o aprendizado em passos incrementais com validação em cada etapa.

---

## 5. Modo Apenas Código (`/code`, `$tom code`)

### Parâmetros
- **Formato**: Apenas bloco de código markdown (````lang ... ````).
- **Proibições**: Qualquer caractere fora dos blocos de código.
- **Comentários**: Apenas comentários inline se forem indispensáveis para compilar/executar.
