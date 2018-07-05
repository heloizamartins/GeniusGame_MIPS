# GeniusGame_MIPS
Genius era um brinquedo muito popular na década de 1980. Ele foi o primeiro jogo eletrônico vendido pela Estrela no Brasil, sendo ele uma versão licenciada do Simon, do fabricante americano Hasbro. O brinquedo buscava estimular a memorização de cores e sons. Com um formato semelhante a um OVNI, possuía botões coloridos que emitiam sons harmônicos e se iluminavam em sequência. Cabia aos jogadores repetir o processo sem errar.

## Descrição e funcionamento do jogo
A implementação foi feita utilizando a linguagem Assembly no software Mars 4.5. No ínicio o usuário deve conectar primeiro o bitmap display e configurá-lo da seguinte maneira:
```
display width in pixels:  512		
display height in pixels: 256		
unit width in pixels: 	8 
unit height in pixels: 	8
```
Após isso, conectar o Keyboard and Display MMIO Simulator do Mars. Quando ligar o jogo, aparecerá um menu onde irá solicitar ao usuário se ele deseja iniciar o jogo ou encerrar o programa. Caso o usuário digite 1, será solicitado a quantidade de repetições que ele quer jogar e em seguida, a velocidade (duração das ativações) em ms.
Para jogar, o usuário deverá seguir as cores de acordo com a ordem de acionamento. Para representar cada cor, foram utilizados os numeros do teclado, sendo eles : 2, 4, 6 e 8, representando respectivamente as seguintes cores: vermelho, verde, azul e amarelo.

## contribuidores
* **Heloiza Martins Schaberle**
* **Suzi Yousif**
