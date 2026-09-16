---
name: sharingan-validate
description: Validar uma replica ou transplante e auditar licencas, segredos, referencias antigas, testes, lint, tipos e qualidade. Use para $sharingan validate, audit, verificar integracao ou revisar o destino. Nao altere formatadores sem pedido explicito.
---

# Validacao Sharingan

Use o subagente `itachi` para a revisao somente leitura de licencas, segredos e atribuicoes. Nao declare equivalencia completa se verificacoes essenciais nao puderam ser executadas.

## Validar

Depois da copia, do transplante ou da personalizacao:

1. Compare a estrutura relevante da origem com o destino e explique exclusoes intencionais.
2. Procure referencias residuais a identidade antiga e classifique as que devem permanecer.
3. Instale dependencias apenas quando necessario e permitido pelo pedido.
4. Execute os comandos existentes de build, testes, lint e verificacao de tipos proporcionais ao projeto.
5. Confirme que nenhum segredo ou remoto de publicacao indesejado foi levado ao destino.
6. Revise o codigo integrado quanto a acoplamento, duplicacao, tratamento de erros, consistencia arquitetural e aderencia aos padroes do destino.

`--checks` aceita listas como `lint,types,test,build`. Nao use formatadores ou linters em modo de escrita sem pedido explicito.

Informe claramente o que foi validado e o que ficou pendente.

## Auditar

Sem um foco explicito, cubra licencas, segredos, referencias a marca antiga, dependencias desnecessarias, acoplamento, duplicacao e codigo morto. Auditoria e somente leitura por padrao.

## Entrega

Resuma origem, destino, exclusoes, identidade, licenca, resultados das verificacoes, referencias antigas restantes e proximos ajustes. Para transplantes, inclua funcionalidades, dependencias, decisoes de copiar/adaptar/reimplementar e lacunas.
