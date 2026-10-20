import 'package:domain/progress/model/game_level.dart';
import 'package:domain/save/use_case/save_game_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final SaveGameUseCase _saveGameUseCase;

  MenuBloc() : _saveGameUseCase = diContainer.get(), super(const MenuState()) {
    on<MenuStarted>((event, emit) => emit(const MenuState()));
    on<MenuToggled>((event, emit) => emit(MenuState(isOpen: !state.isOpen)));
    on<MenuClosed>((event, emit) => emit(const MenuState()));
    on<MenuSaveTapped>(_onSaveTapped);
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
