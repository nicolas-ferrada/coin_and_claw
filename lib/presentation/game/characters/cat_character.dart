import 'dart:async';
import 'package:coin_and_claw/core/constants.dart';
import 'package:coin_and_claw/presentation/bloc/game_bloc/game_bloc.dart';
import 'package:coin_and_claw/presentation/game/my_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

enum CatCharacterState { idle, excited, laydown, surprised }

class CatCharacter extends SpriteAnimationGroupComponent
    with HasGameReference<MyGame>, TapCallbacks {
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation excitedAnimation;
  late final SpriteAnimation laydownAnimation;
  late final SpriteAnimation surprisedAnimation;

  final CatCharacterState initialAnimation;

  CatCharacter({required this.initialAnimation});

  final double stepTime = 00.10;

  @override
  Future<void> onLoad() async {
    _loadAllAnimations();
    return super.onLoad();
  }

  void _loadAllAnimations() {
    idleAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache(SpriteAssetsRoutesConstants.catIdle),
      SpriteAnimationData.sequenced(
        amount: 10,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
    excitedAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache(SpriteAssetsRoutesConstants.catExcited),
      SpriteAnimationData.sequenced(
        amount: 12,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
    laydownAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache(SpriteAssetsRoutesConstants.catLaydown),
      SpriteAnimationData.sequenced(
        amount: 12,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
    surprisedAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache(SpriteAssetsRoutesConstants.catSurprised),
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

    current = initialAnimation;
  }

  @override
  bool onTapDown(TapDownEvent event) {
    // send a TapEvent into the bloc
    game.gameBloc.add(TapEvent());
    return true;
  }
}
