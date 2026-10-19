import 'package:domain/repositories/character_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'level_2_event.dart';
part 'level_2_state.dart';

class Level2Bloc extends Bloc<Level2Event, Level2State> {
  final CharacterRepository _characterRepository;

  Level2Bloc(this._characterRepository) : super(const Level2State()) {
    on<Level2Started>((event, emit) => _characterRepository.setMood(.sad));
  }
}
