import 'dart:async';

import 'package:coin_and_claw/game/characters/cat_character.dart';
import 'package:coin_and_claw/game/levels/background_room.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame {
  final BackgroundRoom roomBackground = BackgroundRoom();
  final CatCharacter catCharacter = CatCharacter(
    currentAnimation: CatCharacterState.idle,
  );

  @override
  Color backgroundColor() => Color(0xff181425);

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    camera = CameraComponent.withFixedResolution(
      width: 180,
      height: 320,
      world: roomBackground,
    );
    camera.viewfinder.anchor = Anchor.topLeft;

    addAll([camera, roomBackground, catCharacter]);

    return super.onLoad();
  }
}
