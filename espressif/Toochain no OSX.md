#### compilando o toolchain

```bash
cd ~ 
mkdir Espressif 
cd Espressif 
git clone -b lx106 git://github.com/jcmvbkbc/crosstool-NG.git 

Build the toolchain 

cd crosstool-NG 
./bootstrap && ./configure --prefix=`pwd` && make && make install 
./ct-ng xtensa-lx106-elf 
./ct-ng build 

Add the path to your bash file 

echo "export PATH=$PWD/builds/xtensa-lx106-elf/bin:$PATH" >> ~/.bashrc 

Install SDK 

cd ~/Espressif 
mkdir ESP8266_SDK 
wget -O esp_iot_sdk_v0.9.5_15_01_23.zip https://github.com/esp8266/esp8266-wiki/raw/master/sdk/esp_iot_sdk_v0.9.5_15_01_23.zip 
unzip esp_iot_sdk_v0.9.5_15_01_23.zip 
mv esp_iot_sdk_v0.9.5 ESP8266_SDK 
mv License ESP8266_SDK/ 
cd ESP8266_SDK/ 
cd esp_iot_sdk_v0.9.5/ 
mv * ../ 



Get Headers 

cd ~/Espressif/ESP8266_SDK 
wget -O lib/libc.a https://github.com/esp8266/esp8266-wiki/raw/master/libs/libc.a 
wget -O lib/libhal.a https://github.com/esp8266/esp8266-wiki/raw/master/libs/libhal.a 
wget -O include.tgz https://github.com/esp8266/esp8266-wiki/raw/master/include.tgz 
tar -xvzf include.tgz 

Get ESP Tool 

cd ~/Espressif 
wget -O esptool_0.0.2-1_i386.deb https://github.com/esp8266/esp8266-wiki/raw/master/deb/esptool_0.0.2-1_i386.deb 
sudo dpkg -i esptool_0.0.2-1_i386.deb 

Get ESP upload tool 

cd ~/Espressif 
git clone https://github.com/themadinventor/esptool esptool-py 
ln -s $PWD/esptool-py/esptool.py crosstool-NG/builds/xtensa-lx106-elf/bin/ 

Check you can build stuff. 

cd ~/Espressif 
git clone https://github.com/esp8266/source-code-examples.git 
cd source-code-examples/blinky 
```