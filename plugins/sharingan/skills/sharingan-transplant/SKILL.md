---
name: sharingan-transplant
description: Comparar, planejar e integrar funcionalidades selecionadas de um projeto autorizado em outro, copiando, adaptando ou reimplementando na stack do destino. Use para $sharingan compare, plan ou integrate. Nao copie software sem permissao.
---

# Transplante Sharingan

Antes de alterar o destino, leia as instrucoes e mapeie a arquitetura dos dois projetos. Catalogos incompletos devem passar pela skill `sharingan-catalog` primeiro.

Delegue analise somente leitura ao subagente `madara`. Delegue a implementacao ao `danzo` depois que o plano for aceito ou o usuario pedir a alteracao.

## Comparar e planejar

Para cada funcionalidade escolhida:

1. Calcule o fechamento de dependencias: componentes compartilhados, tipos, estado, comandos nativos, banco, configuracoes, assets e testes sem os quais ela nao funciona.
2. Compare stacks, versoes, modelos de dados, autenticacao, convencoes e licencas.
3. Escolha entre copiar, adaptar ou reimplementar. Prefira reimplementar a interface quando a copia direta criaria forte acoplamento ou conflito arquitetural.
4. Produza um plano de integracao quando o usuario pediu somente analise; implemente quando ele pediu a alteracao.

O plano deve incluir etapas, riscos, testes, criterios de conclusao e o mapa de copiar/adaptar/reimplementar. `--dry-run` nunca grava arquivos.

## Integrar

Integre em unidades verificaveis, seguindo a arquitetura, o design system e os padroes do projeto de destino. Adapte a identidade sem remover atribuicoes legalmente obrigatorias. Execute testes da funcionalidade e testes de regressao do destino.

Nao copie apenas a tela quando o comportamento depender de backend, camada nativa, persistencia ou integracoes. Nao leve modulos compartilhados inteiros sem identificar quais partes sao realmente necessarias.

## Adaptar a tecnologia de destino

Trate o comportamento, os fluxos e os contratos da funcionalidade de origem como especificacao. Implemente-os com a linguagem, o framework, as bibliotecas e as convencoes ja adotadas pelo projeto de destino.

- Nao introduza a stack da origem no destino apenas para facilitar a copia.
- Mapeie componentes, servicos, estado, persistencia, eventos e APIs para os equivalentes naturais da stack de destino.
- Reutilize autenticacao, autorizacao, observabilidade, tratamento de erros, design system, configuracao e infraestrutura ja existentes no destino.
- Crie adaptadores nas fronteiras com servicos externos ou formatos incompativeis, sem espalhar detalhes de integracao pelo dominio.
- Preserve contratos publicos quando necessario ou forneca uma migracao explicita e testada.
- Quando nao houver equivalente direto, reimplemente o comportamento em vez de traduzir o codigo linha a linha.

Tecnologia diferente nao e, por si so, um bloqueio. Se a stack for proprietaria, desconhecida, inacessivel ou nao puder ser executada no ambiente disponivel, produza o mapeamento e o plano de implementacao, declare a limitacao e nao finja que a integracao foi validada.

## Qualidade do codigo

Siga primeiro os padroes documentados no projeto de destino. Na ausencia deles, aplique praticas de Clean Code de forma pragmatica:

- nomes claros e alinhados ao dominio;
- funcoes e componentes coesos, com responsabilidades bem definidas;
- dependencias explicitas e fronteiras testaveis;
- duplicacao removida quando houver uma abstracao estavel, sem generalizacao prematura;
- tratamento consistente de erros, validacao de entradas e estados vazios;
- separacao entre regras de negocio, infraestrutura e apresentacao quando essa separacao reduzir acoplamento;
- comentarios para explicar decisoes e restricoes, nao para repetir o codigo;
- ausencia de codigo morto, atalhos temporarios e novas dividas tecnicas sem justificativa registrada.

Crie ou adapte testes que protejam os comportamentos importantes da funcionalidade. Execute formatacao, lint, verificacao de tipos, testes unitarios, testes de integracao e build conforme existirem e forem relevantes no projeto. Use testes de caracterizacao quando o comportamento da origem precisar ser preservado durante uma reimplementacao.
