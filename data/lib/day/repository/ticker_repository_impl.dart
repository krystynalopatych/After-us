import 'package:domain/day/repository/ticker_repository.dart';

final class TickerRepositoryImpl implements TickerRepository {
  static const _interval = Duration(seconds: 1);

  @override
  Stream<void> get seconds => Stream<void>.periodic(_interval);
}
