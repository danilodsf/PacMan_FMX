# Pac-Man FMX (Delphi)

Esta é uma implementação do jogo Pac-Man desenvolvida usando o framework FireMonkey (FMX) do Delphi.



## Índice

* [Recursos](#recursos)
* [Tecnologias Utilizadas](#tecnologias-utilizadas)
* [Pré-requisitos](#pré-requisitos)
* [Configuração e Instalação](#configuração-e-instalação)
* [Como Jogar](#como-jogar)
* [Controles do Jogo](#controles-do-jogo)
* [Estrutura do Código](#estrutura-do-código)
* [Problemas Conhecidos](#problemas-conhecidos)
* [Melhorias Futuras](#melhorias-futuras)
* [Créditos](#créditos)
* [Licença](#licença)
* [Agradecimentos](#agradecimentos)
* [Contato](#contato)

## Recursos <a name="recursos"></a>

* Recriação fiel da jogabilidade clássica do Pac-Man.
* Animações suaves.
* IA básica dos fantasmas com comportamento de perseguição e fuga.
* Contagem de pontos.
* Sistema de vidas.
* Efeito de túnel (travessia da tela).
* Power pills e modo inofensivo.
* Tela de Game Over.

## Tecnologias Utilizadas <a name="tecnologias-utilizadas"></a>

* **Delphi**: A linguagem de programação principal.
* **FireMonkey (FMX)**: O framework UI cross-platform do Delphi para construir aplicativos que rodam em vários sistemas operacionais (embora este projeto possa ser focado em desktop).
* **Gráficos 2D**: O canvas do FMX para renderizar os elementos do jogo.

## Pré-requisitos <a name="pré-requisitos"></a>

Para compilar e executar este jogo, você precisará de:

* **IDE Delphi**: Embarcadero Delphi (versão Rio ou posterior recomendada).

## Configuração e Instalação <a name="configuração-e-instalação"></a>

1.  Clone o repositório para sua máquina local:

    ```bash
    git clone <url_do_repositório>
    ```

    *(Substitua `<url_do_repositório>` pela URL real do seu repositório GitHub)*

2.  Abra o arquivo de projeto `PacManFMX.dproj` na IDE do Delphi.
3.  Certifique-se de que todos os arquivos de imagem necessários estejam nos caminhos relativos corretos (geralmente em um diretório `img/` dentro do projeto).
4.  Compile e execute o projeto dentro da IDE do Delphi.

## Como Jogar <a name="como-jogar"></a>

O objetivo do jogo é controlar o Pac-Man e comer todos os pontos no labirinto enquanto evita os fantasmas. Comer uma power pill (os pontos maiores) permitirá que o Pac-Man coma os fantasmas por um curto período de tempo.

## Controles do Jogo <a name="controles-do-jogo"></a>

* **Movimento:**
    * `W` ou `Seta para Cima`: Mover para Cima
    * `A` ou `Seta para a Esquerda`: Mover para a Esquerda
    * `S` ou `Seta para Baixo`: Mover para Baixo
    * `D` ou `Seta para a Direita`: Mover para a Direita
* **Reiniciar o Jogo:**
    * `R`: Reiniciar o jogo
* **Sair:**
    * `ESC`: Sair do jogo

## Estrutura do Código <a name="estrutura-do-código"></a>

O projeto está principalmente contido no arquivo `uGame.pas`. Os principais procedimentos e funções incluem:

* `TPacManForm`: A classe do formulário principal.
* `FormCreate`: Inicializa as variáveis do jogo, carrega as imagens e configura o jogo.
* `FormDestroy`: Libera os recursos alocados (bitmaps, fonte).
* `PaintBoxPaint`: Lida com a lógica de renderização do jogo.
* `TimerTimer`: O evento do timer do jogo, que aciona o `PaintBoxPaint` para atualizar a exibição.
* `MovePlayer`: Processa a entrada do jogador para alterar a direção do Pac-Man.
* `DrawBoard`: Desenha o labirinto, os pontos e as power pills.
* `DrawPlayer`: Desenha e anima o Pac-Man.
* `DrawGhost`: Desenha os fantasmas.
* `GhostAI`: Implementa a lógica de comportamento dos fantasmas.
* `Collider`: Lida com a detecção de colisão com as paredes.
* `TurningCorner`: Gerencia as curvas do Pac-Man nos cantos.
* `PacmanTunnel`: Cria o efeito de túnel.
* `GhostAndPacmanCollision`: Detecta colisões entre o Pac-Man e os fantasmas.

## Problemas Conhecidos <a name="problemas-conhecidos"></a>

* *(Liste quaisquer bugs ou limitações conhecidos aqui. Por exemplo: "A IA dos fantasmas pode ser aprimorada," "Efeitos sonoros não estão implementados," etc.)*

## Melhorias Futuras <a name="melhorias-futuras"></a>

* *(Liste os recursos que você planeja adicionar ou as melhorias que deseja fazer. Por exemplo: "Implementar efeitos sonoros," "Adicionar diferentes personalidades aos fantasmas," "Melhorar a interface do usuário do jogo," etc.)*

## Créditos <a name="créditos"></a>

* **Autor:** Seu Nome / Seu Nome de Usuário do GitHub
* *(Opcional: Credite quaisquer fontes que você usou para imagens, inspiração, etc.)*

## Licença <a name="licença"></a>

*(Especifique a licença sob a qual seu projeto é lançado. Se você não tiver certeza, considere usar a Licença MIT, que é permissiva.)*
