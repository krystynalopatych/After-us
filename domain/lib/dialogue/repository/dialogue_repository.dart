abstract interface class DialogueRepository {
  Stream<String> get lineStream;

  void say(String line);
}
