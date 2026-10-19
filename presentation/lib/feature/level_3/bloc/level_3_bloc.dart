import 'package:domain/repositories/character_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'level_3_event.dart';
part 'level_3_state.dart';

class Level3Bloc extends Bloc<Level3Event, Level3State> {
  final CharacterRepository _characterRepository;

  Level3Bloc(this._characterRepository) : super(const Level3State()) {
    on<Level3Started>((event, emit) => _characterRepository.setMood(.normal));
  }
}
