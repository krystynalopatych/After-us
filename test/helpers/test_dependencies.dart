import 'dart:async';

import 'package:after_us_game/di/use_case_injection.dart';
import 'package:data/book/repository/book_repository_impl.dart';
import 'package:data/character/repository/character_repository_impl.dart';
import 'package:data/compost/repository/compost_repository_impl.dart';
import 'package:data/construction/repository/construction_repository_impl.dart';
import 'package:data/day/repository/clock_repository_impl.dart';
import 'package:data/day/repository/day_repository_impl.dart';
import 'package:data/dialogue/repository/dialogue_repository_impl.dart';
import 'package:data/dialogue/repository/hero_reaction_repository_impl.dart';
import 'package:data/feedback/repository/feedback_repository_impl.dart';
import 'package:data/inventory/repository/inventory_repository_impl.dart';
import 'package:data/location/repository/location_repository_impl.dart';
import 'package:data/material/repository/material_repository_impl.dart';
import 'package:data/pickup/repository/pickup_repository_impl.dart';
import 'package:data/pickup/repository/pickup_hint_repository_impl.dart';
import 'package:data/player/repository/meal_repository_impl.dart';
import 'package:data/player/repository/player_repository_impl.dart';
import 'package:data/pollution/repository/pollution_repository_impl.dart';
import 'package:data/progress/repository/progress_repository_impl.dart';
import 'package:data/save/repository/save_repository_impl.dart';
import 'package:data/selection/repository/selection_repository_impl.dart';
import 'package:data/station/repository/campfire_repository_impl.dart';
import 'package:data/station/repository/station_repository_impl.dart';
import 'package:data/sun_spot/repository/sun_spot_repository_impl.dart';
import 'package:domain/app/repository/app_repository.dart';
import 'package:domain/book/repository/book_repository.dart';
import 'package:domain/character/repository/character_repository.dart';
import 'package:domain/compost/repository/compost_repository.dart';
import 'package:domain/construction/repository/construction_repository.dart';
import 'package:domain/day/repository/clock_repository.dart';
import 'package:domain/day/repository/day_repository.dart';
import 'package:domain/day/repository/ticker_repository.dart';
import 'package:domain/dialogue/repository/dialogue_repository.dart';
import 'package:domain/dialogue/repository/hero_reaction_repository.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/pickup/repository/pickup_hint_repository.dart';
import 'package:domain/pickup/repository/pickup_repository.dart';
import 'package:domain/player/repository/meal_repository.dart';
import 'package:domain/player/repository/player_repository.dart';
import 'package:domain/pollution/repository/pollution_repository.dart';
import 'package:domain/progress/repository/progress_repository.dart';
import 'package:domain/save/repository/save_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/sound/model/game_sound.dart';
import 'package:domain/sound/repository/sound_repository.dart';
import 'package:domain/station/repository/campfire_repository.dart';
import 'package:domain/station/repository/station_repository.dart';
import 'package:domain/sun_spot/repository/sun_spot_repository.dart';
import 'package:presentation/di/di_container.dart';

final class FakeAppRepository implements AppRepository {
  int exitCount = 0;

  @override
  void exit() => exitCount++;
}

final class FakeSoundRepository implements SoundRepository {
  final played = <GameSound>[];
  final looping = <GameSound>{};
  final _isMutedController = StreamController<bool>.broadcast();
  var _isMuted = false;

  @override
  bool get isMuted => _isMuted;

  @override
  Stream<bool> get isMutedStream => _isMutedController.stream;

  @override
  void play(GameSound sound) => played.add(sound);

  @override
  void loop(GameSound sound) => looping.add(sound);

  @override
  void stop(GameSound sound) => looping.remove(sound);

  @override
  void setMuted(bool isMuted) {
    _isMuted = isMuted;
    _isMutedController.add(isMuted);
  }
}

final class ManualTickerRepository implements TickerRepository {
  final _controller = StreamController<void>.broadcast();

  @override
  Stream<void> get seconds => _controller.stream;

  void tick([int count = 1]) {
    for (var i = 0; i < count; i++) {
      _controller.add(null);
    }
  }
}

final class TestDependencies {
  final app = FakeAppRepository();
  final book = BookRepositoryImpl();
  final campfire = CampfireRepositoryImpl();
  final character = CharacterRepositoryImpl();
  final clock = ClockRepositoryImpl();
  final compost = CompostRepositoryImpl();
  final construction = ConstructionRepositoryImpl();
  final day = DayRepositoryImpl();
  final dialogue = DialogueRepositoryImpl();
  final feedback = FeedbackRepositoryImpl();
  final heroReaction = HeroReactionRepositoryImpl();
  final inventory = InventoryRepositoryImpl();
  final location = LocationRepositoryImpl();
  final material = MaterialRepositoryImpl();
  final meal = MealRepositoryImpl();
  final pickup = PickupRepositoryImpl();
  final pickupHint = PickupHintRepositoryImpl();
  final player = PlayerRepositoryImpl();
  final pollution = PollutionRepositoryImpl();
  final progress = ProgressRepositoryImpl();
  final save = SaveRepositoryImpl();
  final selection = SelectionRepositoryImpl();
  final sound = FakeSoundRepository();
  final station = StationRepositoryImpl();
  final sunSpot = SunSpotRepositoryImpl();
  final ticker = ManualTickerRepository();

  Future<void> register() async {
    await diContainer.reset();
    diContainer
      ..registerSingleton<AppRepository>(app)
      ..registerSingleton<BookRepository>(book)
      ..registerSingleton<CampfireRepository>(campfire)
      ..registerSingleton<CharacterRepository>(character)
      ..registerSingleton<ClockRepository>(clock)
      ..registerSingleton<CompostRepository>(compost)
      ..registerSingleton<ConstructionRepository>(construction)
      ..registerSingleton<DayRepository>(day)
      ..registerSingleton<DialogueRepository>(dialogue)
      ..registerSingleton<FeedbackRepository>(feedback)
      ..registerSingleton<HeroReactionRepository>(heroReaction)
      ..registerSingleton<InventoryRepository>(inventory)
      ..registerSingleton<LocationRepository>(location)
      ..registerSingleton<MaterialRepository>(material)
      ..registerSingleton<MealRepository>(meal)
      ..registerSingleton<PickupHintRepository>(pickupHint)
      ..registerSingleton<PickupRepository>(pickup)
      ..registerSingleton<PlayerRepository>(player)
      ..registerSingleton<PollutionRepository>(pollution)
      ..registerSingleton<ProgressRepository>(progress)
      ..registerSingleton<SaveRepository>(save)
      ..registerSingleton<SelectionRepository>(selection)
      ..registerSingleton<SoundRepository>(sound)
      ..registerSingleton<StationRepository>(station)
      ..registerSingleton<SunSpotRepository>(sunSpot)
      ..registerSingleton<TickerRepository>(ticker);
    registerUseCases();
  }
}
