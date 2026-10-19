import 'package:domain/repositories/character_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'start_event.dart';
part 'start_state.dart';

class StartBloc extends Bloc<StartEvent, StartState> {
  final CharacterRepository _characterRepository;

  StartBloc(this._characterRepository) : super(const StartState()) {
    on<StartStarted>((event, emit) => _characterRepository.setMood(.normal));
  }
}
