GAME DESIGN DOCUMENT
====================

=======
DEV LOG
=======

### DEVLOG IS NO LONGER BEING UPDATED

#### 10/11/2016:

Fixed lots of bugs, and added a tutorial level!
Made the game play the tutorial level the first time, then unlock the tutorial to be played
from the main menu.

#### 08/11/2016 - 09/11/2016:

Finished save system. For now only using two variables: first_time and continue.
First time is used for the tutorial (if its the first time the player is playing, the new game will go to the tutorial
instead of the main game).
Continue is used in case the player lost or quited the game while in the middle of a run (and past level 1).
He can then continue from the start of the last level he reached, reseting his lives and score.

Also made all the functionalities for the continue button, and as an extra, added "overtext" for buttons,
that appear when you have the mouse over them.

#### 27/10/2016 - 07/11/2016:

Finished boss 2, and made lots of tweaks on psycho to make him more enjoyable to play with.

Started save and filesystem, but still needs work.

Th group decided on a short iteration, because later I will have to focus on the poster and report for the project.

#### 26/10/2016:

Made death messages!

Also fix a bug where boss titles (and probably level titles, but didn't test) would stay
forever after gameover screen.

#### 25/10/2016:

Made part 2 and 3 of the boss. Seems fully working, but still needs some balancing.
Also, forgot to merge with master for version 0.0.0.8. Did this now. Oops.

#### 24/10/2016:
@yancouto, virtual @renatogeh

Finished all remaining issues for the iteration, and also learned hwo to use stencil to draw the boss properly.

The group got together (renato geh by messenger), and decided next iteration:

Two weeks to make boss 2, and as filler, make death messages, some preparations for 3-1 and make some fist steps on the save system.


#### 20/10/2016:

Focused on  last issues for iteration:
Made boss 2 intro and the start of the first part.

Also made some balances on level2 based on feedback.



#### 19/10/2016:

Finished level 2-3 and made some changes on turrets (they are now drawn above other enemies and
give out score depending on the number and type of enemies they are spawning)

#### 18/10/2016:

Finally changed the way Circles are drawn, using shaders with smoothstep.
Still need to change the way "line" circles are drawn in the future.
Finished turrets and start of level 2-3.

#### 17/10/2016:
@yancouto, @renatogeh

Group meeting today. Discussed what to do for next iteration.

Started doing the turrets, and almost finished (still need some indicator when its taking damage).
Made lots of changes on aim and mouse, so now th mouse is captured and invisible while in the game
gamestate.

Made some small changes to the SFX @rodrigopassos helped make, and fix a blur bug where
I was creating too many canvas.

#### 11/10/2016:

Made screen blur on pause. Had some difficult to manage the canvas, but while
doing the blur, fixed a bug where the blinking screen bug still happened on the letterboxes

#### 10/10/2016:

Finished 2-2 and this iteration

#### 07/10/2016:

Started working on level 2-2. For that, created grey ball and glitch ball.
Tweaked psycho stats based on player feedback.
Change psycho staring position to be relevant to each level.

#### 06/10/2016:

Finished level 2-1 and fixed some bugs

#### 05/10/2016:

Improvements on level 2-1, made and included song for level 2 and fixed resolutions bugs.
Rodrigo Passos came today and started helping with the game. He will focus on making bgms and sfx.

#### 03/10/2016:

Fixed bug where enemies would give out score when psycho is dead and improved death animation with some fade-in and outs.

#### 02/10/2016:

Fixed bug where psycho would die, but enemies would still try to give him score.
Improved psycho death explosion animation

#### 01/10/2016:

Improved menu buttons and created batch for indicators, so they won't spawn desynched

#### 30/09/2016:

Added score system, and player can get lives and ultrablasts from score.
Still need to balanced, which might take a while and lots of playtesting.
Deciding which other issues to complete before the next iteration, probably make the menu screen better and add control for sound.

#### 29/09/2016:

Made focused mode and fixed some Ultrablast bugs

#### 28/09/2016:

Made Ultrablast mode!

#### 27/09/2016:

Created a milestone for this week until next monday, to make some useful bug correction and refactoring.
If I have time, will make score system and save.

Fixed "screen flashing black" bug using canvas.
Refactored particle system to avoid potential lag.

#### 24-27/09/2016:

Finished Boss 1!!
Also finished all issues for this iteration, including level 1 ^^

#### 19-23/09/2016:

Finishing remaining issues for this iteration.
Aim and circle effects added.
Enemy indicator working.

#### 12-16/09/2016:

Working on level scripts, removing bugs and lags.
Part 1-1 and 1-2 are basicaly finished.
See more at the commits.

#### 11/09/2016:

Finishing making COOL DEATH EXPLOSIONS!

Now psycho dies in cool ways. Stiil need to add more death functions to create
different patterns.

#### 07/09/2016:

Made a simple background with color transitions, initial steps to psycho lives counter and added a different radius for psycho's collision.
Considered finish current iteration (way ahead of schedule haha), and doing small things.

#### 06/09/2016:

Made improvements to the test level (but already imagining to be the level1).

Added particle explosions when enemies die.

#### 05/09/2016:

Forgot to register, but some days ago did all the base for level script!!
Now we can easily make levels using enemies formations.
Today I added two new formations (single and line), and added support to change the game resolution!
You can now resize the window in-game, and the game already scales everything up properly (creating letterboxes
when needed).

To get the missed progress, check out the commit page on our repository.

#### 30/08/2016:

Started and finished color transition task!
Game objects now transition between pre-defined color tables that each object has.

#### 29/08/2016:

Cleared all issues for version 0.0.0.1!
Started using a kanban and planned next iteration to be three weeks, with the main task being:
-Level Script: create the way of scripting levels, and make a simple test level to test it.
-Color transition: make objects have color transitions.

#### 28/08/2016:

Cleared almost all issues for ver 0.0.0.1!.
Now a simple version of 3 gamestates are made (still needs main menu)!
Check the commits for full changes

#### 27/08/2016:

Trying to clear all issues this weekend. Full activities tomorrow.

#### 26/08/2016:
@renatogeh

Working on pause screen and changes on some fonts.

#### 25/08/2016:
@yancouto

Transfered STEAMING template to this repository!
 - Started arranging documents (LICENSE, DEVLOG, CHANGELOG).
 - Created issues on the repository based on previous discussion with the group
 - Made inicial steps for the game (creating player classes/adding HSL compatibility)
 - Added player movement!
 - Added bullets that are removed when leaving the screen!

#### 24/08/2016:

Continued working on a level song. Should be ready in the next iteration working on it

#### 23/08/2016:

Used the day to start making music for the game. Started on some draft for a level song.

#### 22/08/2016:

Working on STEAMING documentation and implementation

#### 21/08/2016:

Started playing with [LMMS](https://lmms.io/) to create some music. Mainly it was for testing the software and imagining some good tunes

#### 18/08/2016:

Changed LoGaTe name to STEAMING (with LOVE), and started working on documentation.

#### 17/08/2016:
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

#### 16/08/2016:
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

#### 12/08/2016:

Avançando no LoGaTe:
- Analisando vários códigos que criei para o projeto TR0N0S, e utilizando a biblioteca de funções HUMP (http://hump.readthedocs.io/en/latest/),
já tenho uma base para rodar os gamestates.
- Testando deixar arquivos separados para cada gamestate, e pensando como simplificar o jeito de desenhar objetos.

#### 11/08/2016:

Começando a trabalhar no LoGaTe (https://github.com/uspgamedev/LoGaTe), que servirá de game template para o Projeto Telos.

Iniciei analisando jogos antigos (TR0N0S e PsyChObALL), e baseando em ideias que tive durante seu desenvolvimento:

Utilizar de classes que terão seu próprio método de desenhar e funções próprias;
Gamestates que rodam seu próprio laço de desenhar e processamentos gerais;
Todos objetos a serem desenhados são colocados em tables hierárquicas, que vem da menor (desenhada primeiro, fica embaixa) até a maior (desenhada por última, fica em cima), que em cada laço tem todos seus objetos desenhados (chamando as funções respectivas para tal).

#### 10/08/2016:
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

#### 09/08/2016:
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
