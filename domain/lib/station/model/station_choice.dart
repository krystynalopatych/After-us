import 'package:domain/station/model/station.dart';
import 'package:equatable/equatable.dart';

final class StationChoice extends Equatable {
  final Station station;
  final bool isBuilt;
  final bool isAffordable;

  const StationChoice({
    required this.station,
    required this.isBuilt,
    required this.isAffordable,
  });

  bool get canBuild => !isBuilt && isAffordable;

  StationChoice copyWith({
    Station? station,
    bool? isBuilt,
    bool? isAffordable,
  }) => StationChoice(
    station: station ?? this.station,
    isBuilt: isBuilt ?? this.isBuilt,
    isAffordable: isAffordable ?? this.isAffordable,
  );

  @override
  List<Object?> get props => [station, isBuilt, isAffordable];
}
