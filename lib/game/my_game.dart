import 'dart:async';

import 'package:coin_and_claw/game/levels/cat_room_level.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame {
  final RoomBackground roomBackground = RoomBackground();

  @override
  Color backgroundColor() => Color(0xff181425);

  @override
  FutureOr<void> onLoad() {
    camera = CameraComponent.withFixedResolution(
      width: 640, // 40 tiles × 16 px
      height: 368, // 23 tiles × 16 px
      world: roomBackground,
    );
    camera.viewfinder.anchor = Anchor.topLeft;

    addAll([camera, roomBackground]);

    return super.onLoad();
  }
}
