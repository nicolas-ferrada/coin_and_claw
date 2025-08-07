import 'dart:async';

import 'package:coin_and_claw/core/constants.dart';
import 'package:coin_and_claw/domain/models/game_state_model.dart';
import 'package:coin_and_claw/presentation/game/hud/shop.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

import 'package:coin_and_claw/presentation/bloc/game_bloc/game_bloc.dart';
import 'package:coin_and_claw/presentation/game/levels/background_room.dart';
import 'package:coin_and_claw/presentation/game/characters/cat_character.dart';
import 'package:vibration/vibration.dart';

class MyGame extends FlameGame {
  // --- BLoC ---
  late final GameBloc gameBloc;

  // --- Game world & entities ---
  final BackgroundRoom background = BackgroundRoom();
  CatCharacter player = CatCharacter(initialAnimation: CatCharacterState.idle);

  // --- UI ---
  late final TextComponent coinCounter;

  @override
  Color backgroundColor() => const Color(0xff181425);

  @override
  Future<void> onLoad() async {
    // 1) Preload all images
    await images.loadAllImages();

    // 2) Create and add the FlameBlocProvider
    final flameBlocProvider = FlameBlocProvider<GameBloc, GameState>(
      create: () {
        gameBloc = GameBloc()..add(LoadGameEvent());
        return gameBloc;
      },
    );
    await add(flameBlocProvider);

    // 3) Add the game world under the provider
    flameBlocProvider.add(background);

    // 4) Set up the camera for our fixed-resolution world
    final cameraComponent = CameraComponent.withFixedResolution(
      width: 180,
      height: 320,
      world: background,
    )..viewfinder.anchor = Anchor.topLeft;
    flameBlocProvider.add(cameraComponent);

    // 5) Add the player character into the world
    player
      ..priority = 1
      ..anchor = Anchor.bottomCenter
      ..position = Vector2(100, 275)
      ..size = Vector2.all(64);
    await background.add(player);

    // Initialize and add the coin counter UI
    coinCounter = TextComponent(
      text: 'Coins: 0',
      position: Vector2(10, 25),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.white, fontSize: 32),
      ),
    );
    flameBlocProvider.add(coinCounter);

    // Add the shop button to the camera viewport
    cameraComponent.viewport.add(ShopButton());

    // Listen for coin updates and refresh the UI
    flameBlocProvider.add(
      FlameBlocListener<GameBloc, GameState>(
        listenWhen: (_, state) => state is GameSuccess,
        onNewState: (state) {
          final coins = (state as GameSuccess).gameStateModel.coins;
          coinCounter.text = 'Coins: $coins';
        },
      ),
    );

    // Listen for in-game effects (e.g. bonusHit, frenzy, etc.)
    flameBlocProvider.add(
      FlameBlocListener<GameBloc, GameState>(
        listenWhen: (prev, curr) {
          // only fire when effect changed and it's not "none"
          if (prev is! GameSuccess || curr is! GameSuccess) return false;
          final before = (prev).gameStateModel.inGameEffect;
          final after = (curr).gameStateModel.inGameEffect;
          return before != after && after != InGameEffect.none;
        },
        onNewState: (state) async {
          final effect = (state as GameSuccess).gameStateModel.inGameEffect;
          switch (effect) {
            case InGameEffect.bonusHit:
              if (await Vibration.hasVibrator()) {
                Vibration.vibrate();
              }

              // Show the excited animation
              player.current = CatCharacterState.excited;

              // After 5s, return to idle (only if still excited)
              Future.delayed(const Duration(seconds: 5), () {
                if (!player.isRemoved &&
                    player.current == CatCharacterState.excited &&
                    player.current != CatCharacterState.surprised) {
                  player.current = CatCharacterState.idle;
                }
              });
              break;
            case InGameEffect.catnipFrenzyUpgradeBought:
              // Show the excited animation
              player.current = CatCharacterState.surprised;

              // After 8s, return to idle (only if still surprised)
              Future.delayed(
                Duration(seconds: GameBalanceConstants.catnipFrenzyDuration),
                () {
                  if (!player.isRemoved &&
                      player.current == CatCharacterState.surprised) {
                    player.current = CatCharacterState.idle;
                  }
                },
              );
              break;
            default:
              break;
          }
          // reset effect so it won’t retrigger next frame
          gameBloc.add(ClearEffectEvent());
        },
      ),
    );
  }
}
