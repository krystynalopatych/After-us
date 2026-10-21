part of 'book_bloc.dart';

sealed class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object?> get props => [];
}

final class BookStarted extends BookEvent {
  const BookStarted();
}
