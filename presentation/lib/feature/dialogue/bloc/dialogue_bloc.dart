import 'dart:async';

import 'package:domain/dialogue/repository/dialogue_repository.dart';
import 'package:domain/dialogue/use_case/hero_awake_use_case.dart';
import 'package:domain/sound/use_case/hero_voice_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'dialogue_event.dart';
part 'dialogue_state.dart';

class DialogueBloc extends Bloc<DialogueEvent, DialogueState> {
  static const _defaultReadDuration = Duration(seconds: 3);
  static const _defaultWakeDuration = Duration(milliseconds: 500);

  final Duration _readDuration;
  final Duration _wakeDuration;
  final DialogueRepository _dialogueRepository;
  final HeroAwakeUseCase _heroAwakeUseCase;
  final HeroVoiceUseCase _heroVoiceUseCase;
  Timer? _timer;
  Timer? _wakeTimer;

  DialogueBloc({
    this._readDuration = _defaultReadDuration,
    this._wakeDuration = _defaultWakeDuration,
  }) : _dialogueRepository = diContainer.get(),
       _heroAwakeUseCase = diContainer.get(),
       _heroVoiceUseCase = diContainer.get(),
       super(const DialogueState()) {
    on<DialogueStarted>(_onStarted);
    on<DialogueLineTyped>(_onLineTyped);
    on<DialogueExpired>(_onExpired);
    on<DialogueWoke>(_onWoke);
  }

  Future<void> _onStarted(
    DialogueStarted event,
    Emitter<DialogueState> emit,
  ) {
    emit(state.copyWith(isAwake: _heroAwakeUseCase.isAwake));
    return Future.wait([
      emit.forEach(
        _dialogueRepository.lineStream,
        onData: _onLine,
      ),
      emit.forEach(
        _heroAwakeUseCase.isAwakeStream,
        onData: _onAwakeChanged,
      ),
    ]);
  }

  DialogueState _onLine(String line) {
    if (state.line != null || !state.isAwake) {
      return state.copyWith(
        queue: [
          ...state.queue,
          line,
        ],
      );
    }
    _heroVoiceUseCase(true);
    return state.copyWith(line: () => line);
  }

  DialogueState _onAwakeChanged(bool isAwake) {
    _wakeTimer?.cancel();
    if (isAwake) {
      _wakeTimer = Timer(
        _wakeDuration,
        () => add(const DialogueWoke()),
      );
      return state;
    }
    return state.copyWith(isAwake: false);
  }

  void _onLineTyped(
    DialogueLineTyped event,
    Emitter<DialogueState> emit,
  ) {
    _heroVoiceUseCase(false);
    _timer?.cancel();
    _timer = Timer(
      _readDuration,
      () => add(const DialogueExpired()),
    );
  }

  void _onExpired(
    DialogueExpired event,
    Emitter<DialogueState> emit,
  ) => emit(_next(state.copyWith(line: () => null)));

  void _onWoke(
    DialogueWoke event,
    Emitter<DialogueState> emit,
  ) {
    final awake = state.copyWith(isAwake: true);
    emit(awake.line == null ? _next(awake) : awake);
  }

  DialogueState _next(DialogueState state) {
    if (state.queue.isEmpty || !state.isAwake) {
      return state;
    }
    _heroVoiceUseCase(true);
    return state.copyWith(
      line: () => state.queue.first,
      queue: state.queue.skip(1).toList(),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _wakeTimer?.cancel();
    _heroVoiceUseCase(false);
    return super.close();
  }
}
