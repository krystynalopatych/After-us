import 'package:domain/book/model/book_record.dart';
import 'package:domain/book/repository/book_repository.dart';
import 'package:domain/book/use_case/read_book_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository _bookRepository;
  final ReadBookUseCase _readBookUseCase;

  BookBloc()
    : _bookRepository = diContainer.get(),
      _readBookUseCase = diContainer.get(),
      super(BookState(records: diContainer.get<BookRepository>().book.records)) {
    on<BookStarted>((event, emit) {
      _readBookUseCase();
      emit(state.copyWith(records: _bookRepository.book.records));
    });
  }
}
