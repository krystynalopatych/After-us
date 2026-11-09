part of 'book_bloc.dart';

sealed class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object?> get props => [];
}

final class BookStarted extends BookEvent {
  const BookStarted();
}

final class BookPreviousTapped extends BookEvent {
  const BookPreviousTapped();
}

final class BookNextTapped extends BookEvent {
  final int spreadCount;

  const BookNextTapped(this.spreadCount);

  @override
  List<Object?> get props => [spreadCount];
}
