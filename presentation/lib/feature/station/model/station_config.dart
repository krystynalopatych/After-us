import 'package:domain/station/model/station.dart';
import 'package:flutter/painting.dart';

abstract final class StationConfig {
  static const spots = <Station, Rect>{
    Station.campfire: Rect.fromLTWH(
      430,
      380,
      240,
      220,
    ),
    Station.workbench: Rect.fromLTWH(
      900,
      700,
      280,
      256,
    ),
    Station.rocketStove: Rect.fromLTWH(
      560,
      720,
      170,
      170,
    ),
  };
}
