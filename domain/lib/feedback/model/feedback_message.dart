import 'package:domain/character/model/character_mood.dart';

final class FeedbackMessage {
  final String text;
  final String? heroLine;
  final CharacterMood mood;

  const FeedbackMessage({
    required this.text,
    this.heroLine,
    this.mood = .normal,
  });
}
