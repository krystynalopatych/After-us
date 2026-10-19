import 'package:domain/repositories/character_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'level_1_event.dart';
part 'level_1_state.dart';

class Level1Bloc extends Bloc<Level1Event, Level1State> {
  final CharacterRepository _characterRepository;

  Level1Bloc(this._characterRepository) : super(const Level1State()) {
    on<Level1Started>((event, emit) => _characterRepository.setMood(.happy));
  }
}
