abstract interface class TickerRepository {
  Stream<void> get seconds;
}
