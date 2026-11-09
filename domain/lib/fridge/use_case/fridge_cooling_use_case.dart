import 'package:async/async.dart';
import 'package:domain/day/repository/day_repository.dart';
import 'package:domain/fridge/repository/fridge_repository.dart';

final class FridgeCoolingUseCase {
  final DayRepository _dayRepository;
  final FridgeRepository _fridgeRepository;

  const FridgeCoolingUseCase({
    required this._dayRepository,
    required this._fridgeRepository,
  });

  bool get isCooling => _fridgeRepository.fridge.isCoolingOn(_dayRepository.day);

  Stream<bool> get isCoolingStream => StreamGroup.mergeBroadcast<Object>([
    _dayRepository.dayStream,
    _fridgeRepository.fridgeStream,
  ]).map((_) => isCooling).distinct();
}
