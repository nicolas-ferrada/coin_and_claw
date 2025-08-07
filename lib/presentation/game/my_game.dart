import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

import 'package:coin_and_claw/presentation/bloc/game_bloc/game_bloc.dart';
import 'package:coin_and_claw/presentation/game/levels/background_room.dart';
import 'package:coin_and_claw/presentation/game/characters/cat_character.dart';

class MyGame extends FlameGame {
  // --- BLoC ---
  late final GameBloc gameBloc;

  // --- Game world & entities ---
  final BackgroundRoom background = BackgroundRoom();
  final CatCharacter player = CatCharacter(
    currentAnimation: CatCharacterState.idle,
  );

  // --- UI ---
  late final TextComponent coinCounter;

  @override
  Color backgroundColor() => const Color(0xff181425);

  @override
  Future<void> onLoad() async {
    // 1) Preload all images
    await images.loadAllImages();

    // 2) Create and add the FlameBlocProvider
    final flameBlocProvider = FlameBlocProvider<GameBloc, GameState>(
      create: () {
        gameBloc = GameBloc()..add(LoadGameEvent());
        return gameBloc;
      },
    );
    await add(flameBlocProvider);

    // 3) Add the game world under the provider
    flameBlocProvider.add(background);

    // 4) Set up the camera for our fixed-resolution world
    final cameraComponent = CameraComponent.withFixedResolution(
      width: 180,
      height: 320,
      world: background,
    )..viewfinder.anchor = Anchor.topLeft;
    flameBlocProvider.add(cameraComponent);

    // 5) Add the player character into the world
    player
      ..priority = 1
      ..anchor = Anchor.bottomCenter
      ..position = Vector2(100, 275)
      ..size = Vector2.all(64);
    await background.add(player);

    // 6) Initialize and add the coin counter UI
    coinCounter = TextComponent(
      text: 'Coins: 0',
      position: Vector2(10, 25),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.white, fontSize: 32),
      ),
    );
    flameBlocProvider.add(coinCounter);

    // 7) Listen for coin updates and refresh the UI
    flameBlocProvider.add(
      FlameBlocListener<GameBloc, GameState>(
        listenWhen: (_, state) => state is GameSuccess,
        onNewState: (state) {
          if (state is GameSuccess) {
            coinCounter.text = 'Coins: ${state.gameStateModel.coins}';
          }
        },
      ),
    );
  }
}
