part of 'book_bloc.dart';

final class BookState extends Equatable {
  final List<BookRecord> records;

  const BookState({required this.records});

  BookState copyWith({List<BookRecord>? records}) => BookState(records: records ?? this.records);

  @override
  List<Object?> get props => [records];
}
