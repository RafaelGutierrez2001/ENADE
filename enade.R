# Vamos instalar as bibliotecas usadas
install.packages("MatchIt")
install.packages("AER")
install.packages("dplyr")
install.packages("stargazer")
install.packages("survey")

# Introduzindo as bibliotecas no R
library(AER)
library(MatchIt)
library(dplyr)
library(stargazer)
library(survey)

# Importando os dados do computador. Troue o diretório para o seu diretório 

dados <- read.csv("C:/Users/Rafael/OneDrive - Céleres/Documentos/microdados/microdados_enade_2014.csv", sep = ";", header = TRUE)


# Transformar a variável 'Sexo'

dados$Sexo <- as.numeric(ifelse(dados$tp_sexo == "M", 1, 
                                ifelse(dados$tp_sexo == "F", 0, 1)))

# Transformar a variável 'Solteiro'
dados$Solteiro <- as.numeric(ifelse(toupper(dados$qe_i1) == "A", 1, 0))

# Transformar a variável 'FacPublica'
dados$FacPublica <- as.numeric(ifelse(toupper(dados$qe_i11) == "A", 1, 0))

# Transformar a variável 'escpublica'
dados$escpublica <- as.numeric(ifelse(toupper(dados$qe_i17) == "A", 1, 0))

# Transformar a variável 'rendabaixa'
## Atribuindo valores específicos baseados em categorias
### Atribuição do valor referente a quantos salarios minimos é a renda da familia, com uma média deste salário explicitado.
dados$rendabaixa <- case_when(
  dados$qe_i8 == "a" ~ 1.5,
  dados$qe_i8 == "b" ~ 3,
  dados$qe_i8 == "c" ~ 4.5,
  dados$qe_i8 == "d" ~ 6,
  dados$qe_i8 == "e" ~ 10,
  dados$qe_i8 == "f" ~ 30,
  dados$qe_i8 == "g" ~ 30,
  TRUE ~ 0  # Valor padrão para respostas não especificadas
)


# Transformar a variável 'familiarestudado'

dados$familiarestudado <- as.numeric(ifelse(toupper(dados$qe_i21) == "A", 1, 0))

# Transformar a variável 'lebastante'
## Média de livros lidos

dados$lebastante <- case_when(
  dados$qe_i22 == "a" ~ 0,
  dados$qe_i22 == "b" ~ 2,
  dados$qe_i22 == "c" ~ 5,
  dados$qe_i22 == "d" ~ 6,
  dados$qe_i22 == "e" ~ 8,
  TRUE ~ 0  # Valor padrão para respostas não especificadas
)


# Transformar a variável 'estudabastante'
##Média de horas estudando durante o ano

dados$estudabastante <- case_when(
  dados$qe_i23 == "a" ~ 0,
  dados$qe_i23 == "b" ~ 2,
  dados$qe_i23 == "c" ~ 6,
  dados$qe_i23 == "d" ~ 10,
  dados$qe_i23 == "e" ~ 12,
  TRUE ~ 0  # Valor padrão para respostas não especificadas
)


# Transformar a variável 'Cienciassemfronteiras'
dados$Cienciassemfronteiras <- as.numeric(ifelse(dados$qe_i14 == "b", 1,
                                                 ifelse(dados$qe_i14 == "a", 0, NA)))

#Omitindo as variaveis NA

dados <- dados[!is.na(dados$Cienciassemfronteiras), ]

#Fazendo o pareamento das variáveis
## O nu_idade é uma variável direta da base

mod_match <- matchit(Cienciassemfronteiras ~ Sexo + nu_idade + Solteiro + FacPublica + escpublica + rendabaixa + familiarestudado + lebastante + estudabastante, data = dados, metodo = "nearest", ratio = 1)

#Mostrando o pareamento

summary(mod_match)

#Criando uma base de dados secundária apenas com os indivíduos pareados

base_prop <- match.data(mod_match)


# Cálculo das médias e outras estatísticas descritivas para cada grupo
summary_stats <- base_prop %>%
  group_by(Cienciassemfronteiras) %>%
  summarise(
    count = n(),
    mean_nt_ger = mean(nt_ger, na.rm = TRUE),
    sd_nota_ger = sd(nt_ger, na.rm = TRUE),
    min_nota_ger = min(nt_ger, na.rm = TRUE),
    max_nota_ger = max(nt_ger, na.rm = TRUE)
  )

# Exibição das estatísticas
print(summary_stats)

# Converter o resultado para data frame se necessário
summary_stats <- as.data.frame(summary_stats)

print(summary_stats)


# Teste t para comparar as médias entre os grupos
t_test_result <- t.test(nt_ger ~ Cienciassemfronteiras, data = base_prop)

# Apresentação dos resultados do teste t
print(t_test_result)


#Fazendo a regressão 

reg<- lm(nt_ger ~ Cienciassemfronteiras + Sexo + nu_idade + Solteiro + FacPublica + escpublica + rendabaixa +familiarestudado + lebastante + estudabastante, data = base_prop)


summary(reg)


# Criação de um objeto 'survey design' que incorpora os pesos
svy_mod <- svydesign(ids = ~1, data = base_prop, weights = ~weights)

# Regressão ponderada utilizando o objeto 'survey design'
reg_weighted <- svyglm(nt_ger ~ Cienciassemfronteiras + Sexo + nu_idade + Solteiro + FacPublica + escpublica + rendabaixa +familiarestudado + lebastante + estudabastante, design = svy_mod)

# Sumário do modelo de regressão ponderado
summary(reg_weighted)






