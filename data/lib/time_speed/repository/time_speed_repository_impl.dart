import 'dart:async';

import 'package:domain/time_speed/repository/time_speed_repository.dart';

final class TimeSpeedRepositoryImpl implements TimeSpeedRepository {
  final _isFastController = StreamController<bool>.broadcast();
  var _isFast = false;

  @override
  bool get isFast => _isFast;

  @override
  Stream<bool> get isFastStream => _isFastController.stream;

  @override
  void setFast(bool isFast) {
    _isFast = isFast;
    _isFastController.add(isFast);
  }
}
