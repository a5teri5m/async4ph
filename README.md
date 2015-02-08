## 概要

 * BASYS3(DigilentのFPGA)とFlashAir(東芝のWiFi付きSDカード)を使った非同期データ転送のサンプル
 * FlashAirのGPIO機能を使ってブラウザから16bitのデータを4相2線エンコードで2bit x 8回の転送を行い，
   BASYS3上の7セグLEDに転送したデータを表示する


## 使用ツール

 * Vivado 2014.4


## 使用方法

 1. FlashAirの`/SD_WLAN/CONFIG`を`IFMODE=1`に設定する
 1. FlashAirの`/SD_WLAN`に`flashair/List.htm`をコピーする
 1. BASYS3のPmod(JB)にFlashAirを接続する(下記接続対応表参照)
 1. `cd basys3; vivado -mode batch -source async4ph.tcl`を実行する
 1. Vivadoを起動(`vivado project/async4ph.xpr`)して，論理合成・インプリ・ビットストリーム生成を行う
 1. ビットストリームをBASYS3に書き込む
 1. FlashAirに接続して`http://flashair/`にアクセスする
 1. Dataに16進数16bitのデータ(0000～ffff)を入力して，`send`ボタンをクリック
 1. BASYS3の7セグLEDに入力した16進数のデータが表示される
    * StatusがEndになるまでは転送途中．どうしても終わらない場合はブラウザ上のリセットを押した後にFPGAのリセットを押す.


### FPGA-SDカード接続対応表


| FPGA             | Pmod(Sch. name) | SD Pin | SD Card    |
|------------------|-----------------|--------|------------|
| (Pmod VDD)       | JB6             | 4      | VDD        |
| (Pmod VSS)       | JB5             | 3,6    | VSS1, VSS2 |
| flashair_data[0] | JB1             | 2      | CMD        |
| flashair_data[1] | JB2             | 7      | DAT0       |
| flashair_data[2] | JB3             | 8      | DAT1       |
| flashair_data[3] | JB4             | 9      | DAT2       |
| flashair_ack     | JB7             | 1      | CD/DAT3    |
