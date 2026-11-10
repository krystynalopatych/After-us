abstract interface class TimeSpeedRepository {
  bool get isFast;

  Stream<bool> get isFastStream;

  void setFast(bool isFast);
}
