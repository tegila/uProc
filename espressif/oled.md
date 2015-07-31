###OLED 128x64
------------
Para começar então, os displays OLED são controlados por SPI:
![](https://upload.wikimedia.org/wikipedia/commons/thumb/e/ed/SPI_single_slave.svg/525px-SPI_single_slave.svg.png)

Com algumas leves alterações:

|  SPI |   ESP8266  | OLED |
|:----:|:----------:|:----:|
| SCLK |   GPIO14   |  D0  |
| MOSI |   GPIO13   |  D1  |
| MISO | (not used) |   -  |
|  !SS |   GPIO15   |  CS  |
|   -  |    GPIO2   |  DC  |
|   -  |   GPIO16   |  RST |


