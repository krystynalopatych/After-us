import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/material/model/material_stock.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/player/repository/player_repository.dart';
import 'package:domain/player/use_case/consume_use_case.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'hud_event.dart';
part 'hud_state.dart';

class HudBloc extends Bloc<HudEvent, HudState> {
  final PlayerRepository _playerRepository;
  final MaterialRepository _materialRepository;
  final InventoryRepository _inventoryRepository;
  final ConsumeUseCase _consumeUseCase;
  final SelectionRepository _selectionRepository;

  HudBloc()
    : _playerRepository = diContainer.get(),
      _materialRepository = diContainer.get(),
      _inventoryRepository = diContainer.get(),
      _consumeUseCase = diContainer.get(),
      _selectionRepository = diContainer.get(),
      super(
        HudState(
          stats: diContainer.get<PlayerRepository>().stats,
          stocks: diContainer.get<MaterialRepository>().stocks,
          inventory: diContainer.get<InventoryRepository>().stacks,
          selectedMaterial: diContainer.get<SelectionRepository>().selection.material,
          selectedSlot: diContainer.get<SelectionRepository>().selection.slot,
        ),
      ) {
    on<HudStarted>(_onStarted);
    on<HudMaterialTapped>(_onMaterialTapped);
    on<HudSlotTapped>(_onSlotTapped);
  }

  Future<void> _onStarted(
    HudStarted event,
    Emitter<HudState> emit,
  ) {
    emit(
      state.copyWith(
        stats: _playerRepository.stats,
        stocks: _materialRepository.stocks,
        inventory: _inventoryRepository.stacks,
        selectedMaterial: () => _selectionRepository.selection.material,
        selectedSlot: () => _selectionRepository.selection.slot,
      ),
    );
    return Future.wait([
      emit.forEach(
        _playerRepository.statsStream,
        onData: (stats) => state.copyWith(stats: stats),
      ),
      emit.forEach(
        _materialRepository.stocksStream,
        onData: (stocks) => state.copyWith(stocks: stocks),
      ),
      emit.forEach(
        _inventoryRepository.stacksStream,
        onData: (inventory) => state.copyWith(inventory: inventory),
      ),
      emit.forEach(
        _selectionRepository.selectionStream,
        onData: (selection) => state.copyWith(
          selectedMaterial: () => selection.material,
          selectedSlot: () => selection.slot,
        ),
      ),
    ]);
  }

  void _onMaterialTapped(
    HudMaterialTapped event,
    Emitter<HudState> emit,
  ) => _selectionRepository.selectMaterial(state.selectedMaterial == event.material ? null : event.material);

  void _onSlotTapped(
    HudSlotTapped event,
    Emitter<HudState> emit,
  ) {
    final item = state.inventory.elementAtOrNull(event.slot)?.item;
    if (state.selectedSlot == event.slot && item != null && item.isConsumable) {
      _consumeUseCase(item);
    }
    _selectionRepository.selectSlot(state.selectedSlot == event.slot ? null : event.slot);
  }
}
