import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/material/model/material_stock.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/player/repository/player_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'hud_event.dart';
part 'hud_state.dart';

class HudBloc extends Bloc<HudEvent, HudState> {
  final PlayerRepository _playerRepository;
  final MaterialRepository _materialRepository;
  final InventoryRepository _inventoryRepository;

  HudBloc()
    : _playerRepository = diContainer.get(),
      _materialRepository = diContainer.get(),
      _inventoryRepository = diContainer.get(),
      super(
        HudState(
          stats: diContainer.get<PlayerRepository>().stats,
          stocks: diContainer.get<MaterialRepository>().stocks,
          inventory: diContainer.get<InventoryRepository>().stacks,
        ),
      ) {
    on<HudStarted>(_onStarted);
  }

  Future<void> _onStarted(HudStarted event, Emitter<HudState> emit) {
    emit(
      HudState(
        stats: _playerRepository.stats,
        stocks: _materialRepository.stocks,
        inventory: _inventoryRepository.stacks,
      ),
    );
    return Future.wait([
      emit.forEach(
        _playerRepository.statsStream,
        onData: (stats) => HudState(stats: stats, stocks: state.stocks, inventory: state.inventory),
      ),
      emit.forEach(
        _materialRepository.stocksStream,
        onData: (stocks) => HudState(stats: state.stats, stocks: stocks, inventory: state.inventory),
      ),
      emit.forEach(
        _inventoryRepository.stacksStream,
        onData: (inventory) => HudState(stats: state.stats, stocks: state.stocks, inventory: inventory),
      ),
    ]);
  }
}
