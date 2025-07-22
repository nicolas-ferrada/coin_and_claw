import 'package:coin_and_claw/presentation/screens/menu_screen.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setPortrait();
  runApp(MaterialApp(home: const MenuScreen()));
}
