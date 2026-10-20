import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/station/model/station.dart';
import 'package:domain/station/model/station_choice.dart';
import 'package:domain/station/repository/station_repository.dart';

final class StationChoicesUseCase {
  final MaterialRepository _materialRepository;
  final SelectionRepository _selectionRepository;
  final StationRepository _stationRepository;

  const StationChoicesUseCase({
    required this._materialRepository,
    required this._selectionRepository,
    required this._stationRepository,
  });

  List<StationChoice> call() {
    final material = _selectionRepository.selection.material;
    if (material == null) {
      return const [];
    }
    return [
      for (final station in Station.values)
        if (station.isBuiltFrom(material))
          StationChoice(
            station: station,
            isBuilt: _stationRepository.built.contains(station),
            isAffordable: station.isAffordableWith(_materialRepository.count),
          ),
    ];
  }
}
