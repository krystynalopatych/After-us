import 'package:domain/inventory/model/water_bottle.dart';
import 'package:domain/inventory/model/water_kind.dart';
import 'package:equatable/equatable.dart';

final class WaterRequest extends Equatable {
  final WaterKind water;
  final WaterBottle? bottle;

  const WaterRequest({
    required this.water,
    this.bottle,
  });

  WaterRequest copyWith({
    WaterKind? water,
    WaterBottle? Function()? bottle,
  }) => WaterRequest(
    water: water ?? this.water,
    bottle: bottle != null ? bottle() : this.bottle,
  );

  @override
  List<Object?> get props => [water, bottle];
}
