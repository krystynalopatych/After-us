import 'package:domain/character/model/character_mood.dart';
import 'package:equatable/equatable.dart';

final class FeedbackMessage extends Equatable {
  final String text;
  final String? heroLine;
  final CharacterMood mood;

  const FeedbackMessage({
    required this.text,
    this.heroLine,
    this.mood = .normal,
  });

  FeedbackMessage copyWith({
    String? text,
    String? Function()? heroLine,
    CharacterMood? mood,
  }) => FeedbackMessage(
    text: text ?? this.text,
    heroLine: heroLine != null ? heroLine() : this.heroLine,
    mood: mood ?? this.mood,
  );

  @override
  List<Object?> get props => [text, heroLine, mood];
}
