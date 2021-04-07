import 'package:flutter/material.dart';

abstract class MainInterface {
  ScaffoldState? getScaffoldState();
}

extension MainInterfaceExt on MainInterface {
  void openDrawer() => getScaffoldState()?.openDrawer();
}
