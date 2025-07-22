import 'package:coin_and_claw/core/constants.dart';
import 'package:flame/components.dart';

class RoomBackground extends World {
  @override
  Future<void> onLoad() async {
    final sprite = await Sprite.load(SpriteAssetsRoutes.roomBackground);
    add(
      SpriteComponent(
        sprite: sprite,
        anchor: Anchor.topLeft,
        position: Vector2.zero(),
      ),
    );
  }
}
