import 'package:flutter/material.dart';

abstract class MainInterface {
  ScaffoldState? getScaffoldState();

  NavigatorState? getNavigatorState(int index);
}
