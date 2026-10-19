import 'dart:async';

import 'package:domain/entities/character_mood.dart';
import 'package:domain/repositories/character_repository.dart';

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
