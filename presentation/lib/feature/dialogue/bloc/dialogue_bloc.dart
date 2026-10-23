import 'dart:async';

import 'package:domain/dialogue/repository/dialogue_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'dialogue_event.dart';
part 'dialogue_state.dart';

class DialogueBloc extends Bloc<DialogueEvent, DialogueState> {
  static const _defaultReadDuration = Duration(seconds: 3);

  final Duration _readDuration;
  final DialogueRepository _dialogueRepository;
  Timer? _timer;

  DialogueBloc({this._readDuration = _defaultReadDuration})
    : _dialogueRepository = diContainer.get(),
      super(const DialogueState()) {
    on<DialogueStarted>(_onStarted);
    on<DialogueLineTyped>(_onLineTyped);
    on<DialogueExpired>(_onExpired);
  }

  Future<void> _onStarted(
    DialogueStarted event,
    Emitter<DialogueState> emit,
  ) {
    return emit.forEach(
      _dialogueRepository.lineStream,
      onData: _onLine,
    );
  }

  DialogueState _onLine(String line) {
    if (state.line != null) {
      return state.copyWith(
        queue: [
          ...state.queue,
          line,
        ],
      );
    }
    return state.copyWith(line: () => line);
  }

  void _onLineTyped(
    DialogueLineTyped event,
    Emitter<DialogueState> emit,
  ) {
    _timer?.cancel();
    _timer = Timer(
      _readDuration,
      () => add(const DialogueExpired()),
    );
  }

  void _onExpired(
    DialogueExpired event,
    Emitter<DialogueState> emit,
  ) {
    if (state.queue.isEmpty) {
      emit(state.copyWith(line: () => null));
      return;
    }
    emit(
      state.copyWith(
        line: () => state.queue.first,
        queue: state.queue.skip(1).toList(),
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
