import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

import 'package:coin_and_claw/presentation/bloc/game_bloc/game_bloc.dart';
import 'package:coin_and_claw/presentation/game/levels/background_room.dart';
import 'package:coin_and_claw/presentation/game/characters/cat_character.dart';

class MyGame extends FlameGame {
  late final GameBloc gameBloc;
  final BackgroundRoom roomBackground = BackgroundRoom();
  final CatCharacter catCharacter = CatCharacter(
    currentAnimation: CatCharacterState.idle,
  );

  @override
  Color backgroundColor() => const Color(0xff181425);

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    // Create the Bloc provider
    final blocProvider = FlameBlocProvider<GameBloc, GameState>(
      create: () {
        gameBloc = GameBloc()..add(LoadGameEvent());
        return gameBloc;
      },
    );
    await add(blocProvider);

    // 2) Add the world under the provider
    blocProvider.add(roomBackground);

    // 3) Set up the camera
    camera = CameraComponent.withFixedResolution(
      width: 180,
      height: 320,
      world: roomBackground,
    )..viewfinder.anchor = Anchor.topLeft;
    blocProvider.add(camera);

    // 4) Add the cat character into the world
    await roomBackground.add(
      catCharacter
        ..priority = 1
        ..anchor = Anchor.bottomCenter
        ..position = Vector2(100, 275)
        ..size = Vector2.all(64),
    );

    // 5) Add coin counter TextComponent under the provider
    final coinText = TextComponent(
      text: 'Coins: 0',
      position: Vector2(10, 25),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.white, fontSize: 32),
      ),
    );
    blocProvider.add(coinText);

    // 6) Add the Bloc listener under the provider
    blocProvider.add(
      FlameBlocListener<GameBloc, GameState>(
        listenWhen: (_, curr) => curr is GameSuccess,
        onNewState: (state) {
          if (state is GameSuccess) {
            coinText.text = 'Coins: ${state.gameStateModel.coins}';
          }
        },
      ),
    );
  }
}
