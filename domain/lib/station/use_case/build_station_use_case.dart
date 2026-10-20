import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/station/model/station.dart';
import 'package:domain/station/repository/station_repository.dart';

final class BuildStationUseCase {
  final MaterialRepository _materialRepository;
  final SelectionRepository _selectionRepository;
  final StationRepository _stationRepository;

  const BuildStationUseCase({
    required this._materialRepository,
    required this._selectionRepository,
    required this._stationRepository,
  });

  bool call(Station station) {
    if (_stationRepository.built.contains(station) || !station.isAffordableWith(_materialRepository.count)) {
      return false;
    }
    for (final MapEntry(key: material, value: count) in station.cost.entries) {
      _materialRepository.remove(
        material,
        count,
      );
    }
    _stationRepository.build(station);
    if (_selectionRepository.selection.material case final material? when _materialRepository.count(material) == 0) {
      _selectionRepository.reset();
    }
    return true;
  }
}
