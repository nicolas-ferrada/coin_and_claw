import 'package:coin_and_claw/core/constants.dart';
import 'package:flame/components.dart';

class BackgroundRoom extends World {
  @override
  Future<void> onLoad() async {
    final sprite = await Sprite.load(
      SpriteAssetsRoutesConstants.roomBackground,
    );

    add(SpriteComponent(sprite: sprite));

    return super.onLoad();
  }
}
