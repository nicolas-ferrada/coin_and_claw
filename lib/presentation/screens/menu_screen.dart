import 'package:coin_and_claw/presentation/game/my_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coin & Claw')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => GameWidget(game: MyGame())),
            );
          },
          child: const Text('Start Game'),
        ),
      ),
    );
  }
}
