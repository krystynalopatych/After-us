import 'package:domain/save/model/game_save.dart';

abstract interface class SaveRepository {
  List<GameSave> get saves;

  void addSave(GameSave save);

  void load(GameSave save);

  GameSave? takeLoadedSave();
}
