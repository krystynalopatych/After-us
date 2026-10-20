import 'package:domain/location/repository/location_repository.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/save/model/game_save.dart';
import 'package:domain/save/repository/save_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final LocationRepository _locationRepository;
  final SaveRepository _saveRepository;

  MenuBloc()
    : _locationRepository = diContainer.get(),
      _saveRepository = diContainer.get(),
      super(const MenuState()) {
    on<MenuStarted>((event, emit) => emit(const MenuState()));
    on<MenuToggled>((event, emit) => emit(MenuState(isOpen: !state.isOpen)));
    on<MenuClosed>((event, emit) => emit(const MenuState()));
    on<MenuSaveTapped>(_onSaveTapped);
  }

  void _onSaveTapped(MenuSaveTapped event, Emitter<MenuState> emit) {
    _saveRepository.addSave(
      GameSave(
        level: event.level,
        location: _locationRepository.location,
        savedAt: DateTime.now(),
      ),
    );
    emit(const MenuState(isOpen: true, isSaved: true));
  }
}
