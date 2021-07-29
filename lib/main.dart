import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:native_app/base/api_client.dart';

import './app.dart';
import './base/constants.dart';

void run({DioInspector? backendInspector}) =>
    runApp(App(backendInspector: backendInspector));

void main() {
  debugPaintSizeEnabled = debugPrintSize;
  run();
}
