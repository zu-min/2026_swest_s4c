# SWEST S4C UIAPduinoワークショップ

Apple Silicon版macOS Tahoe上で、UIAPduino Pro Micro CH32V003の開発環境を構築するためのリポジトリです。

## 方針

- 開発ツールはmiseでバージョン管理します。
- Arduino CLIはUIAPduinoの配布済みホストツールに合わせ、Rosetta 2上でx86_64版を実行します。
- Arduinoのコア、ツール、ダウンロード、スケッチブックはリポジトリ内の`.arduino/`へ隔離します。
- UIAPduinoへの書き込みに使う`minichlink`は、後続手順でarm64 macOS向けにビルドして置き換えます。
- NixやDevboxは、ネイティブビルド依存の隔離がmiseだけでは不十分だと判明した場合に追加します。

## 準備

```shell
mise trust
mise install
mise run doctor
```

## UIAPduinoコアの導入

```shell
mise run arduino:install-core
mise run arduino:list-boards
mise run arduino:compile-blink
```

`arduino:compile-blink`の成果物は`.build/blink/`へ出力されます。

## arm64版minichlink

既存のHomebrew環境に`libusb`があることを前提に、UIAP公式forkからネイティブ版を書き込みツールをビルドします。ソースと成果物は、それぞれ`.cache/`と`.build/`へ隔離されます。

```shell
mise run minichlink:install
```

実機をリセットボタンを押しながら接続し、ボタンを離してから、macOS TahoeでのHID接続を確認します。

```shell
mise run minichlink:probe
```

成功時は`Detected CH32V003`などの情報が表示されます。
