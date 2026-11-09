import 'package:domain/dialogue/use_case/read_note_use_case.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final LocationRepository _locationRepository;
  final ReadNoteUseCase _readNoteUseCase;

  NoteBloc()
    : _locationRepository = diContainer.get(),
      _readNoteUseCase = diContainer.get(),
      super(NoteState(location: diContainer.get<LocationRepository>().location)) {
    on<NoteStarted>(_onStarted);
    on<NoteTapped>((event, emit) => emit(state.copyWith(isOpen: true)));
    on<NoteClosed>(_onClosed);
  }

  Future<void> _onStarted(
    NoteStarted event,
    Emitter<NoteState> emit,
  ) {
    emit(state.copyWith(location: _locationRepository.location));
    return emit.forEach(
      _locationRepository.locationStream,
      onData: (location) => state.copyWith(location: location),
    );
  }

  void _onClosed(
    NoteClosed event,
    Emitter<NoteState> emit,
  ) {
    emit(state.copyWith(isOpen: false));
    _readNoteUseCase();
  }
}
