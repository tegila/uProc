## ESP8266

### Dia 1 - Vôs apresento a revolução no mundo IoT (Internet das Coisas)

![As Coisas](http://www.shenzhen-buy.com/images/esp.jpg)

> Primeiramente vale dizer que o dispositivo é bastante instável e que as vezes não responde aos comandos nem dá sinal de vida fazendo parecer que está estragado. Porém com um pouco de insistência, consegui fazer o meu funcionar sem queimar nenhum. Mesmo tendo invertido o VCC(3.3v) e o GND algumas vezes. :satisfied: 

> Na internet tem diversas advertências sobre não usar o ESP8266 diretamente no Arduino sem usar nenhuma **Conversor de Nível Lógico** de 3.3v (ESP8266) - 5v (Arduino). Isso me deixou um tanto apreensivo sobre a fragilidade e várias vezes pensei te-lo estragado.

> Maaaasss como eu usei uma Fonte para protoboard com 3.3v e um adaptador USB-TTL também de 3.3v não **abusei tanto da sorte**

> No começo estava com medo do ESP-12 não estar funcionando pois o **unico LED da placa ligava fraquinho**. Foi aí que eu resolvi dar uma pesquisada na internet e descobri que era necessário "ligar" outros terminais além do VCC/GND. Foi aí que eu descobri o seguinte esquema básico de ligação: 

![Arduino ESP8266](https://raw.githubusercontent.com/Links2004/Arduino/esp8266/docs/ESP_min.png)

> Seguindo os passos da montagem **sem usar nenhum resistor** e com uma fonte externa de 3.3v para protoboard e um adaptador usb-ttl 3.3v [PL2303]() consegui ligar o aparelho, mas ainda sem sinal no terminal mesmo tentando várias frequências. **Penso novamente que a placa já deve estar queimada pois o LED agora pisca duas vezes quando ligo e apaga para sempre**.

**TODO: Imagens da montagem**

### Dia 2 - Depois de muito sofrimento foi possível ver algum resultado

> A placa para de funcionar e volta do nada, depois de tentar várias vezes começou a apresentar alguns caracteres no terminal, fui tentando as baud rate recomendadas (9600, 57800 e 115200) até chegar a algum resultado.

> screen /dev/cu.usbserial 115200

```bash
AT+RST

OK

 ets Jan  8 2013,rst cause:4, boot mode:(3,2)

wdt reset
load 0x40100000, len 1320, room 16 
tail 8
chksum 0xb8
load 0x3ffe8000, len 776, room 0 
tail 8
chksum 0xd9
load 0x3ffe8308, len 412, room 0 
tail 12
chksum 0xb9
csum 0xb9

2nd boot version : 1.3(b3)
  SPI Speed      : 40MHz
  SPI Mode       : QIO
  SPI Flash Size : 8Mbit
jump to run user1

rl��Z�
Ai-Thinker Technology Co. Ltd.
```
> Agora descobri que muito provavelmente nem vou precisar ligar um arduino ao ESP8266 já que ele tem disponivel GPIO, ADC, PWM. Todo esse **poder** aliado a uma firmware OpenSource rodando lua com vários protocolos embutidos para fazer a comunicação com o ESP8266 diretamente através da internet(ou browser, melhor dizendo, Javascript SPA) podendo finalmente usufruir da verdadeira IoT(Internet Das Coisas). Em grande estilo :stuck_out_tongue_closed_eyes:

### Dia 3 - Instalação do NodeMCU

##### Requisitos:

> Antes de mais nada é **IMPORTANTE** lembrar que para entrar em _firmware update mode_ é necessário ligar o GPIO_0 no GND antes de ligar a placa.

```
easy_install pyserial
git clone https://github.com/themadinventor/esptool
wget https://raw.githubusercontent.com/nodemcu/nodemcu-firmware/master/pre_build/latest/nodemcu_latest.bin
```
> Ou caso queira escolher a sua propria versão do [NodeMCU](https://github.com/nodemcu/nodemcu-firmware/tree/master/pre_build)

> Fui ligar a placa que deixei com a fonte desligada, **APENAS** com os cabos conectados, quando voltei hoje: **O LED ficou ligado direto e o terminal não dava nem sinal de vida**. Liguei e religuei a placa diversas vezes, algumas vezes troquei o pino GPIO0 entre o VCC e o GND até que voltou a funcionar.

```bash
$ sudo python esptool.py --port /dev/cu.SLAB_USBtoUART write_flash 0x00000 nodemcu_latest.bin 
Connecting...
Erasing flash...
Writing at 0x00018400... (19 %) 
Writing at 0x0007ec00... (100 %)

Leaving...
```

### Conectando no terminal agora com baud rate 9600
```bash
$ screen /dev/cu.usbserial 9600
0�~?�4�!�Y�O;��e��OAE�e��$����

NodeMCU 0.9.6 build 20150216  powered by Lua 5.1.4
lua: cannot open init.lua
>
```
> O que são esses caracteres estranhos? :OMG:

> Depois de passar um pouco de raiva descobri que se eu ligar a placa com o screen já aberto não consigo enviar dados _TX_ e preciso reiniciar o terminal para poder enviar dados. BUUUTTT... consegui enviar os scripts lua para algo tipo um _FTP_ que a firmware cria. Lá você pode armazenar diversos programas e chama-los na ordem que quiser.

> Primeiramente será necessário instalar uma ferramenta que faz esse _upload_:

git clone https://github.com/kmpm/nodemcu-uploader

> Então criei um script para rodar quando a placa iniciar e já conectar direto no wifi. (init.lua)

```lua
wifi.setmode(wifi.STATION)
wifi.sta.config("SSID","PASSWORD")

function wifi_connect()
   ip = wifi.sta.getip()
     if ip ~= nill then
          print('Connected, ip is:' .. ip)
          tmr.stop(1)
          ready = 1
     else
          ready = 0
     end
end

tmr.alarm(1, 1111, 1, function()
     wifi_connect() 
     end)
```
> Logo depois fiz o upload para ver se a placa ia conseguir pegar o ip da minha rede wifi:

```bash
sudo python nodemcu-uploader.py --port /dev/cu.usbserial upload init.lua [--compile] [--restart]
```
> Resultado:

```bash
0�~?�4�!���AO:��a��OCE�������

NodeMCU custom build by frightanic.com
        branch: master
        commit: aaca524ce02fca3cccdeaf7a6ffd0c4640c84ecf
        SSL: true
        modules: node,file,gpio,wifi,net,tmr,uart,mqtt,cjson
        built on: 2015-07-09 19:18
  powered by Lua 5.1.4
> Connected, ip is:192.168.1.147
```

> Bom, antes disso passei diversas raivas com o fato do dispositivo não contar com nenhuma proteção contra erros de execução, então caso você faça upload de um programa e ele de erro o dispositivo irá entrar em boot-eterno. E você só conseguirá acessá-lo através do seguinte comando:

```bash
sudo python nodemcu-uploader.py --port /dev/cu.usbserial file format
```

### Integração com NodeJS, JavaScript e o mundo moderno.

> Nada seria divertido se o dispositivo ficasse solitário fazendo suas medições e você não pudesse acessa-lo através de um site seu, onde você pode reunir diversos dispositivos e transformar o HTML em um verdadeiro CLP feito em casa. Enfim IoT, mas como?

> Ainda não existe um modulo websockets ou uma firmata para o esp8266 fazendo a conexão do dispositivo *DIRETAMENTE* com a aplicação JS por exemplo, mas usando um servidor MQTT (ou (mosquitto)[http://mosquitto.org/] para os intimos) em contrapartida já é possível usar esse antigo sistema de troca de mensagens PUB/SUB das antigas mas que é peso leve(adequado para a situação) e com um servidor _mosquitto_ como proxy é possivel receber as informações do ESP8266 e enviar em outros protocolos, como por ex. WebSockets o///

> Mas como? (mqtt.lua)

[Use o `expressif esp8266` como um broadcast do sensor de presença](pir2mtqq/)

> Feito isso só falta escolher qual sensor você vai ligar na placa para receber as informações online. Achei um tópico em um forum no qual o usuário publicou diversos experimentos que ele fez com diversos sensores, vale muito a pena a leitura até para conhecer o *Node Red* que promete criar uma nova tendência nesse mundo IoT. Valeu o/

Referências:

[http://www.esp8266.com/viewtopic.php?f=19&t=2029](http://www.esp8266.com/viewtopic.php?f=19&t=2029)
[https://nurdspace.nl/ESP8266](https://nurdspace.nl/ESP8266)
[https://www.reddit.com/r/esp8266/comments/2yqunh/battery_powered_pir_sensor_with_esp8266_is_an/](https://www.reddit.com/r/esp8266/comments/2yqunh/battery_powered_pir_sensor_with_esp8266_is_an/)
[https://github.com/Jorgen-VikingGod/ESP8266-MFRC522](https://github.com/Jorgen-VikingGod/ESP8266-MFRC522)
[https://github.com/tuanpmt/esp_mqtt](https://github.com/tuanpmt/esp_mqtt)
[http://www.esp8266.com/wiki/doku.php?id=setup-osx-compiler-esp8266](http://www.esp8266.com/wiki/doku.php?id=setup-osx-compiler-esp8266)