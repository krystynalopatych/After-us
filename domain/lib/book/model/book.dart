import 'package:domain/book/model/book_record.dart';
import 'package:equatable/equatable.dart';

final class Book extends Equatable {
  final List<BookRecord> records;
  final bool hasNewRecord;

  const Book({
    required this.records,
    required this.hasNewRecord,
  });

  const Book.empty() : records = const [], hasNewRecord = false;

  Book copyWith({
    List<BookRecord>? records,
    bool? hasNewRecord,
  }) => Book(
    records: records ?? this.records,
    hasNewRecord: hasNewRecord ?? this.hasNewRecord,
  );

  @override
  List<Object?> get props => [records, hasNewRecord];
}
