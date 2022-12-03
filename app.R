# Required packages ----

# install.packages(c("dplyr", "ggplot2", "readxl", "shiny", "viridis", "vroom", "stringr"))

library(dplyr) # data manipulation
library(ggplot2) # plot generation
library(readxl) # read .xlsx and .xls files
library(shiny) # web application
library(stringr) # soft wrapping the title
library(viridis) # viridis color palettes
library(vroom) # read files

# Loading functions from separate files ----
# The three files must be located at the same folder as app.R

source("plotColor.R")
source("loadFile.R")
source("getPalette.R")
source("drawPlots.R")

# General notes ----
# All the functions are named in the following format: verbObject, where verb is what the function does and Object is the object affected by it. So drawPoint is a function that will draw a point layer in the plot.
# Most of the reactive expressions follow a similar pattern, but they don't start with a verb.
# All the inputs/outputs are named as name_role, where name is the name of the variable or argument and role is what the input or output is storing. So an input called x_variable_name is storing the name of the variable x.

#

# Start of the UI ----
# The User Interface, or UI, defines what the user will interact with while using the Shiny App

ui <- navbarPage("Para visualizar a Linguística",
                 ## Page 01: Introduction to the site -----------------------
                 tabPanel("Home",
                          
                          titlePanel("Introdução"),
                          
                          navlistPanel(
                              ### Navigation guide ----------------------------
                              
                              tabPanel("Guia de navegação",
                                       h4("Guia de navegação", align = "center"),
                                       p(HTML(paste0(strong("Para visualizar a linguística "), "é um site desenvolvido com o objetivo de criar uma interface de visualização de dados interativa e de fácil uso voltada para estudos linguísticos. O site é acessível a qualquer pessoa, independente dos conhecimentos de programação."))),
                                       hr(),
                                       
                                       p(strong("Organização do site:"),
                                         tags$ul(
                                             tags$li(strong("Home:"), "é a página inicial do site. Contém um breve resumo do que é o site, uma aba para recomendações de uso e uma aba com as referências usadas para o desenvolvimento do site, incluindo detalhes sobre os conjuntos de dados disponibilizados como exemplos na aba de geração de gráficos."),
                                             tags$li(HTML(paste0(strong("Estatística: "), "é a página que conceitua e explica brevemente conceitos básicos da estatística descritiva e da visualização dos dados. Os assuntos abordados são: variáveis, medidas de tendência central e de dispersão, formatação de dados e os quatro tipos de gráficos disponíveis no site, histograma, gráfico de barras, gráfico de dispersão e ", em("boxplot"), "."))),
                                             tags$li(strong("Geração de gráficos:"), "é a página onde os gráficos podem ser gerados, seja a partir de um arquivo próprio ou a partir de dados já pré-selecionados para testar e explorar as funcionalidades do site.")
                                         )
                                       )
                              
                                ), 
                              
                              ### About -------------------------------------
                              tabPanel("Sobre o site",
                                       h4("Sobre o site", align = "center"),
                                       
                                       p("Nas recentes décadas, com a evolução da tecnologia, a computação tem se tornado cada vez mais presente nos estudos linguísticos de diversas maneiras diferentes, entre elas, no uso de métodos quantitativos para análise de dados linguísticos, que crescem cada vez mais ao decorrer dos anos."),
                                       p(),
                                       p("Apesar da crescente importância dos métodos quantitativos na linguística, são poucos os recursos quantitativos dedicados aos linguistas, sobretudo em português. Tendo esses fatores em mente, o site foi desenvolvido com o intuito de fornecer uma interface de visualização de dados voltada para linguistas."),
                                       p(),
                                       p("Mesmo que os métodos quantitativos sejam aplicáveis em qualquer área do conhecimento a proposta do Para visualizar a linguística é explicar conceitos estatísticos de uma maneira que linguistas possam entender e fornecer exemplos com dados linguísticos, visando aproximar a linguagem estatística da linguagem já conhecida pelos linguistas."),
                                       
                                ),
                              
                              ### Recommendations -----------------------
                              tabPanel("Recomendações de uso",
                                       h4("Recomendações de uso", align = "center"),
                                       p(
                                           tags$ul(
                                               tags$li(HTML(paste0("Os formatos de arquivo suportados no site são: ", strong(".csv"), ', tanto com "," quanto com ";", ', strong(".tsv"), ", ", strong(".txt"), ", ", strong(".xlsx "), "e ", strong(".xls"), ". Certifique-se que seu arquivo esteja em um desses formatos antes de fazer o ", em("upload"), ". Caso o arquivo ainda não esteja sendo lido corretamente mesmo estando em um dos formatos suportados, tente verificar e modificar os separadores do arquivo."))),
                                               tags$li(HTML(paste0("É recomendado que o formato dos dados siga a convenção ", em("tidydata"), ", explicada na aba ", strong("Estatística"), "."))),
                                               tags$li("Por vezes a geração dos gráficos pode demorar. Os motivos mais comuns são: uma quantidade muito grande de dados na primeira coluna dos dados torna o gráfico a ser gerado muito complexo, demandando um tempo maior para o gráfico aparecer e muito comandos efetuados em um intervalo muito pequeno de tempo, recomenda-se esperar o gráfico ser gerado novamente antes de dar um novo comando."),
                                               tags$li("Ao mudar de um gráfico para o outro, é necessário reabrir a opção de Inserir títulos e rótulos para que eles fiquem vazios e possam ser alterados novamente."),
                                               tags$li("Todas as paletas de cores, exceto a padrão e a escala de cinza, são acessíveis para pessoas daltonismo. Mas mesmo entre elas, a paleta", strong("cividis"), "é a mais recomendada.")
                                           ),
                                           
                                       )
                                  
                              ),
                              
                              ### Datasets and references ---------------------
                              tabPanel("Conjuntos de dados e referências",
                                       #### Datasets --------------------------
                                       h4("Conjunto de dados", align = "center"),
                                       p(HTML(paste0(em("lexdec"), ": conjunto de dados presente no pacote ", em("languageR "), "(BAAYEN; SHAFAEI-BAJESTAN, 2019). O conjunto de dados consiste em 1659 observações com 28 variáveis. Para mais informações, acesse a ", a("documentação do pacote", href = "https://cran.r-project.org/web/packages/languageR/languageR.pdf"), ", que tem informação sobre todos os conjuntos de dados e funções que podem ser encontrados nele."))),
                                       p(HTML(paste0(em("colreg"), ": conjunto de dados adaptado do pacote ", em("Rling "), "(LEVSHINA, 2014). O conjunto de dados consiste em 44 observações com 3 variáveis: cores básicas do ingês, modalidade de uso da língua e frequência das cores em cada modalidade."))),
                                       p(HTML(paste0(em("pretonicas_F1_F2"), ': conjunto de dados adaptado dos dados "pretonicas", disponibilizados por Oushiro (2021) para o seu material de "Introdução à estatística para linguistas". O conjunto de dados consiste em 2415 observações com 4 variáveis: vogais, F1, F2 e amostra, onde F1 e F2 armazenam os valores dos formantes das vogais e amostra fala de qual grupo de falantes aquele dado é. As amostras são "PBSP", contendo dados de migrantes paraibanos residentes em São Paulo e "SP2010, contendo dados de paulistanos.'))),
                                       hr(),
                                       
                                       #### References ------------------------
                                       h4("Referências", align = "center"),
                                       p(HTML(paste0("BAAYEN, R. H.; SHAFAEI-BAJESTAN, E. languageR: Analyzing Linguistic Data: A
Practical Introduction to Statistics. [S.l.], 2019. R package version 1.5.0. Disponível em: ", a("https://CRAN.R-project.org/package=languageR", href = "https://CRAN.R-project.org/package=languageR"), "."))),
                                       p(HTML(paste0("CHANG, W. et al. shiny: Web Application Framework for R. [S.l.], 2022. R package
version 1.7.2. Disponível em: ", a("https://CRAN.R-project.org/package=shiny", href = "https://CRAN.R-project.org/package=shiny"), "."))),
                                       p("LEVSHINA, N. Rling: A companion package for How to Do Linguistics with R. [S.l.],
2014. R package version 1.0."),
                                       p(HTML(paste0("OUSHIRO, L. DadosIEL. Zenodo, 2017. Disponível em: ", a("https://doi.org/10.5281/zenodo.
1133236", href = "https://doi.org/10.5281/zenodo.
1133236"), "."))),
                                       p(HTML(paste0("R Core Team. R: A Language and Environment for Statistical Computing. Vienna,
Austria, 2022. Disponível em: ", a("https://www.R-project.org/", href = "https://www.R-project.org/"), "."))),
                                       p(HTML(paste0("RStudio Team. RStudio: Integrated Development Environment for R. Boston, MA, 2022. Disponível em: ", a("http://www.rstudio.com/", href = "http://www.rstudio.com/"), ".")))
                                       
                              ),
                              
                              tabPanel("Sobre o autor",
                                       
                                       h4("Sobre o autor", align = "center"),
                                       p(strong("Para visualizar a linguística"), " foi desenvolvido por Henrique Mancini Nevado como trabalho de conclusão de curso para o bacharelado em Letras, da Faculdade de Letras (FALE) da Universidade Federal de Minas Gerais (UFMG)."),
                                       hr(),
                                       
                                       h4("Contato", align = "center"),
                                       p(strong("E-mail para contato:"), "henriquemancinevado@gmail.com")
                                  
                              )
                          )
                          ),
                 ## Page  02: Basic statistics ------------------------------
                 tabPanel("Estatística",
                          titlePanel("Conceitos básicos de estatística descritiva e visualização de dados"),
                          navlistPanel(
                              
                              ### Descriptive and inferential statistics ----
                              tabPanel("Conceitos básicos",
                                       h4("O que é estatística?", align = "center"),
                                       p(HTML(paste0("A estatística pode ser definida como um conjunto de métodos usados para obter e analisar dados. Esses métodos não são restritos a apenas uma área do conhecimento, sendo aplicáveis em diversos campos. Uma análise estatística pode ser ", strong("descritiva "), "ou ", strong("inferencial"),"."))),
                                       p(),
                                       p("Uma análise descritiva é marcada pela descrição dos dados coletados e pelas informações que podem ser retiradas deles. Uma análise inferencial se preocupa em prever, a partir dos dados coletados, fenômenos para dados que não disponíveis."),
                                       p(),
                                       p("É importante ressaltar que a estatística é apenas um conjunto de ferramentas, se o pesquisador não souber as perguntas certas e não souber como chegar às respostas, a estatística não será tão útil quanto poderia ser. Assim, os conceitos básicos de estatística descritiva serão abordados. Tendo em vista o foco do site, a estatística inferencial não será discutida."),
                                       ),
                              
                              ### Variables and variable types --------------
                              tabPanel("Variáveis e tipos de variáveis",
                                       h4("Definição de variável", align = "center"),
                                       p(HTML(paste0(strong("Variável "), "é o nome dado a qualquer característica que varia em valor de acordo com cada observação dentro do conjunto de dados, por exemplo, em uma pesquisa envolvendo seres humanos, a idade de cada um dos participantes da pesquisa pode ser uma variável presente nos dados. Variáveis podem ser ", strong("quantitativas "), "ou ", strong("qualitativas "), "."))),
                                       hr(),
                                       
                                       #### Quantitative --------------------
                                       h4("Variáveis quantitativas", align = "center"),
                                       p(HTML(paste0("Variáveis quantitativas também podem ser chamadas de numéricas e são caracterizadas por armazenarem valores numéricos. Podem ser dividas em variáveis ", strong("contínuas "), "e ", strong("discretas"), "."))),
                                       br(),
                                       
                                       ###### Continuous --------------------
                                       p("Variáveis quantitativas contínuas armazenam valores arbitrários, mas que formam um contínuo. Podem ser número inteiros, racionais ou reais."),
                                       p(strong("Exemplos:"), "tempo de reação e duração de um som."),
                                       br(),
                                       
                                       ##### Discrete -----------------------
                                       p("Variáveis quantitativas discretas armazenam valores contáveis."),
                                       p(strong("Exemplos:"), "quantidade de letras de uma palavra e número de sons em uma sentença."),
                                       hr(),
                                       
                                       #### Qualitative ---------------------
                                       h4("Variáveis qualitativas", align = "center"),
                                       p(HTML(paste0("Variáveis qualitativas, ou categóricas, armazenam valores que representam uma categoria, limitando o número máximo de valores diferentes que pode armazenar. Podem ser dividas em variáveis ", strong("nominais "), "e ", strong("ordinais"), "."))),
                                       br(),
                                       
                                       ##### Nominal ------------------------
                                       p("Variáveis qualitativas nominais armazenam valores que não tem uma ordenação específica."),
                                       p(strong("Exemplos:"), "tipos de vogais e transitividade de um verbo."),
                                       br(),
                                       
                                       ##### Ordinal ------------------------
                                       p("Variáveis qualitativas ordinais armazenam valores que podem ser ordenados de uma maneira específica."),
                                       p(strong("Exemplos:"), 'frequência de palavras representada por "baixa, média, alta" e anterioridade de vogais representada por "anterior, central, posterior". '),
                                       hr(),
                                       
                                       #### Other types ---------------------
                                       h4("Outros tipos de variáveis", align = "center"),
                                       p(HTML(paste0("Alguns tipos de variáveis que não tem nenhuma características marcante dos tipos citados acima são ", strong("data "), "e/ou ", strong("hora"), ", ", strong("texto "), "sem formatação específica e ", strong("binárias"), ". Variáveis binárias também podem ser chamadas de lógicas e podem armazenar apenas dois valores, geralmente verdadeiro/falso ou 0/1 para indicar a ausência e/ou a presença de uma característica."))),
                                       p(strong("Exemplos:"), 
                                         tags$ul(
                                           tags$li("Datas e/ou hora: 15 de Outubro de 2022, 14:31, 02 de Fevereiro."),
                                           tags$li('Texto: "Os dias passam cada vez mais rápido."'),
                                           tags$li("Binárias: vozeamento de um som codificado em 0 e 1, onde 0 representa ausência de vozeamento e 1 representa presença de vozeamento.")
                                       ))
                                       ),
                              
                              ### Central tendency --------------------------
                              tabPanel("Medidas de tendência central",
                                       h4("Medidas de tendência central", align = "center"),
                                       p(HTML(paste0("As medidas de tendência central têm como objetivo mostrar os valores mais representativos dentro de um conjunto de dados. As principais medidas de tendência central são a ", strong("média "), ", a ", strong("mediana "), "e a ", strong("moda"), "."))),
                                       hr(),
                                       
                                       #### Mean ----------------------------
                                       h4("Média", align = "center"),
                                       p("A média é o valor obtido ao somar o valor de todos os dados e dividir pelo número de dados. A média é usada com frequência por incluir o valor de todos os dados, mas não é recomendada para conjuntos de dados com valores extremos, que distoem do restante dos dados, uma vez que eles podem enviesar o valor da média e não representar bem o conjunto de dados."),
                                       hr(),
                                       
                                       #### Median --------------------------
                                       h4("Mediana", align = "center"),
                                       p("A mediana corresponde ao valor do dado encontrado na posição do meio de um conjunto de dados ordenado. Considerando três conjuntos de dados, um com 99 dados, um com 100 e um com 101, o valor de mediana corresponderia, respectivamente, ao valor do dado na posição 50, à média dos dados 50 e 51, e ao valor do dado 51."),
                                       p(HTML(paste0("Uma outra maneira de definir a mediana é em termos de ", strong("percentis "), "e ", strong("quartis"), ". Percentis são encontrados ao dividir o conjunto de dados em 100 partes e, considerando que a mediana representa a posição de 50% dos dados, a mediana pode ser definida como o 50º percentil. Já os quartis são encontrados ao dividir o conjunto de dados em 4. O primeiro quartil representaria 25% dos dados, o segundo quartil representaria 50% dos dados - a mediana -, enquanto o terceiro quartil representaria 75% dos dados."))),
                                       p("Comparada à média, a mediana fornece uma noção mais precisa dos dados quando valores extremos estão presentes nos dados, mas tem a desvantagem de pegar apenas um valor do conjunto de dados."),
                                       hr(),
                                       
                                       #### Mode-----------------------------
                                       h4("Moda", align = "center"),
                                       p("A moda representa o valor, ou os valores, mais recorrentes dentro do conjunto de dados. Caso dois valores aconteçam o mesmo número de vezes, o conjunto de dados tem duas modas, caracterizando uma distribuição bimodal. A moda compartilha da desvantagem da mediana em pegar apenas um, ou dois, valores do conjunto de dados, mas é também a única medida de tendêncial central que pode ser usada para variáveis categóricas.")
                                       ),
                              
                              ### Dispersion --------------------------------
                              tabPanel("Medidas de dispersão",
                                       h4("Medidas de dispersão", align = "center"),
                                       p(HTML(paste0("Medidas de dispersão são usadas em conjunto das medidas de tendência central. Enquanto as medidas de tendência central descrevem um valor comum dentro dos dados, as medidas de dispersão descrevem os dados que estão em volta desse valor comum. As medidas de dispersão mais comuns são a ", strong("amplitude"), ", a ", strong("variância "), "e o ", strong("desvio padrão"), "."))),
                                       hr(),
                                       
                                       #### Range ---------------------------
                                       h4("Amplitude", align = "center"),
                                       p("A medida de dispersão mais simples é a amplitude, que pode ser definida como a diferença entre o maior e o menor valor do conjunto de dados. Por utilizar apenas dois valores do conjuntos de dados e ignorar o restante, a amplitude não é muito usada. A amplitude também tende a ser afetada por valores extremos, uma vez que os dois valores que usa são justamente os das pontas."),
                                       hr(),
                                       
                                       #### Variance ------------------------
                                       h4("Variância", align = "center"),
                                       p("As duas medidas de dispersão mais utilizads são definidas com base no concetio de desvio. O desvio representa a diferença entre um valor individual e a média do conjunto de dados."),
                                       p("A variância mostra a distância geral dos dados em relação à média. Matematicamente, pode ser definida como o quadrado da soma do desvio dos dados dividido pelo número de observações menos um."),
                                       hr(),
                                       
                                       #### Standard Deviation --------------
                                       h4("Desvio Padrão", align = "center"),
                                       p("Similarmente a variância, o desvio padrão mostra a distância geral dos dados em relação à media. Matematicamente, pode ser definido como a raiz quadrada da variância. Apesar de serem conceitualmente similares, a grande diferença entre a variância e o desvio padrão é que a variância usa desvios ao quadrado, fazendo com que sua interpretação com relação aos dados seja mais difícil que a do desvio padrão.")
                                       
                                       ),
                              
                              ### Data formats  -----------------------------
                              tabPanel("Formatação dos dados",
                                       h4("Formatação dos dados", align = "center"),
                                       p(HTML(paste0("Um conjunto de dados pode ser organizado de diferente formas. Os três formatos mais utilizados são o formato ", strong("longo"), ", o formato ", strong("amplo "), " e o formato ", strong(em("tidydata")), ". Cada um desses formatos é adequado para diferentes situações e usos."))),
                                       hr(),
                                       
                                       #### Long data -----------------------
                                       h4("Formato longo", align = "center"),
                                       p("No formato longo as observações têm sua própria coluna, mas as variáveis estão na segunda coluna e os valores de cada variável estão na terceira coluna, de forma que a segunda coluna armazena um identificador de qual variável estará representada na terceira coluna para cada linha do conjunto de dados."),
                                       hr(),
                                       
                                       #### Wide data -----------------------
                                       h4("Formato amplo", align = "center"),
                                       p("Em contraste ao formato longo, no formato amplo cada coluna representa apenas uma variável."),
                                       hr(),
                                       
                                       #### Tidydata ------------------------
                                       h4(em("Tidydata"), align = "center"),
                                       p(HTML(paste0("Visualmente o formato amplo e o formato ", em("tidydata "), "são similares, entretanto, o formato ", em("tidydata "), "segue três regras interdependentes que não necessariamente estão presentes no formato longo. Para um conjunto de dados estar no formato ", em("tidydata "), "é necessário que: 1) cada variável tenha sua própria coluna; 2) cada observação tenha sua própria linha e 3) cada valor precisa ter sua própria célula.")))
                                       
                                       
                                       ),
                              
                              ### Histogram -----------------------------------
                              tabPanel("Histograma",
                                       h4("Histograma", align = "center"),
                                       p(HTML(paste0("Um histograma é um tipo de gráfico usado para verificar a forma da distribuição de uma variável quantitativa. histograma é criado fazendo a divisão de toda a gama de valores do conjunto de dados em intervalos iguais e desenhando retângulos para cada intervalo, a altura de cada retângulo é proporcional à frequência dos valores dentro de cada intervalo e a largura deles é chamada de ", em("binwidth "), "e varia em cada conjunto de dados, podendo ser calculado de diferentes maneiras."))),
                                       p(HTML(paste0("A primeira informação a se observar é se a distribuição é unimodal ou bimodal. A forma de uma distribuição unimodal é geralmente classificada como simétrica ou assimétrica. Um importante tipo distribuição simétrica é a ", strong("distribuição normal"), ", caracterizada não só pela sua simetria mas também pela sua média e pelo seu desvio padrão, que determinan, respectivamente, o centro da distribuição e sua variabilidade. O aplicativo ", a(em("The Normal Distribution", href = "https://istats.shinyapps.io/NormalDist/")), ", para o livro ", em("Statistics: The Art and Science of Learning from Data: Global Edition"), ", de Agresti, Franklin e Klingenberg, fornece uma interface interativa que mostra como a distribuição normal muda em função da sua média e dos eu desvio padrão."))),
                                       p(HTML(paste0("Já uma distribuição assimétrica pode ser ", strong("negativa "), "ou ", strong("positiva"), " e é caracterizada pela sua cauda. Uma distribuição negativa tem uma cauda à esquerda, causada por valores extremos - valores que distoam do restante dos dados - muito menores que o restante dos dados, contribuindo para uma média menor que a mediana. Uma distribuição positiva tem uma cauda à direita, causada por valores extremos muito maiores que o restante dos dados, contribuindo para uma média maior que a mediana."))),
                                       p("A figura abaixo mostra um histograma com uma distribuição assimétrica positiva gerado no site."),
                                       div(img(src = "histograma_exemplo.png",
                                               width = 507,
                                               height = 382), 
                                           style = "text-align:center"),
                                       hr(),
                                       
                                       #### Options ------------------------------
                                       p(strong("Opções de personalização:"),
                                         tags$ul(
                                             tags$li("Cor: muda a cor das barras do histograma."),
                                             tags$li(HTML(paste0("Tamanho: muda a ", em("binwidth"), ".")))
                                         ))
                              ),
                              
                              ### Barplot -----------------------------------
                              tabPanel("Gráfico de barras",
                                       h4("Gráfico de barras", align = "center"),
                                       p("Um gráfico de barras costuma ser usado para comparar valores entre dois grupos e pode ser criado de algumas maneiras diferentes. A maneira mais simples, e possivelmente mais comum, é desenhando barras verticais no eixo x que começam em 0 e vão até o valor de cada variável no eixo y. A imagem abaixo (e as outras duas imagens a seguir), foi gerada no site e mostra um exemplo de gráfico de barras com apenas o eixo x."),
                                       div(img(src = "barplot_x_exemplo.png",
                                               width = 507,
                                               height = 382), 
                                           style = "text-align:center"),
                                       p("Uma alternativa ao gráfico de barras é o gráfico de colunas, desenhado com barras horizontais no eixo y que começam em 0 e vão até o valor de cada variável no eixo x, como mostra o gráfico abaixo."),
                                       div(img(src = "barplot_y_exemplo.png",
                                               width = 507,
                                               height = 382), 
                                           style = "text-align:center"),
                                       p("Outra maneira de criar um gráfico de barras é mapeando uma variável em cada eixo, como mostra a imagem abaixo."),
                                       div(img(src = "barplot_xy_exemplo.png",
                                               width = 507,
                                               height = 382), 
                                           style = "text-align:center"),
                                       hr(),
                                       
                                       #### Options ----------------------------
                                       p(strong("Opções de personalização:"),
                                         tags$ul(
                                             tags$li("Cor: pode mapear uma variável nas cores ou apenas mudar a cor das barras."),
                                             tags$li("Posição: se a cor mapear uma variável a opção de empilhar, empilhar por porcentagem e agrupar aparecerão para decidir a posição das cores.")
                                         ))
                              ),
                              
                              ### Scatterplot -------------------------------
                              tabPanel("Gráficos de dispersão",
                                       h4("Gráficos de dispersão", align = "center"),
                                       p("Um gráfico de dispersão é ideal para fazer a comparação de duas variáveis quantitativas a fim de checar como elas se relacionam uma com a outra. Tendo uma variável quantitativa em cada eixo, um gráfico de dispersão é criado inserindo pontos onde a variável x e a variável y se encontram no gráfico. É possível também inserir uma terceira variável, geralmente categórica, codificada na cor dos pontos e/ou na forma dos pontos. A figura abaixo mostra um gráfico de dispersão F1 e F2 com diferentes cores representado cada vogal."),
                                       div(img(src = "scatterplot_exemplo.png",
                                               width = 507,
                                               height = 382), 
                                           style = "text-align:center"),
                                       hr(),
                                       
                                       #### Options -------------------------
                                       p(strong("Opções de personalização:"),
                                         tags$ul(
                                             tags$li("Cor: pode mapear uma variável nas cores ou apenas mudar a cor dos pontos."),
                                             tags$li("Forma: mapeia uma variável na forma dos pontos"),
                                             tags$li("Tamanho: muda o tamanho dos pontos."),
                                             tags$li(HTML(paste0("Jitter: adiciona ", em("random noise "), "ao gráfico para evitar que os pontos fiquem sobrepostos.")))
                                         ))
                                       
                              ),
                              
                              ### Boxplot ----------------------------------
                              tabPanel(em("Boxplot"),
                                       h4(em("Boxplot"), align = "center"),
                                       p(HTML(paste0(em("Boxplots "), "são ideais para visualizar mais de uma distribuição ao mesmo tempo. Eles são criados dividindo um conjunto de dados em quartis e os projetando de maneira padronizada, geralmente como um retângulo ou um quadrado, dependendo da forma da distribuição. A imagem abaixo, adaptada de Wilke (2019), mostra a estrutura de um ", em("boxplot"), "."))),
                                       div(img(src = "boxplot_structure.png",
                                           width = 247,
                                           height = 340), 
                                           style = "text-align:center"),
                                       p(HTML(paste0("A linha central representa a mediana dos dados. A borda superior da caixa representa o valor do terceiro quartil enquanto a inferior representa o valor do primeiro quartil. As linhas verticais saindo da caixa são chamadas de bigodes, ou ", em("whiskers "), "em inglês, e se estendem até o maior e o menor valor que caem à 1.5x da altura da caixa. Os pontos individuais projetados além da extensão dos bigodes são ", em("outliers"), ", possíveis valores atípicos. A figura abaixo mostra um exemplo de ", em("boxplot "), "gerado no site."))),
                                       div(img(src = "boxplot_exemplo.png",
                                               width = 507,
                                               height = 382), 
                                           style = "text-align:center"),
                                       hr(),
                                       
                                       #### Options--------------------------
                                       p(strong("Opções de personalização:"),
                                         tags$ul(
                                             tags$li("Cor: pode mapear uma variável nas cores ou apenas mudar a cor dos retângulos/quadrados."),
                                             tags$li(HTML(paste0("Violino: muda a forma do ", em("boxplot "), "para violino.")))
                                         ))
                              )
                          )
                          ),
                 
                 ## Page 03: Plot generation --------------------------------
                 tabPanel("Geração de gráficos",
                          fluidPage(
                              fluidRow(
                                  ### Inputs --------------------------------
                                  
                                  column(4, style = 'border-right: 1px solid;',
                                         
                                         #
                                         
                                         # Receiving the file
                                         radioButtons("file_type_select", "Escolha qual conjunto de dados usar:",
                                                      choiceNames = c("Exemplos", "Dados próprios"),
                                                      choiceValues = c("load", "upload"),
                                                      inline = TRUE, selected = 0),
                                         
                                         uiOutput("file_upload"),
                                         uiOutput("file_load"),
                                         
                                         # Check if the file has a header, TRUE by default
                                         uiOutput("header_select"),
                                         
                                         # Define the amount of rows to be shown in the preview of the data, the default number of rows is 6.
                                         uiOutput("row_number_select"),
                                         
                                         #
                                         
                                         ### Necessary arguments -------------------
                                         
                                         #
                                         
                                         # uiOutputs will only appear in the interface after a certain requirement is met. For example, the "plot_type_select" input will only appear in the interface after the user successfully uploads a file.
                                         uiOutput("plot_type_select"), # Input to select the type of plot: barplot, boxplot, scatterplot or histogram
                                         
                                         uiOutput("barplot_axis_select"), # The barplot has a unique requirement of selecting only the x or only the y variable (or both) to define if the user wants a normal barplot or a columnplot.
                                         
                                         uiOutput("x_variable_select"), # Input to select the X variable.
                                         
                                         uiOutput("y_variable_select"), # Input to select the Y variable.
                                         #
                                         
                                         ### Optional arguments --------------------
                                         
                                         #
                                         
                                         # Different optional arguments will appear for different plots, depending on which ones are more common or appropriate for each one.
                                         
                                         uiOutput("optional_args"), # Input to select among the different options for each plot. Only the ones available for the selected plot will appear as option.
                                         
                                         uiOutput("color_usage"), # Define if color is gonna be used as variable or as solid color.
                                         
                                         uiOutput("color_value_select"), # Select the variable for color or select a normal color to use instead of the default, available for all plots.
                                         uiOutput("palette_select"), # Select the color palette for the plot.
                                         
                                         uiOutput("position_select"), # Stack or dodge argument on geom_bar(), available only for barplot with color as variable.
                                         
                                         uiOutput("shape_value_select"), # Select the variable for shape, available only for scatterplot.
                                         
                                         uiOutput("size_value_select"), # Select the size of the dots, available only for scatterplot.
                                         
                                         #
                                         
                                         ### Labels --------------------------------
                                         
                                         # Used to determine if the user wants the labels or not. False by default.
                                         uiOutput("labels_option"),
                                         
                                         uiOutput("label_title"), # Define the title of the plot.
                                         
                                         uiOutput("label_x"), # Define the label of the X variable.
                                         
                                         uiOutput("label_y"), # Define the label of the Y variable.
                                         
                                         ### Optional labels  ----------------------
                                         
                                         #
                                         
                                         # Will appear if there's any variable codified in the color or shape arguments and the user wants labels.
                                         
                                         uiOutput("label_color"), # Define the label of the color variable.
                                         
                                         uiOutput("label_shape"), # Define the label of the shape variable.
                                  ),
                                  
                                  ### Outputs -----------------------------------
                                  column(6,
                                         
                                         #
                                         
                                         plotOutput("plot", width = "500px"), # Plot with the recommended width.
                                         tableOutput("head") # Preview of the data.
                                         
                                  ),
                                  
                                  ### Download --------------------------------
                                  column(2, style='margin-bottom:30px;border:1px solid; padding: 10px;',
                                         #
                                         
                                         # Select the extension of the picture
                                         radioButtons("download_ext",
                                                      "Escolha a extensão da figura:",
                                                      choiceNames = list(".png",
                                                                         ".jpg",
                                                                         ".pdf"),
                                                      choiceValues = list("png",
                                                                          "jpg",
                                                                          "pdf"),
                                                      inline = TRUE
                                         ),
                                         
                                         # Button to download
                                         downloadButton("download_plot")
                                         
                                  )
                              )
                          )
                 ),
)

# Start of the Server function ----

server <- function(input, output){
    
    ## Loading the data -----------------------------------------------------
    
    
    # If the user wants to upload, "fileInput" will appear for the user to upload and a checkbox will appear for the user to indicated if there's a header or not
    output$file_upload <- renderUI({
        req(input$file_type_select)
        if(input$file_type_select == "upload"){
            fileInput("file", "Insira um arquivo tipo .csv, .tsv, .txt, .xlsx ou .xls:",
                      accept = c(".csv", ".tsv", ".txt", ".xlsx", ".xls"))
        }
    })
    
    output$header_select <- renderUI({
        req(input$file_type_select)
        if(input$file_type_select == "upload"){
            checkboxInput("header", "Cabeçalho", TRUE)
        }
    })
    
    # If the user wants to load, a set with four radioButtons will appear for the user to choose between fou different datasets.
    output$file_load <- renderUI({
        req(input$file_type_select)
        if(input$file_type_select == "load"){
            radioButtons("file_load", "Selecione um conjunto de dados para utilizar:",
                         choices = c("lexdec", "colreg", "pretonicas_F1_F2"),
                         inline = TRUE)
            
        }
    })
    
    
    
    # Checks if the the user wants to upload and load and read the archive accordingly
    df <- reactive({
        req(input$file_type_select)
        if(input$file_type_select == "upload"){
            # Validate will return an error message until a file is uploaded
            validate(need(input$file, "Insira um arquivo."))
            loadFile(name = input$file$name, 
                     path = input$file$datapath, 
                     header = input$header)
        }else if(input$file_type_select == "load"){
            switch(input$file_load,
                   
                   "lexdec" = vroom("lexdec.csv"),
                   
                   "colreg" = vroom("colreg.csv"),
                   
                   "pretonicas_F1_F2" = vroom("pretonicas_F1_F2.csv",
                                              col_types = list(
                                                  col_factor(levels = c("i", "e", "a", "o", "u"), ordered = TRUE),
                                                               
                                                  col_double(),
                                                               
                                                  col_double(),
                                                               
                                                  col_factor()))
                   )
        }
    })
    

    # The name of the columns will be stored so they can be used as options for selecting the variables
    
    # Storing the name of all columns
    columnNames <- reactive(names(df()))
    
    # Storing the name of the continuous variables
    contNames <-  reactive(names(df() %>%
                                     select(which(sapply(., class) == "numeric"))))
    
    # Storing the names of the discrete variables
    discNames <- reactive(names(df() %>%
                                    select(which(sapply(., class) != "numeric"))))
                                    # select(which(sapply(., class) == "factor"),
                                    #        which(sapply(., class) == "character"),
                                    #        which(sapply(., class) == c("ordered", "factor")))))
    
    
    ## Selecting the type of plot -------------------------------------------
    
    # renderUI is the counterpart of the uiOutput, they'll provide the input that will appear in the UI where the respective uiOutput is
    
    output$plot_type_select <- renderUI({
        req(input$file_type_select) # the req() marks the requirement for the code below to run
        req(df()) 
        radioButtons("plot_type", 
                     "Escolha o tipo de gráfico:",
                     choiceNames = list(
                         "Barras",
                         "Boxplot",
                         "Dispersão",
                         "Histograma"),
                     choiceValues = list(
                         "barplot", 
                         "boxplot", 
                         "scatterplot", 
                         "histogram"),
                     inline = TRUE, selected = 0)
    })
    
    
    ## yes() reactive expressions -------------------------------------------
    
    # The reactive expressions called yesZ(), with Z being the name of a variable or argument, are used throughout the code to indicate when the user wants them in the plot. So, for instance, the reactive expression yesX() will have a TRUE or FALSE value depending on whether the user wants a variable mapped as X or not.
    
    yesX <- reactive({
        # The if statement marks the only case the variable X wouldn't be used
        if(input$plot_type == "barplot" && !("x" %in% input$barplot_axis)){
            FALSE
        }else{
            TRUE
        }
    })
    
    yesY <-reactive({
        # The if statement marks the cases where the variable Y is necessary
        if(input$plot_type == "boxplot" ||
           input$plot_type == "scatterplot" ||
           input$plot_type == "barplot" && "y" %in% input$barplot_axis){
            TRUE
        }else{
            FALSE
        }
    })
    
    yesColor <- reactive({
        req(input$plot_type)
        
        if(input$plot_type == "barplot" || input$plot_type == "histogram"){
            if(input$plot_options){
                TRUE
            }else{
                FALSE
            }
        }else if(input$plot_type == "boxplot"|| input$plot_type == "scatterplot"){
            if("cor" %in% input$plot_options){
                TRUE
            }else{
                FALSE
            }
        }
    })
    
    yesSize <- reactive({
        switch(input$plot_type,
               "barplot" = FALSE,
               "boxplot" = FALSE,
               "scatterplot" = {
                   if("tamanho" %in% input$plot_options){
                       TRUE
                   }else{
                       FALSE
                   }
               },
               "histogram" = TRUE
        )
    })
    
    yesShape <- reactive({
        if("forma" %in% input$plot_options){
            TRUE
        }else{
            FALSE
        }
    })
    
    yesJitter <- reactive({
        if("jitter" %in% input$plot_options){
            TRUE
        }else{
            FALSE
        }
    })
    
    yesViolin <- reactive({
        if("violin" %in% input$plot_options){
            TRUE
        }else{
            FALSE
        }
    })
    
    
    ## X and Y --------------------------------------------------------------
    
    # The if statement checks the value of yesX() and if the plot is a histogram. If the plot is a histogram only continuous variables will be available for the user to select, otherwise the user will be able to select any variable.
    output$x_variable_select <- renderUI({
        req(input$plot_type)
        if(yesX() && input$plot_type == "histogram"){
            selectInput("x_variable", "Selecione a variável X", 
                        choices = contNames())
        }else if(yesX()){
            selectInput("x_variable", "Selecione a variável X", 
                        choices = columnNames())
        }
    })
    
    # The restraints for the Y variable are not as tight, so only the value of yesY() is checked.
    output$y_variable_select <- renderUI({
        req(input$plot_type)
        if(yesY()){
            selectInput("y_variable", "Selecione a variável Y", choices = columnNames())
        }
    })
    
    
    ## Labels ---------------------------------------------------------------
    
    # textInput will generate a space for the user to write the title of the graph and the label for the variables
    
    
    output$labels_option <- renderUI({
        req(input$plot_type)
        checkboxInput("labels", 
                      "Inserir título e rótulos",
                      FALSE)
    })
    
    output$label_title <- renderUI({
        req(input$labels)
        if(input$labels){
            textInput("plot_name", "Insira o título do seu gráfico:") 
        }
    })
    
    output$label_x <- renderUI({
        req(input$labels)
        if(input$labels){
            textInput("x_variable_name", "Insira o rótulo da variável X:")
        }
    })
    
    output$label_y <- renderUI({
        req(input$labels)
        if(input$labels){
            textInput("y_variable_name","Insira o rótulo da variável Y:")
        }
    })
    
    output$label_color <- renderUI({
        req(input$plot_type)
        req(input$color_var_solid)
        if(yesColor() && input$labels && input$color_var_solid == "variable"){
            textInput("color_value_name", "Insira o rótulo da variável para cor:")
        }
    })
    
    output$label_shape <- renderUI({
        req(input$plot_type)
        if(yesShape() && input$labels){
            textInput("shape_value_name", "Insira o rótulo da variável para forma:")
        }
    })
    
    
    ## Barplot axis ---------------------------------------------------------
    
    # The code will create two check buttons so the user can select if they want only the variable X, only the variable Y or if they want both. The plot will only appear after one of them is selected
    
    output$barplot_axis_select <- renderUI({
        req(input$plot_type)
        if(input$plot_type == "barplot"){
            checkboxGroupInput("barplot_axis", 
                               "Selecione as variáveis para o gráfico de barras",
                               choiceNames = list("X","Y"),
                               choiceValues = list("x","y"), 
                               inline = TRUE)
        }
    })
    
    
    ## Optional arguments ---------------------------------------------------
    
    # The code will create checkbox buttons accordingly to the selected plot.
    # Color is available to all of them. Violin is unique to boxplot while shape, size and jitter are unique to scatterplot.
    
    output$optional_args <- renderUI({
        req(input$plot_type)
        switch(input$plot_type,
               "barplot" = {
                   checkboxInput("plot_options", "Cor", FALSE)
               },
               "boxplot" = {
                    checkboxGroupInput("plot_options", 
                                       "Opções de personalização",
                                       choiceNames = list(
                                           "Cor",
                                           "Violino"
                                       ),
                                       choiceValues = list(
                                           "cor",
                                           "violin"
                                       ), inline = TRUE)
               },
               "scatterplot" = {
                   checkboxGroupInput("plot_options", 
                                      "Opções de personalização",
                                      choiceNames = list(
                                          "Cor",
                                          "Forma",
                                          "Tamanho",
                                          "Jitter"
                                      ),
                                      choiceValues = list(
                                          "cor",
                                          "forma",
                                          "tamanho",
                                          "jitter"
                                      ), inline = TRUE)
               },
               "histogram" = {
                   checkboxInput("plot_options", "Cor", FALSE)
               }
        )
    })
    
    
    ## Color ----------------------------------------------------------------
    
    # color_usage will define if the color argument is meant to map a variable or only change the color of the plot
    output$color_usage <- renderUI({
        req(input$plot_type)
        req(input$plot_options)
        if(yesColor() && input$plot_type != "histogram"){
            radioButtons("color_var_solid",
                         'Escolha se "cor" será uma variável ou apenas umas cor:',
                         choiceNames = list("Cor sólida", "Variável"),
                         choiceValues = list("solidcolor", "variable"), 
                         inline = TRUE
                         )
        }else if(yesColor() && input$plot_type == "histogram"){
            radioButtons("color_var_solid", label = NULL,
                         choiceNames = list(
                             "Cor sólida"
                         ),
                         choiceValues = list(
                             "solidcolor"
                         ),
            )
        }
    })
    
    # If the color_usage is "variable", color_value_select will create a select_input for the user to choose a variable to map as color. If the color_usage is set to "solidcolor", it will create a set of radioButtons. The names used are the same as the names of the palettes, to reflect which palette the color is from, and the value of each button is the HEX code of each color. On both cases, the input will be store as color_value. 
    output$color_value_select <- renderUI({
        req(input$plot_type)
        req(input$plot_options)
        req(input$color_var_solid)
        
        if(yesColor() && input$plot_type != "scatterplot" && input$color_var_solid == "variable"){
            selectInput("color_value", "Selecione a variável para cor", 
                        choices = discNames()) # if it isn't a scatterplot, the selectInput will have only discrete variables
        }else if(yesColor() && input$color_var_solid == "variable"){
            selectInput("color_value", "Selecione a variável para cor", 
                        choices = columnNames()) # if it's a scatterplot, the selectInput will have all variables
        }else if(yesColor() && input$color_var_solid == "solidcolor"){
            radioButtons("color_value", 
                         "Escolha a cor:",
                         choiceNames = list(
                             "Viridis",
                             "Plasma",
                             "Cividis",
                             "Mako",
                             "Padrão"),
                         choiceValues = list(
                             "#21908CFF", 
                             "#CC4678FF", 
                             "#414D6BFF", 
                             "#357BA2FF",
                             if(input$plot_type == "boxplot"){
                                 "#FFFFFF"
                             }else if(input$plot_type == "scatterplot"){
                                 "#000000"
                             }else{
                                 "#595959" # boxplot and scatterplot have a different default color, but barplot and histogram have the same.
                             }), inline = TRUE)
        }
    })
    
    
    ## Palette --------------------------------------------------------------
    
    # The code will create a set of radioButtons with the name of each palette available.
    output$palette_select <- renderUI({
        req(input$plot_type)
        req(input$plot_options)
        req(input$color_var_solid)
        
        if(yesColor() && input$color_var_solid == "variable"){
            radioButtons("palette_value", 
                         "Escolha a paleta de cores:",
                         choiceNames = list(
                             "Viridis",
                             "Plasma",
                             "Cividis",
                             "Mako",
                             "Padrão",
                             "Escala de cinza"),
                         choiceValues = list(
                             "viridis", 
                             "plasma", 
                             "cividis", 
                             "mako",
                             "default",
                             "gray"),
                         inline = TRUE)
        }
    })
    
    # The function getPalette() will get the line of code to be added to the ggplot
    paleta <- reactive({
        req(input$plot_type)
        req(input$plot_options)
        
        if(yesColor() && input$color_var_solid == "variable"){
            getPalette(palette = input$palette_value,
                       plot_type = input$plot_type,
                       color = input$color_value,
                       cont_variables = contNames())
        }
    })
    
    ## Shape ----------------------------------------------------------------
    
    # A selectInput with only the discrete variables will be created
    output$shape_value_select <- renderUI({
        req(input$plot_type)
        req(input$plot_options)
        if (yesShape()){
            selectInput("shape_value", "Selecione a variável para forma",
                        choices = discNames())
        }
    })
    
    
    ## Position -------------------------------------------------------------
    
    # Create radioButtons to determine the position of the bars in case of color and variable
    output$position_select <- renderUI({
        req(input$plot_type)
        req(input$plot_options)
        if(input$plot_type == "barplot" && yesColor() && input$color_var_solid == "variable"){
            radioButtons("position_value", "Empilhar ou agrupar as barras",
                         choiceNames = list(
                             "Empilhar",
                             "Empilhar por porcentagem",
                             "Agrupar"
                         ),
                         choiceValues = list(
                             "stack",
                             "fill",
                             "dodge"
                         ), inline = TRUE)
        }
    })
    
    
    ## Size -----------------------------------------------------------------
    
    # If yesSize() is true, the code will create a slider input to select the size of the dots of a scatterplot and will automatically calculate the ideal binwidth of the histogram and use it as default value. The user can still change the binwidth value
    output$size_value_select <- renderUI({
        req(input$plot_type)
        if(yesSize()){
            switch(input$plot_type,
                   "barplot" = {
                       FALSE
                   },
                   "boxplot" = {
                       FALSE
                   },
                   "scatterplot" = {
                       sliderInput("size_value", "Selecione o tamanho dos pontos",
                                   min = 1, max = 2, value = 1.5, step = 0.25)
                   },
                   "histogram" = {
                       nbins <- 1 + 3.32*log10(length(df()[[input$x_variable]]))
                       bwidth <- diff(range(df()[[input$x_variable]]))/nbins
                       numericInput("size_value", "Binwidth",
                                    value = bwidth)
                   }
            )
        }
    })
    
    
    ## Plots ----------------------------------------------------------------
    
    # The following reactive expressions are going to define the overall form of the plots based on the variables of choice/needed. They will already have the arguments for labels and the black and white theme included. 
    
    # Plot with variables X and Y
    xyPlot <- reactive({
        ggplot(data = df(), 
               aes(x = .data[[input$x_variable]], y = .data[[input$y_variable]])) +
            labs(title = str_wrap(input$plot_name, 50),
                 colour = input$color_value_name,
                 fill = input$color_value_name,
                 shape = input$shape_value_name) +
            xlab(input$x_variable_name) + ylab(input$y_variable_name) +
            theme_bw(base_size = 13)
    })
    
    # Plot with variable X only
    xPlot <- reactive({
        ggplot(data = df(), 
               aes(x = .data[[input$x_variable]])) +
            labs(title = str_wrap(input$plot_name, 50),
                 fill = input$color_value_name,) +
            xlab(input$x_variable_name) + ylab(input$y_variable_name) +
            theme_bw(base_size = 13)
    })
    
    # Plot with variable Y only
    yPlot <- reactive({
        ggplot(data = df(), 
               aes(y = .data[[input$y_variable]])) +
            labs(title = str_wrap(input$plot_name, 50),
                 fill = input$color_value_name) +
            xlab(input$x_variable_name) + ylab(input$y_variable_name) +
            theme_bw(base_size = 13)
    })
    
    
    ## Functions ------------------------------------------------------------
    
    #
    
    #
    
    # Recursive function to determine the right call of geom_point() or geom_jitter() while decreasing the number of ifs in the rest of the code.
    # param  will match with either color, size, shape, jitter or point, on that order
    # The code then will check if the other user also wants the other arguments, if yes, the function will be called again with a different param and the arg_names string will concatenate the name of the current param, this way the code will be able to know which arguments were already called and match the geom_point() or geom_jitter() accordingly.
    drawScatterplot <- function(param, arg_names = NULL){
        switch(param,
               "color" = {
                   if(yesSize()){ # Checking for size
                       # Calling the function again, this time with "size" as param and adding "color" to the arg_names string
                       drawScatterplot("size", arg_names = paste0(arg_names, "color"))
                   }else if(yesShape()){# Checking for shape
                       drawScatterplot("shape", arg_names = paste0(arg_names, "color"))
                   }else if(yesJitter()){ # Checking for jitter
                       drawScatterplot("jitter", arg_names = paste0 (arg_names, "color"))
                   }else{
                       # Calling the drawPointColor() function to receive back the right call for geom_point()
                       drawPointColor(selected_args = "color",
                                 var_solid = input$color_var_solid,
                                 color = input$color_value)
                   }
               },
               
               "size" = {
                   if(yesShape()){
                       drawScatterplot("shape", arg_names = paste0(arg_names, "size"))
                   }else if(yesJitter()){
                       drawScatterplot("jitter", arg_names = paste0(arg_names, "size"))
                   }else if(!is.null(arg_names)){
                       drawPointColor(selected_args = "colorsize",
                                 var_solid = input$color_var_solid,
                                 color = input$color_value,
                                 size = input$size_value)
                   }else{
                       geom_point(size = input$size_value)
                   }
               },
               
               "shape" = {
                   if(yesJitter()){
                       drawScatterplot("jitter", arg_names = paste0(arg_names, "shape"))
                   }else if(!is.null(arg_names)){
                       switch(arg_names,
                              "color" = {
                                  drawPointColor(selected_args = "colorshape",
                                            var_solid = input$color_var_solid,
                                            color = input$color_value,
                                            shape = input$shape_value)
                              },
                              "size" = geom_point(size = input$size_value,
                                                  aes(shape = .data[[input$shape_value]])),
                              "colorsize" = {
                                  drawPointColor(selected_args = "colorsizeshape",
                                            var_solid = input$color_var_solid,
                                            color = input$color_value,
                                            size = input$size_value,
                                            shape = input$shape_value)
                              }
                       )
                   }else{
                       geom_point(aes(shape = .data[[input$shape_value]]))
                   }
               },
               
               "jitter" = {
                   if(is.null(arg_names)){
                       geom_jitter()
                   }else{
                       switch(arg_names,
                              "color" = {
                                  drawPointColor(selected_args = "colorjitter",
                                            var_solid = input$color_var_solid,
                                            color = input$color_value)
                              },
                              "colorsize" = {
                                  drawPointColor(selected_args = "colorsizejitter",
                                            var_solid = input$color_var_solid,
                                            color = input$color_value,
                                            size = input$size_value)
                              },
                              "colorshape" = {
                                  drawPointColor(selected_args = "colorshapejitter",
                                            var_solid = input$color_var_solid,
                                            color = input$color_value,
                                            shape = input$shape_value)
                              },
                              "colorsizeshape" = {
                                  drawPointColor(selected_args = "colorsizeshapejitter",
                                            var_solid = input$color_var_solid,
                                            color = input$color_value,
                                            size = input$size_value,
                                            shape = input$shape_value)
                              },
                              "size" = geom_jitter(size = input$size_value),
                              "sizeshape" = geom_jitter(size = input$size_value,
                                                        aes(shape = .data[[input$shape_value]])),
                              "shape" = geom_jitter(aes(shape = .data[[input$shape_value]]))
                       )
                   }
               },
               "point" = geom_point()
        )
    }
    
    #
    
    # The function will check whether the last part of the plot call is + paleta() or + scale_color/fill_identity
    getColorFill <- function(){
        if(yesColor()){
            if(input$color_var_solid == "variable"){
                paleta()
            }else{
                if(input$plot_type == "scatterplot"){
                    scale_color_identity()
                }else{
                    scale_fill_identity()
                }
            }
        }else{
            scale_color_hue()
        }
    }
    
    #
    
    #
    
    ## RenderPlot -----------------------------------------------------------
    output$plot <- renderPlot({
        req(input$plot_type)
        
        switch (input$plot_type,
                
                ### Barplot -------------------------------------------------
                "barplot" = {
                    if(yesX() && !yesY()){
                        if(yesColor()){
                            xPlot() +
                                drawBarplot(number_of_vars = 1,
                                            var_solid = input$color_var_solid,
                                            color_value = input$color_value,
                                            position = input$position_value) +
                                getColorFill()
                        }else{
                            xPlot() +
                                drawBarplot(number_of_vars = 1)
                        }
                    }else if(!yesX() && yesY()){
                        if(yesColor()){
                            yPlot() +
                                drawBarplot(number_of_vars = 1,
                                            var_solid = input$color_var_solid,
                                            color_value = input$color_value,
                                            position = input$position_value) +
                                getColorFill()
                        }else{
                            yPlot() +
                                drawBarplot(number_of_vars = 1)
                        }
                    }else{
                        if(yesColor()){
                            xyPlot() +
                                drawBarplot(number_of_vars = 2,
                                            var_solid = input$color_var_solid,
                                            color_value = input$color_value,
                                            position = input$position_value) +
                                getColorFill()
                        }else{
                            xyPlot() +
                                drawBarplot(number_of_vars = 2)
                        }
                    }
                },
                
                ## Boxplot --------------------------------------------------
                "boxplot" = {
                    if(yesColor()){
                        xyPlot() + 
                            drawBoxplot(violin = yesViolin(),
                                        var_solid = input$color_var_solid,
                                        color_value = input$color_value) +
                            getColorFill()
                    }else{
                        xyPlot() + 
                            drawBoxplot(violin = yesViolin())
                    }
                },
                
                ## Scatterplot ----------------------------------------------
                "scatterplot" = {
                    if(yesColor()){
                        xyPlot() +
                            drawScatterplot("color") +
                            getColorFill()
                    }else if(yesSize()){
                        xyPlot() + 
                            drawScatterplot("size")
                    }else if(yesShape()){
                        xyPlot() + 
                            drawScatterplot("shape")
                    }else if(yesJitter()){
                        xyPlot() +
                            drawScatterplot("jitter")
                    }else{
                        xyPlot() + 
                            drawScatterplot("point")
                    }
                },
                
                ## Histogram ------------------------------------------------
                "histogram" = {
                    if(yesColor()){
                        xPlot() +
                            geom_histogram(binwidth = input$size_value,
                                           aes(fill = input$color_value)) +
                            scale_fill_identity()
                    }else{
                        xPlot() +
                            geom_histogram(binwidth = input$size_value)
                    }
                    
                }
        )
        
        
    }, res = 96) # Recommended resolution
    
    
    
    ## Head -----------------------------------------------------------------
    
    # Creates a numeric input to use as argument for head()
    output$row_number_select <- renderUI({
        req(df(), cancelOutput = TRUE)
        numericInput("row_number", "Número de linhas para exibição prévia dos dados:", 
                     value = 6, min = 1, step = 1)
    })
    
    # Table output to preview the data
    output$head <- renderTable({
        validate(
            need(!is.null(df()), message = "Insira um arquivo")
        )
        head(df(), input$row_number)
    })
    
    
    ## Download ---------------------------------------------------------------

    output$download_plot <- downloadHandler(
        filename = function() {
            # Uses the file extension chosen by the user for the name of the file
            paste('my_plot', input$download_ext, sep = ".")
        },
        content = function(file) {
            # Uses the file extension chosen by the user to select the file type
            ggsave(file, device = input$download_ext, 
                   width = 2040, height =  1536, units = "px")
        }
    )
}

shinyApp(ui = ui, server = server)
