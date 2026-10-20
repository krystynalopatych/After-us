import 'package:domain/construction/model/construction.dart';
import 'package:domain/construction/repository/construction_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'goal_event.dart';
part 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final ConstructionRepository _constructionRepository;

  GoalBloc()
    : _constructionRepository = diContainer.get(),
      super(GoalState(built: diContainer.get<ConstructionRepository>().built)) {
    on<GoalStarted>(_onStarted);
  }

  Future<void> _onStarted(
    GoalStarted event,
    Emitter<GoalState> emit,
  ) {
    emit(state.copyWith(built: _constructionRepository.built));
    return emit.forEach(
      _constructionRepository.builtStream,
      onData: (built) => state.copyWith(built: built),
    );
  }
}
