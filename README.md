# (WIP) Hinagata Native

## 開発環境構築

[こちら](https://github.com/PaykeDeveloper/payke-hinagata/blob/main/README.md) を参照して下さい。

## Tips

### レイアウトの確認
```shell script
% flutter run --dart-define=DEBUG_PAINT_SIZE=false --dart-define=BACKEND_ORIGIN=http://localhost:8000
```

### テストの実行
```shell script
% flutter test --dart-define=BACKEND_ORIGIN=http://localhost:8000
```

### freezedの生成ファイル作成
```shell script
% flutter pub run build_runner build --delete-conflicting-outputs
```

### 何故かビルドエラーになる時
Dart Analysisの再実行
![再実行](https://user-images.githubusercontent.com/22732544/103027860-69783180-4535-11eb-98b0-b9631f59a531.png)
もしくは、
```shell script
% flutter clean
```
