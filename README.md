# SWEST S4C UIAPduinoワークショップ

Apple Silicon版macOS Tahoe上で、UIAPduino Pro Micro CH32V003の開発環境を構築するためのリポジトリです。

## 方針

- 開発ツールとlibusbはmiseでバージョン管理します。
- miseのデータ、キャッシュ、状態はリポジトリ内の`.mise/`へ隔離します。
- Arduino CLIはUIAPduinoの配布済みホストツールに合わせ、Rosetta 2上でx86_64版を実行します。
- Arduinoのコア、ツール、ダウンロード、スケッチブックはリポジトリ内の`.arduino/`へ隔離します。
- UIAPduinoへの書き込みに使う`minichlink`は、後続手順でarm64 macOS向けにビルドして置き換えます。
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

## arm64版minichlink

miseのcondaバックエンドで導入した`libusb`を使い、UIAP公式forkからネイティブ版の書き込みツールをビルドします。ソースと成果物は、それぞれ`.cache/`と`.build/`へ隔離されます。Homebrew版の`libusb`は不要です。

```shell
./tools/mise-local run minichlink:install
```

実機をリセットボタンを押しながら接続し、ボタンを離してから、macOS TahoeでのHID接続を確認します。

```shell
./tools/mise-local run minichlink:probe
```

成功時は`Detected CH32V003`などの情報が表示されます。
