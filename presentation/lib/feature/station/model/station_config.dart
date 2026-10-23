import 'package:domain/station/model/station.dart';
import 'package:flutter/painting.dart';

abstract final class StationConfig {
  static const spots = <Station, Rect>{
    Station.campfire: Rect.fromLTWH(
      500,
      480,
      240,
      220,
    ),
    Station.workbench: Rect.fromLTWH(
      980,
      780,
      280,
      256,
    ),
    Station.rocketStove: Rect.fromLTWH(
      760,
      780,
      170,
      170,
    ),
  };
}
