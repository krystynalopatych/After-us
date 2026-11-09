part of 'book_bloc.dart';

final class BookState extends Equatable {
  final List<BookRecord> records;
  final int spread;

  const BookState({
    required this.records,
    this.spread = 0,
  });

  BookState copyWith({
    List<BookRecord>? records,
    int? spread,
  }) => BookState(
    records: records ?? this.records,
    spread: spread ?? this.spread,
  );

  @override
  List<Object?> get props => [records, spread];
}
