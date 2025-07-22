import 'dart:async';
import 'package:coin_and_claw/core/constants.dart';
import 'package:coin_and_claw/game/my_game.dart';
import 'package:flame/components.dart';

enum CatCharacterState { idle, excited, laydown, surprised }

class CatCharacter extends SpriteAnimationGroupComponent
    with HasGameReference<MyGame> {
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation excitedAnimation;
  late final SpriteAnimation laydownAnimation;
  late final SpriteAnimation surprisedAnimation;

  final CatCharacterState currentAnimation;

  CatCharacter({required this.currentAnimation});

  final double stepTime = 00.10;

  @override
  Future<void> onLoad() async {
    _loadAllAnimations();
    return super.onLoad();
  }

  void _loadAllAnimations() {
    idleAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache(SpriteAssetsRoutes.catIdle),
      SpriteAnimationData.sequenced(
        amount: 10,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
    excitedAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache(SpriteAssetsRoutes.catExcited),
      SpriteAnimationData.sequenced(
        amount: 12,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
    laydownAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache(SpriteAssetsRoutes.catLaydown),
      SpriteAnimationData.sequenced(
        amount: 12,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
    surprisedAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache(SpriteAssetsRoutes.catSurprised),
      SpriteAnimationData.sequenced(
        amount: 12,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );

    animations = {
      CatCharacterState.idle: idleAnimation,
      CatCharacterState.excited: excitedAnimation,
      CatCharacterState.laydown: laydownAnimation,
      CatCharacterState.surprised: surprisedAnimation,
    };

    current = currentAnimation;
  }
}
