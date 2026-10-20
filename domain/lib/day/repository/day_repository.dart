abstract interface class DayRepository {
  int get day;

  Stream<int> get dayStream;

  void nextDay();

  void restore(int day);

  void reset();
}
