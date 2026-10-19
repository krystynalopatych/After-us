import 'dart:async';

import 'package:domain/character/model/character_mood.dart';
import 'package:domain/character/repository/character_repository.dart';

final class CharacterRepositoryImpl implements CharacterRepository {
  final _moodController = StreamController<CharacterMood>.broadcast();
  CharacterMood _mood = .normal;

  @override
  CharacterMood get mood => _mood;

  @override
  Stream<CharacterMood> get moodStream => _moodController.stream;

  @override
  void setMood(CharacterMood mood) {
    _mood = mood;
    _moodController.add(mood);
  }
}
