import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/station/model/station.dart';
import 'package:domain/station/repository/station_repository.dart';

final class PlaceStationUseCase {
  final FeedbackRepository _feedbackRepository;
  final InventoryRepository _inventoryRepository;
  final SelectionRepository _selectionRepository;
  final StationRepository _stationRepository;

  const PlaceStationUseCase({
    required this._feedbackRepository,
    required this._inventoryRepository,
    required this._selectionRepository,
    required this._stationRepository,
  });

  bool call() {
    final item = switch (_selectionRepository.selection.slot) {
      final slot? => _inventoryRepository.stacks.elementAtOrNull(slot)?.item,
      null => null,
    };
    final station = switch (item) {
      .rocketStove => Station.rocketStove,
      .clayFridge => Station.clayFridge,
      _ => null,
    };
    if (item == null ||
        station == null ||
        _stationRepository.built.contains(station) ||
        !_inventoryRepository.remove(item)) {
      return false;
    }
    _stationRepository.build(station);
    _selectionRepository.reset();
    _feedbackRepository.show(
      FeedbackMessage(
        text: switch (station) {
          .clayFridge => 'You set up the clay fridge Water it with lake water every day',
          .campfire || .workbench || .rocketStove => 'You set up the rocket stove',
        },
        mood: .happy,
      ),
    );
    return true;
  }
}
