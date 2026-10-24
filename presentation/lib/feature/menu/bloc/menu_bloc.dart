import 'package:domain/progress/model/game_level.dart';
import 'package:domain/save/use_case/save_game_use_case.dart';
import 'package:domain/sound/repository/sound_repository.dart';
import 'package:domain/sound/use_case/mute_sound_use_case.dart';
import 'package:domain/sound/use_case/stop_music_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MuteSoundUseCase _muteSoundUseCase;
  final SaveGameUseCase _saveGameUseCase;
  final SoundRepository _soundRepository;
  final StopMusicUseCase _stopMusicUseCase;

  MenuBloc()
    : _muteSoundUseCase = diContainer.get(),
      _saveGameUseCase = diContainer.get(),
      _soundRepository = diContainer.get(),
      _stopMusicUseCase = diContainer.get(),
      super(const MenuState()) {
    on<MenuStarted>(_onStarted);
    on<MenuToggled>(
      (event, emit) => emit(
        state.copyWith(
          isOpen: !state.isOpen,
          isSaved: false,
        ),
      ),
    );
    on<MenuClosed>(
      (event, emit) => emit(
        state.copyWith(
          isOpen: false,
          isSaved: false,
        ),
      ),
    );
    on<MenuSaveTapped>(_onSaveTapped);
    on<MenuSoundTapped>((event, emit) => _muteSoundUseCase(!state.isMuted));
    on<MenuExitTapped>((event, emit) => _stopMusicUseCase());
  }

  Future<void> _onStarted(
    MenuStarted event,
    Emitter<MenuState> emit,
  ) {
    emit(MenuState(isMuted: _soundRepository.isMuted));
    return emit.forEach(
      _soundRepository.isMutedStream,
      onData: (isMuted) => state.copyWith(isMuted: isMuted),
    );
  }

  void _onSaveTapped(
    MenuSaveTapped event,
    Emitter<MenuState> emit,
  ) {
    _saveGameUseCase(event.level);
    emit(
      state.copyWith(
        isOpen: true,
        isSaved: true,
      ),
    );
  }
}
