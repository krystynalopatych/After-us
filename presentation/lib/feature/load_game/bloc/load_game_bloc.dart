import 'package:domain/save/model/game_save.dart';
import 'package:domain/save/repository/save_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'load_game_event.dart';
part 'load_game_state.dart';

class LoadGameBloc extends Bloc<LoadGameEvent, LoadGameState> {
  final SaveRepository _saveRepository;

  LoadGameBloc(this._saveRepository) : super(const LoadGameState()) {
    on<LoadGameStarted>((event, emit) => emit(LoadGameState(saves: _saveRepository.saves)));
  }
}
