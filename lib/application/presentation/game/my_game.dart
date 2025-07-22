import 'dart:async';

import 'package:coin_and_claw/application/presentation/game/characters/cat_character.dart';
import 'package:coin_and_claw/application/presentation/game/levels/background_room.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame {
  final BackgroundRoom roomBackground = BackgroundRoom();
  final CatCharacter catCharacter = CatCharacter(
    currentAnimation: CatCharacterState.idle,
  );

  @override
  Color backgroundColor() => const Color(0xff181425);

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    camera = CameraComponent.withFixedResolution(
      width: 180,
      height: 320,
      world: roomBackground,
    )..viewfinder.anchor = Anchor.topLeft;

    // Add the world + camera to the game root
    addAll([roomBackground, camera]);

    // Add the cat *into* the world so it’s rendered by the camera
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
