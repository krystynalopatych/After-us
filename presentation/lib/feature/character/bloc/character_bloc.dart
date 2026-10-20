import 'package:domain/character/model/character_mood.dart';
import 'package:domain/character/repository/character_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/src/widget/character/model/character_state.dart';
import 'package:presentation/di/di_container.dart';

part 'character_event.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository _characterRepository;

  CharacterBloc()
    : _characterRepository = diContainer.get(),
      super(_toState(diContainer.get<CharacterRepository>().mood)) {
    on<CharacterStarted>(_onStarted);
  }

  Future<void> _onStarted(CharacterStarted event, Emitter<CharacterState> emit) {
    return emit.forEach(
      _characterRepository.moodStream,
      onData: _toState,
    );
  }

  static CharacterState _toState(CharacterMood mood) => switch (mood) {
    .normal => .normal,
    .happy => .happy,
    .sad => .sad,
  };
}
