### [LCD Raspberry Pi 2 WaveShare 32b - fb_ili9340](http://www.wvshare.com/product/3.2inch-RPi-LCD-B.htm)

#### Atualize sua placa
` sudo REPO_URI=https://github.com/notro/rpi-firmware rpi-update `

#### Adicione os parametros para ligar os pinos do SPI
```bash
# sudo nano /boot/config.txt
dtparam=spi=on
dtoverlay=ads7846,penirq=17,swapxy=1
```

#### Carregar módulos automaticamente na inicialização (drivers)
```bash
## sudo nano /etc/modules
spi-bcm2708
fbtft_device name=waveshare32b gpios=dc:22,reset:27 speed=48000000
waveshare32b width=320 height=240 buswidth=8 init=-1,0xCB,0x39,0x2C,0x00,0x34,0x02,-1,0xCF,0x00,0XC1,0X30,-1,0xE8,0x85,0x00,0x78,-1,0xEA,0x00,0x00,-1,0xED,0x64,0x03,0X12,0X81,-1,0xF7,0x20,-1,0xC0,0x23,-1,0xC1,0x10,-1,0xC5,0x3e,0x28,-1,0xC7,0x86,-1,0x36,0x28,-1,0x3A,0x55,-1,0xB1,0x00,0x18,-1,0xB6,0x08,0x82,0x27,-1,0xF2,0x00,-1,0x26,0x01,-1,0xE0,0x0F,0x31,0x2B,0x0C,0x0E,0x08,0x4E,0xF1,0x37,0x07,0x10,0x03,0x0E,0x09,0x00,-1,0XE1,0x00,0x0E,0x14,0x03,0x11,0x07,0x31,0xC1,0x48,0x08,0x0F,0x0C,0x31,0x36,0x0F,-1,0x11,-2,120,-1,0x29,-1,0x2c,-3
ads7846_device model=7846 cs=1 gpio_pendown=17 speed=1000000 keep_vref_on=1 swap_xy=0 pressure_max=255 x_plate_ohms=60 x_min=200 x_max=3900 y_min=200 y_max=3900
```

#### Editar os parametros de inicialização do sistema
> delete todo o conteudo desse arquivo e inclua os seguintes parametros:

```bash
# sudo nano /boot/cmdline.txt
dwc_otg.lpm_enable=0 console=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait fbtft_device.custom fbtft_device.name=waveshare32b fbtft_device.gpios=dc:22,reset:27 fbtft_device.bgr=1 fbtft_device.speed=48000000 fbcon=map:10 fbcon=font:ProFont6x11 logo.nologo dma.dmachans=0x7f35 console=tty1 consoleblank=0 fbtft_device.fps=50 fbtft_device.rotate=270
```

#### Direcionar o terminal 1 para o fb1 (framebuffer 1) [Opcional]
```bash
# sudo nano /etc/rc.local
con2fbmap 1 1
```

#### Configurar o xorg (modo gráfico) para utilizar o display [Opcional]
> Procurar a linha onde tiver /dev/fb0 e substituir por /dev/fb1

```bash
# sudo nano /usr/share/X11/xorg.conf.d/99-fbturbo.conf
```
#### Iniciar o modo gráfico no display [Opcional]
` FRAMEBUFFER=/dev/fb1 startx & `


#### Calibrar o Touch [Opcional]
` xinput_calibrator `