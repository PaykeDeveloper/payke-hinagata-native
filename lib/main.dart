import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:native_app/app.dart';
import 'package:native_app/base/constants.dart';

void main() {
  debugPaintSizeEnabled = debugPrintSize;
  runApp(App());
}
