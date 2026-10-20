import 'package:domain/save/model/game_save.dart';
import 'package:domain/save/repository/save_repository.dart';

final class SaveRepositoryImpl implements SaveRepository {
  final _saves = <GameSave>[];
  GameSave? _loadedSave;

  @override
  List<GameSave> get saves => List.unmodifiable(_saves);

  @override
  void addSave(GameSave save) => _saves.add(save);

  @override
  void load(GameSave save) => _loadedSave = save;

  @override
  GameSave? takeLoadedSave() {
    final save = _loadedSave;
    _loadedSave = null;
    return save;
  }
}
