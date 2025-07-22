import 'package:equatable/equatable.dart';

enum UpgradeType { luckyBonus, extraLove, catnipFrenzy, house }

/// A purchasable or activatable upgrade.
class UpgradeModel extends Equatable {
  final UpgradeType type; // Which upgrade this is
  final int level; // For stacking/passives (e.g. luckyBonus levels)
  final int cost; // Coins required
  final Map<String, num> params; // Tunables, e.g. {'bonusProbability': 0.02}

  const UpgradeModel({
    required this.type,
    required this.level,
    required this.cost,
    required this.params,
  });

  UpgradeModel copyWith({int? level, int? cost, Map<String, num>? params}) {
    return UpgradeModel(
      type: type,
      level: level ?? this.level,
      cost: cost ?? this.cost,
      params: params ?? this.params,
    );
  }

  @override
  List<Object?> get props => [type, level, cost, params];
}
