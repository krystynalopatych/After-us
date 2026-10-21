import 'package:domain/material/model/game_material.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/station/model/campfire_fuel.dart';
import 'package:domain/station/model/campfire_recipe.dart';
import 'package:domain/station/use_case/campfire_fuel_use_case.dart';
import 'package:domain/station/use_case/campfire_recipe_use_case.dart';
import 'package:domain/station/use_case/cook_on_campfire_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'campfire_event.dart';
part 'campfire_state.dart';

class CampfireBloc extends Bloc<CampfireEvent, CampfireState> {
  static const _cookingDuration = Duration(seconds: 1);

  final CampfireFuelUseCase _campfireFuelUseCase;
  final CampfireRecipeUseCase _campfireRecipeUseCase;
  final CookOnCampfireUseCase _cookOnCampfireUseCase;
  final SelectionRepository _selectionRepository;

  CampfireBloc()
    : _campfireFuelUseCase = diContainer.get(),
      _campfireRecipeUseCase = diContainer.get(),
      _cookOnCampfireUseCase = diContainer.get(),
      _selectionRepository = diContainer.get(),
      super(const CampfireState()) {
    on<CampfireStarted>(_onStarted);
    on<CampfireSlotTapped>(_onSlotTapped);
    on<CampfireMaterialSelected>(_onMaterialSelected);
  }

  Future<void> _onStarted(
    CampfireStarted event,
    Emitter<CampfireState> emit,
  ) {
    return emit.onEach(
      _selectionRepository.selectionStream,
      onData: (selection) {
        if (selection.material case final material?) {
          add(CampfireMaterialSelected(material));
        }
      },
    );
  }

  void _onSlotTapped(
    CampfireSlotTapped event,
    Emitter<CampfireState> emit,
  ) {
    if (state.step != .empty) {
      return;
    }
    final recipe = _campfireRecipeUseCase();
    if (recipe == null) {
      return;
    }
    emit(
      state.copyWith(
        recipe: () => recipe,
        step: .fuel,
      ),
    );
  }

  Future<void> _onMaterialSelected(
    CampfireMaterialSelected event,
    Emitter<CampfireState> emit,
  ) async {
    final recipe = state.recipe;
    if (state.step != .fuel || recipe == null) {
      return;
    }
    final fuel = _campfireFuelUseCase(
      recipe,
      event.material,
    );
    if (fuel == null) {
      return;
    }
    emit(
      state.copyWith(
        fuel: () => fuel,
        step: .cooking,
      ),
    );
    await Future<void>.delayed(_cookingDuration);
    if (emit.isDone) {
      return;
    }
    _cookOnCampfireUseCase(
      recipe,
      fuel,
    );
    emit(state.copyWith(step: .done));
  }
}
