import 'package:equatable/equatable.dart';

final class BookEntry extends Equatable {
  final String title;
  final String fact;

  const BookEntry({
    required this.title,
    required this.fact,
  });

  BookEntry copyWith({
    String? title,
    String? fact,
  }) => BookEntry(
    title: title ?? this.title,
    fact: fact ?? this.fact,
  );

  @override
  List<Object?> get props => [title, fact];
}
