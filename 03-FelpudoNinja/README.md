## O que é:

Felpudo Ninja é um jogo para ser usado como fonte de estudo. Você pode olhar o código e copiar o que quiser desde que dê os devidos créditos ao autor do curso.
Se possível, vai lá e [compra o curso na Udemy](https://www.udemy.com/criacao-de-jogos-para-android-curso-completo). =]

Esta demonstração é um clone do famoso Fruit Ninja.

**Modificações que eu fiz em relação ao curso:**
- troquei os nomes das variáveis no script da fruta e também nos nodes do arquivo de scene da fruta.
- os "pedaços" da fruta agora começam com visibilidade hidden e só depois que a fruta é "cortada" que o código muda a visibilidade para true.
- na parte em que gera as frutas aleatoriamente, resolvi separar a lógica que retorna uma fruta de acordo com o número passado em uma função chamada getObj. Essa decisão foi apenas para separação de escopo e o resultado é o mesmo do exercício.

**Coisas interessantes aprendidas durante este módulo:**
- Raycast.
- Utilidade do _fixed_process().