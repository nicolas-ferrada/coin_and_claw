import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'package:coin_and_claw/presentation/bloc/game_bloc/game_bloc.dart';
import 'package:coin_and_claw/domain/models/update_type_model.dart';
import 'package:coin_and_claw/presentation/game/my_game.dart';

/// Simple HUD button that buys the Catnip Frenzy upgrade when tapped.
class ShopButton extends PositionComponent
    with HasGameReference<MyGame>, TapCallbacks {
  ShopButton({Vector2? position, Anchor anchor = Anchor.topLeft}) {
    this.position = position ?? Vector2(10, 20);
    this.anchor = anchor;
    size = Vector2(160, 28);
    priority = 2;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Button background
    add(RectangleComponent(size: size, paint: Paint()..color = Colors.white70));

    // Button label
    add(
      TextComponent(
        text: 'Buy Frenzy (100): 8s',
        anchor: Anchor.center,
        position: size / 2,
        textRenderer: TextPaint(
          style: const TextStyle(color: Colors.black87, fontSize: 12),
        ),
      ),
    );
  }

  @override
  bool onTapDown(TapDownEvent event) {
    game.gameBloc.add(PurchaseUpgradeEvent(UpgradeType.catnipFrenzy));

    return true;
  }
}
