# native_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


### アプリケーションの実行は
```shell script
% flutter run --dart-define=DEBUG_PAINT_SIZE=false --dart-define=BACKEND_ORIGIN=https://api.example.com
```

### テストの実行は
```shell script
% flutter test --dart-define=DEBUG_PAINT_SIZE=false --dart-define=BACKEND_ORIGIN=https://api.example.com
```

### freezedの生成ファイル作成は
```shell script
% flutter pub run build_runner build --delete-conflicting-outputs
```

### 何故かビルドエラーになる時は
Dart Analysisの再実行
![再実行](https://user-images.githubusercontent.com/22732544/103027860-69783180-4535-11eb-98b0-b9631f59a531.png)
もしくは、
```shell script
% flutter clean
```
