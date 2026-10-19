import 'package:domain/entities/character_mood.dart';

abstract interface class CharacterRepository {
  CharacterMood get mood;

  Stream<CharacterMood> get moodStream;

  void setMood(CharacterMood mood);
}
