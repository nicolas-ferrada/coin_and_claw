import 'dart:async';

import 'package:coin_and_claw/presentation/bloc/game_bloc/game_bloc.dart';
import 'package:coin_and_claw/presentation/game/characters/cat_character.dart';
import 'package:coin_and_claw/presentation/game/levels/background_room.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame {
  final BackgroundRoom roomBackground = BackgroundRoom();
  final CatCharacter catCharacter = CatCharacter(
    currentAnimation: CatCharacterState.idle,
  );

  @override
  Color backgroundColor() => const Color(0xff181425);

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    // Set up camera to render the 'world'
    camera = CameraComponent.withFixedResolution(
      width: 180,
      height: 320,
      world: roomBackground,
    )..viewfinder.anchor = Anchor.topLeft;

    // Provide your game Bloc to all children of the world
    await add(
      FlameBlocProvider<GameBloc, GameState>(
        create: () => GameBloc(),
        children: [
          // this is the world that the camera will render
          roomBackground,
        ],
      ),
    );

    // Add the camera to render the world
    add(camera);

    // Add the cat character to the room background
    await roomBackground.add(
      catCharacter
        ..priority = 1
        ..anchor = Anchor.bottomCenter
        ..position = Vector2(100, 275)
        ..size = Vector2.all(64),
    );

    return super.onLoad();
  }
}
