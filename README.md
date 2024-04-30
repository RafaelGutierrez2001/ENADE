# Sobre o Projeto

Este projeto consistiu em uma análise simples realizada para o trabalho final de Econometria nas minhas aulas de Economia. O objetivo foi analisar estatisticamente o 
impacto da participação no programa Ciência sem Fronteiras em comparação com quem não participou de programas de intercambio (Poderia também pegar a comparação com pessoas que participaram de outros tipos de intercambio).
Para isso, utilizei uma medida empírica, que foram as notas do ENADE de 2014.

O ENADE possui uma distinção em seu formulário que identifica os alunos participantes de programas como o 
Ciência Sem Fronteiras. Com base nesses dados, apliquei o método de Propensity Score Matching para controlar as variáveis confundidoras e isolar o efeito da participação no programa sobre o desempenho acadêmico.
Este repositório contém todos os scripts utilizados na análise, bem como uma descrição detalhada dos processos e metodologias aplicadas.

Vale colocar que estou ainda começando a utilizar a linguagem R, dicas e observações dos códigos são válidas e bem vindas!

*Observação: Os dados em formato csv. desta pesquisa foram pegos de um banco de dados de um professor meu. Caso queiram o csv. pode entrar em contato comigo que envio sem problemas.

# Metodologia

Para fazer a avaliação do programa frente aos outros, utilizei um método econométrico bastante famoso, chamado Propensity Score Matching (PSM). 
O PSM é uma técnica estatística que permite estimar o efeito de uma intervenção, tratamento ou política comparando os grupos de tratamento e controle de maneira que sejam similares em termos de variáveis observadas.
Este método ajusta pela probabilidade de cada unidade ser atribuída ao tratamento com base em variáveis observáveis, reduzindo assim o viés de seleção e permitindo uma avaliação mais precisa dos efeitos causais.

## Variaveis utilizadas

Variáveis: CiênciasSemFronteiras (Dummy), Sexo (Dummy), nu_Idade (numérico), Solteiro (Dummy), FacPublica (Dummy), escpublica (Dummy), Renda (Numérico&Milhar), familiarestudado (Dummy), leitura (Numérico&Qtd.livros), 
qtdestudos (Númerico&Horas)


# Explicação do código

No código, temos a filtragem e seleção dos dados que vou analisar, visto que, para fazermos um PSM, tenho que ter variáveis que sao pareaveis (numéricas) e o banco de dados temos respostas não numéricas por se
tratar de uma prova. Portanto, inicialmente vou arrumando de forma que seja possível parear (Os passos estão no código).

E após os tratamentos, faço o pareamento, para que as regressões possam ser feitas apenas com os indíviduos pareados (harmonizando as diferenças pré-existentes);

Com isto, faço a regressão com os pareados, com todos os grupos, e também utilizando do método de pesos dado pelo MatchIT, que nos dá os devidos pesos de cada variável para a regressão

## Matching
![Matching]([URL_da_Imagem](https://imgur.com/gallery/uuKlU2C))



Sample Sizes:
          Control Treated
All        401253    5890
Matched      5890    5890
Unmatched  395363       0
Discarded       0       0


 
