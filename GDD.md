GAME DESIGN DOCUMENT
====================

=======
DEV LOG
=======

18/08/2016:

Changed LoGaTe name to STEAMING (with LOVE), and started working on documentation.

17/08/2016:
@renatogeh, @yancouto

Discussão sobre Telos com renato:
- Concorda com o jeito do yan.
- Continuação:
    - Focar no "level script"
    - Pensar já na colisão (fazer uma simples antes, mas depois trocar pela "otimizada")
    - Usar o "modo survival" para testar as mecanicas e funcionalidades do jogo
    - Sobre level script: Usar corrotinas para controlar o fluxo do jogo. Exemplo:
        ```lua
            function lv1(var)
                createEnemy()
                createEnemy()
                createEnemy()
                yield()
                createEnemy()   
                createEnemy()
                createEnemy()
                ... 
        ```

IDEIA PARA FIM DE JOGO:
 - True ending apenas quando você acaba sem dar gameover
 - Libera última parte do chefão final
 - Cutscene extra

LoGaTe quase finalizado, faltando ainda metodos para adicionar/remover exceptions.

16/08/2016:
@yancouto

Continuando trabalho no LoGaTe.

Titulo possivel pro jogo: "PsyChO: The Ball".
Ideias para estágios de desenvolvimento p/ telos por yan:

- 1: bola que anda
- 2: pause screen simples
- 3: bola que atira 
- 4: inimigo simples: some quando atirado em
- 5: menu screen simples (transições entre telas)
- 6: deathscreen

12/08/2016:

Avançando no LoGaTe:
- Analisando vários códigos que criei para o projeto TR0N0S, e utilizando a biblioteca de funções HUMP (http://hump.readthedocs.io/en/latest/),
já tenho uma base para rodar os gamestates.
- Testando deixar arquivos separados para cada gamestate, e pensando como simplificar o jeito de desenhar objetos. 

11/08/2016:

Começando a trabalhar no LoGaTe (https://github.com/uspgamedev/LoGaTe), que servirá de game template para o Projeto Telos.

Iniciei analisando jogos antigos (TR0N0S e PsyChObALL), e baseando em ideias que tive durante seu desenvolvimento:

Utilizar de classes que terão seu próprio método de desenhar e funções próprias;
Gamestates que rodam seu próprio laço de desenhar e processamentos gerais;
Todos objetos a serem desenhados são colocados em tables hierárquicas, que vem da menor (desenhada primeiro, fica embaixa) até a maior (desenhada por última, fica em cima), que em cada laço tem todos seus objetos desenhados (chamando as funções respectivas para tal).

10/08/2016:
@renatogeh, @yancouto
Sugestão de aproach para re-aproveitar código:
- Olhar o código antigo por inteiro, fazendo um resuminho do que foram boas ideias/o que não foi bem implementado
- Começar o código novo do zero, sem olhar o código antigo, tentar só usar as anotações, para não ficar tentado a copiar código antigo, tentar refazer tudo.
- Se eu tiver atrasado/perdido em uma parte, e ninguém do grupo tiver uma solução, vale a pena dar uma olhada na implementação, mas tentar ao máximo não copiar código.
- Talvez reaproveitar os shaders/assets(muito pouco)/músicas

Coisas a melhorar:
- UI mais juicy
- Mortes ter efeito mais dramaticos
- Indicador de inimigo melhor (preenchido)
- Após morte, deixar o efeito slow-motion, mas parar o script do nível, para não mostrar outras coisas
- Ideia: countdown na morte para resetar ou ir para o menu, para resolver o problema anterior

THE PEOPLE HAS SPOKEN:
(relatos de experências de jogadores)

- Mais fases (jogador morria, mas se sentia motivado a tentar de novo pra vencer)
- Muita informação, nao entendia o que estava acontecendo
- Dificuldade em diferenciar jogador das outras bolas
- Música:mais músicas
- Colocar efeitos sonoros (colisão, por exemplo)

09/08/2016:
@renatogeh, @yancouto
Discussão e balanço do PsyChObALL original:
- Ruim:
    - Muito dificil, partes muito tensas de passar 
    - Morrer te leva pro começo do jogo
    - Código confuso (rushamos muita coisa muito rápido)
    - Colisão não eficiente
    - Level script lerdo (objetos criados muito antes de serem utilizados)
    - Jogo inacabado
    - Inimigos com padrão aleatório não condizente
- Bom:
    - Estética legal
    - Divertido
    - Mecânicas simples (mover e atirar, com apenas um especial diferente)
    - Variedade de inimigos/chefões
    - Música boa e de própria autoria
    - Easter eggs (cheats e coisas legais)