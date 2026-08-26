# SWEST S4C UIAPduinoワークショップ

Apple Silicon版macOS Tahoe上で、UIAPduino Pro Micro CH32V003の開発環境を構築するためのリポジトリです。

## 方針

- 開発ツールはmiseでバージョン管理します。
- miseのデータ、キャッシュ、状態はリポジトリ内の`.mise/`へ隔離します。
- Arduino CLIはUIAPduinoの配布済みホストツールに合わせ、Rosetta 2上でx86_64版を実行します。
- Arduinoのコア、ツール、ダウンロード、スケッチブックはリポジトリ内の`.arduino/`へ隔離します。
- UIAPduinoへの書き込みには、Apple SiliconとIntelの両方に対応した`uiapflash`を使います。
- NixやDevboxは、ネイティブビルド依存の隔離がmiseだけでは不十分だと判明した場合に追加します。

## 準備

```shell
./tools/mise-local install
./tools/mise-local run doctor
```

以降もこのリポジトリでは、グローバルなmiseデータ領域を使わないよう`./tools/mise-local`経由で実行します。

## UIAPduinoコアの導入

```shell
./tools/mise-local run arduino:install-core
./tools/mise-local run arduino:list-boards
./tools/mise-local run arduino:compile-blink
```

`arduino:compile-blink`の成果物は`.build/blink/`へ出力されます。

## UIAPduinoへの書き込み

`uiapflash`はUIAPduinoのHIDブートローダーへ直接書き込むため、Arduino IDE、外部の書き込み器、libusbは不要です。

実機をリセットボタンを押しながら接続し、ボタンを離してから、書き込みモードでのHID接続を確認します。

```shell
./tools/mise-local run uiapflash:probe
```

Blinkのコンパイルと書き込みは、次のコマンドでまとめて実行できます。

```shell
./tools/mise-local run arduino:upload-blink
```
