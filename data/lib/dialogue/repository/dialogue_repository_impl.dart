import 'dart:async';

import 'package:domain/dialogue/repository/dialogue_repository.dart';

final class DialogueRepositoryImpl implements DialogueRepository {
  final _lineController = StreamController<String>.broadcast();

  @override
  Stream<String> get lineStream => _lineController.stream;

  @override
  void say(String line) => _lineController.add(line);
}
