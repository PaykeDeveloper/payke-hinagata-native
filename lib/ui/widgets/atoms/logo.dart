import 'package:flutter/material.dart';
import 'package:native_app/ui/constants.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(ImagePaths.logo);
  }
}
