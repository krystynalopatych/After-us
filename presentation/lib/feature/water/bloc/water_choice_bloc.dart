import 'package:domain/inventory/model/water_bottle.dart';
import 'package:domain/inventory/model/water_kind.dart';
import 'package:domain/inventory/use_case/fill_bottle_use_case.dart';
import 'package:domain/inventory/use_case/water_bottles_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'water_choice_event.dart';
part 'water_choice_state.dart';

class WaterChoiceBloc extends Bloc<WaterChoiceEvent, WaterChoiceState> {
  final FillBottleUseCase _fillBottleUseCase;
  final WaterBottlesUseCase _waterBottlesUseCase;

  WaterChoiceBloc()
    : _fillBottleUseCase = diContainer.get(),
      _waterBottlesUseCase = diContainer.get(),
      super(const WaterChoiceState()) {
    on<WaterChoiceStarted>(
      (event, emit) => emit(
        state.copyWith(
          water: event.water,
          bottles: _waterBottlesUseCase(),
        ),
      ),
    );
    on<WaterChoiceBottleTapped>(_onBottleTapped);
  }

  void _onBottleTapped(
    WaterChoiceBottleTapped event,
    Emitter<WaterChoiceState> emit,
  ) {
    _fillBottleUseCase(
      event.bottle,
      state.water,
    );
    emit(state.copyWith(isDone: true));
  }
}
