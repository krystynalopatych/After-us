import 'dart:async';

import 'package:domain/character/repository/character_repository.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/sound/use_case/play_message_sound_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  static const _defaultDisplayDuration = Duration(seconds: 3);

  final Duration _displayDuration;
  final CharacterRepository _characterRepository;
  final FeedbackRepository _feedbackRepository;
  final PlayMessageSoundUseCase _playMessageSoundUseCase;
  Timer? _timer;

  FeedbackBloc({this._displayDuration = _defaultDisplayDuration})
    : _characterRepository = diContainer.get(),
      _feedbackRepository = diContainer.get(),
      _playMessageSoundUseCase = diContainer.get(),
      super(const FeedbackState()) {
    on<FeedbackStarted>(_onStarted);
    on<FeedbackExpired>(_onExpired);
  }

  Future<void> _onStarted(
    FeedbackStarted event,
    Emitter<FeedbackState> emit,
  ) {
    return emit.forEach(
      _feedbackRepository.messageStream,
      onData: _onMessage,
    );
  }

  FeedbackState _onMessage(FeedbackMessage message) {
    if (state.message != null) {
      return state.copyWith(
        queue: [
          ...state.queue,
          message,
        ],
      );
    }
    _show(message);
    return state.copyWith(message: () => message);
  }

  void _onExpired(
    FeedbackExpired event,
    Emitter<FeedbackState> emit,
  ) {
    if (state.queue.isEmpty) {
      _characterRepository.setMood(.normal);
      emit(state.copyWith(message: () => null));
      return;
    }
    final next = state.queue.first;
    _show(next);
    emit(
      state.copyWith(
        message: () => next,
        queue: state.queue.skip(1).toList(),
      ),
    );
  }

  void _show(FeedbackMessage message) {
    _characterRepository.setMood(message.mood);
    _playMessageSoundUseCase(message);
    _timer?.cancel();
    _timer = Timer(
      _displayDuration,
      () => add(const FeedbackExpired()),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
