# SWEST S4C UIAPduinoワークショップ

Apple Silicon版macOS Tahoe上で、UIAPduino Pro Micro CH32V006 V1.1の開発環境を構築するためのリポジトリです。

## 方針

- 開発ツールはmiseでバージョン管理します。
- miseのデータ、キャッシュ、状態はリポジトリ内の`.mise/`へ隔離します。
- `ch32fun`のソース、クロスコンパイラ、libusb、ビルド成果物をリポジトリ内へ隔離します。
- CH32V006 V1.1はArduino未対応のため、公式`ch32fun`でビルドします。
- 書き込みにはオンボードCH32V003デバッガと`minichlink`を使います。

## 準備

UIAP公式ドキュメントが推奨するGCC 13に合わせ、[xPack公式のarm64版GCC 13.2.0](https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases/tag/v13.2.0-2)をリポジトリ内へ導入します。Rosetta 2やグローバルなクロスコンパイラは不要です。

```shell
./tools/mise-local install
./tools/mise-local run doctor
```

以降もグローバルなmiseデータ領域を使わないよう、`./tools/mise-local`経由で実行します。

## Blinkのコンパイル

内蔵LEDが接続された`PC3`を250ms間隔で点滅させるファームウェアをコンパイルします。

```shell
./tools/mise-local run ch32v006:compile-blink
```

成果物は`.build/ch32v006/blink/`へ出力されます。

## CH32V006への書き込み

オンボードCH32V003デバッガを検出します。

```shell
./tools/mise-local run ch32v006:probe
```

Blinkをコンパイルして書き込みます。

```shell
./tools/mise-local run ch32v006:flash-blink
```

書き込みにはVID/PID `1209:B806`と`funprog`プロトコルを使用します。V003向けのHIDブートローダーと通信方式が異なるため、`uiapflash`は使用できません。

2026年8月4日ロットを使用し、macOS Tahoeとプログラマファームウェア5.00の組み合わせで、CH32V006の検出、62 KiBのFlash認識、Blinkの書き込みを実機確認済みです。このロットではVID/PID `1209:B806`と`funprog`の指定をそのまま使用できます。`minichlink`は新しいプログラマファームウェア5.20を案内しますが、5.00でも書き込みできます。

## PC0に関する注意

一部の評価サンプルでは、V006から`PC0`を操作するとオンボードV003デバッガがリセットされ、外部デバッガによる復旧が必要になります。このリポジトリのBlinkは`PC3`だけを操作します。

V003デバッガのNRSTをGPIOに変更していないボードでは、`PC0`を出力として使用しないでください。変更手順と復旧手順は[UIAPduino Pro Micro CH32V006 V1.1公式ドキュメント](https://www.uiap.jp/uiapduino/pro-micro/ch32v006/v1dot1)を参照してください。

## 2026年3月4日ロット

このロットはデバッガのVID/PIDが工場出荷時設定と異なります。該当する場合は、タスク内の`-c 0x1209b806 -C funprog`を外した次の形式で実行してください。

```shell
.build/tools/minichlink -i
.build/tools/minichlink -w .build/ch32v006/blink/blink.bin flash -b
```
