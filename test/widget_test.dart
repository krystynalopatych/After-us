import 'package:after_us_game/di/use_case_injection.dart';
import 'package:data/character/repository/character_repository_impl.dart';
import 'package:data/construction/repository/construction_repository_impl.dart';
import 'package:data/day/repository/day_repository_impl.dart';
import 'package:data/feedback/repository/feedback_repository_impl.dart';
import 'package:data/inventory/repository/inventory_repository_impl.dart';
import 'package:data/location/repository/location_repository_impl.dart';
import 'package:data/material/repository/material_repository_impl.dart';
import 'package:data/pickup/repository/pickup_repository_impl.dart';
import 'package:data/player/repository/player_repository_impl.dart';
import 'package:data/pollution/repository/pollution_repository_impl.dart';
import 'package:data/progress/repository/progress_repository_impl.dart';
import 'package:data/save/repository/save_repository_impl.dart';
import 'package:domain/app/repository/app_repository.dart';
import 'package:domain/character/repository/character_repository.dart';
import 'package:domain/construction/repository/construction_repository.dart';
import 'package:domain/day/repository/day_repository.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/material/model/material_stock.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/pickup/repository/pickup_repository.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/player/repository/player_repository.dart';
import 'package:domain/pollution/model/pollution.dart';
import 'package:domain/pollution/repository/pollution_repository.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/repository/progress_repository.dart';
import 'package:domain/save/model/game_save.dart';
import 'package:domain/save/repository/save_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/di/di_container.dart';
import 'package:presentation/feature/app/bloc/app_bloc.dart';
import 'package:presentation/feature/app/page/app_page.dart';
import 'package:presentation/feature/level_1/page/level_1_page.dart';
import 'package:presentation/feature/level_2/page/level_2_page.dart';
import 'package:presentation/feature/load_game/page/load_game_page.dart';
import 'package:presentation/feature/start/page/start_page.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class _FakeAppRepository implements AppRepository {
  int exitCount = 0;

  @override
  void exit() => exitCount++;
}

void main() {
  Finder buttonImage(AssetGenImage image) => find.byWidgetPredicate(
    (widget) => widget is Image && (widget.image as AssetImage).assetName == image.path,
  );

  Future<void> pumpScene(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));
  }

  Finder fadeOf(AssetGenImage image) => find.ancestor(
    of: buttonImage(image).first,
    matching: find.byType(AnimatedOpacity),
  );

  double opacityOf(WidgetTester tester, AssetGenImage image) =>
      tester.widget<AnimatedOpacity>(fadeOf(image).first).opacity;

  Future<void> startLevel1(WidgetTester tester) async {
    await tester.tap(buttonImage(Assets.resources.assets.images.imgButtonNewGame).last);
    await tester.pumpAndSettle();
    await tester.tap(buttonImage(Assets.resources.assets.images.imgButtonLevel1).last);
    await pumpScene(tester);
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.tap(find.text(text));
    await pumpScene(tester);
  }

  Future<void> pumpApp(
    WidgetTester tester, {
    AppRepository? appRepository,
    InventoryRepository? inventoryRepository,
    MaterialRepository? materialRepository,
    PlayerRepository? playerRepository,
    PollutionRepository? pollutionRepository,
    SaveRepository? saveRepository,
  }) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await diContainer.reset();
    diContainer
      ..registerSingleton<AppRepository>(appRepository ?? _FakeAppRepository())
      ..registerSingleton<CharacterRepository>(CharacterRepositoryImpl())
      ..registerSingleton<ConstructionRepository>(ConstructionRepositoryImpl())
      ..registerSingleton<DayRepository>(DayRepositoryImpl())
      ..registerSingleton<FeedbackRepository>(FeedbackRepositoryImpl())
      ..registerSingleton<InventoryRepository>(inventoryRepository ?? InventoryRepositoryImpl())
      ..registerSingleton<LocationRepository>(LocationRepositoryImpl())
      ..registerSingleton<MaterialRepository>(materialRepository ?? MaterialRepositoryImpl())
      ..registerSingleton<PickupRepository>(PickupRepositoryImpl())
      ..registerSingleton<PlayerRepository>(playerRepository ?? PlayerRepositoryImpl())
      ..registerSingleton<PollutionRepository>(pollutionRepository ?? PollutionRepositoryImpl())
      ..registerSingleton<ProgressRepository>(ProgressRepositoryImpl())
      ..registerSingleton<SaveRepository>(saveRepository ?? SaveRepositoryImpl());
    registerUseCases();

    await tester.pumpWidget(const AppPage(createAppBloc: AppBloc.new));
    await tester.pumpAndSettle();
  }

  testWidgets('Start screen shows menu buttons without the character', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    expect(find.byType(StartPage), findsOneWidget);
    expect(find.byType(TapBuilder), findsNWidgets(3));
    expect(buttonImage(Assets.resources.assets.images.imgButtonNewGame), findsNWidgets(2));
    expect(buttonImage(Assets.resources.assets.images.imgButtonLoadGame), findsNWidgets(2));
    expect(buttonImage(Assets.resources.assets.images.imgButtonExit), findsNWidgets(2));
    expect(find.byType(CharacterContainer), findsNothing);
  });

  testWidgets('Exit button closes the game', (
    WidgetTester tester,
  ) async {
    final appRepository = _FakeAppRepository();
    await pumpApp(tester, appRepository: appRepository);

    await tester.tap(buttonImage(Assets.resources.assets.images.imgButtonExit).last);
    await tester.pumpAndSettle();

    expect(appRepository.exitCount, 1);
  });

  testWidgets('New game shows level buttons with only the first level unlocked', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(buttonImage(Assets.resources.assets.images.imgButtonNewGame).last);
    await tester.pumpAndSettle();

    expect(find.byType(StartPage), findsOneWidget);
    expect(buttonImage(Assets.resources.assets.images.imgButtonNewGame), findsNothing);
    expect(find.byType(PressableContainer), findsNWidgets(4));
    expect(find.byType(TapBuilder), findsNWidgets(2));

    await tester.tap(buttonImage(Assets.resources.assets.images.imgButtonLevel2));
    await tester.pumpAndSettle();
    expect(find.byType(StartPage), findsOneWidget);

    await tester.tap(buttonImage(Assets.resources.assets.images.imgButtonLevel1).last);
    await pumpScene(tester);
    expect(find.byType(Level1Page), findsOneWidget);
  });

  testWidgets('Load game lists saves and opens the saved level', (
    WidgetTester tester,
  ) async {
    final saveRepository = SaveRepositoryImpl()
      ..addSave(
        GameSave(
          level: GameLevel.level2,
          location: .lake,
          savedAt: DateTime(2026, 10, 20, 14, 5),
          day: 1,
          stats: const .initial(),
          materials: const [],
          inventory: const [],
          pickups: const [],
          pollution: const .clean(),
          constructions: const {},
        ),
      );
    await pumpApp(tester, saveRepository: saveRepository);

    await tester.tap(buttonImage(Assets.resources.assets.images.imgButtonLoadGame).last);
    await tester.pumpAndSettle();

    expect(find.byType(LoadGamePage), findsOneWidget);
    expect(find.text('Level 2 · Lake · 20.10.2026 14:05'), findsOneWidget);

    await tester.tap(find.text('Level 2 · Lake · 20.10.2026 14:05'));
    await pumpScene(tester);

    expect(find.byType(Level2Page), findsOneWidget);
    expect(buttonImage(Assets.resources.assets.images.imgLakeRectangle), findsOneWidget);
  });

  testWidgets('Loading a save restores location, materials, inventory, stats and pollution', (
    WidgetTester tester,
  ) async {
    final images = Assets.resources.assets.images;
    final materialRepository = MaterialRepositoryImpl();
    final inventoryRepository = InventoryRepositoryImpl();
    final pollutionRepository = PollutionRepositoryImpl();
    final saveRepository = SaveRepositoryImpl()
      ..addSave(
        GameSave(
          level: GameLevel.level1,
          location: .forest,
          savedAt: DateTime(2026, 10, 20, 16, 30),
          day: 1,
          stats: const PlayerStats(health: 90, hunger: 55, thirst: 45),
          materials: const [MaterialStock(material: .wood, count: 3)],
          inventory: const [InventoryStack(item: .berries, count: 2)],
          pickups: const [],
          pollution: const Pollution(airPoints: 2, isWaterPolluted: true, isSoilPolluted: false),
          constructions: const {},
        ),
      );
    await pumpApp(
      tester,
      materialRepository: materialRepository,
      inventoryRepository: inventoryRepository,
      pollutionRepository: pollutionRepository,
      saveRepository: saveRepository,
    );

    await tester.tap(buttonImage(images.imgButtonLoadGame).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Level 1 · Forest · 20.10.2026 16:30'));
    await pumpScene(tester);

    expect(find.byType(Level1Page), findsOneWidget);
    expect(buttonImage(images.imgForestRectangle), findsOneWidget);
    expect(find.text('90'), findsOneWidget);
    expect(find.text('55'), findsOneWidget);
    expect(find.text('45'), findsOneWidget);
    expect(materialRepository.stocks.single.count, 3);
    expect(inventoryRepository.stacks.single.count, 2);
    expect(pollutionRepository.pollution.airPoints, 2);
    expect(pollutionRepository.pollution.isWaterPolluted, isTrue);
  });

  testWidgets('Back button on level selection returns to the main menu', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(buttonImage(Assets.resources.assets.images.imgButtonNewGame).last);
    await tester.pumpAndSettle();
    await tester.tap(buttonImage(Assets.resources.assets.images.imgButtonBack).last);
    await tester.pumpAndSettle();

    expect(find.byType(StartPage), findsOneWidget);
    expect(buttonImage(Assets.resources.assets.images.imgButtonNewGame), findsNWidgets(2));
    expect(buttonImage(Assets.resources.assets.images.imgButtonBack), findsNothing);
  });

  testWidgets('Back button on load game returns to the main menu', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(buttonImage(Assets.resources.assets.images.imgButtonLoadGame).last);
    await tester.pumpAndSettle();
    await tester.tap(buttonImage(Assets.resources.assets.images.imgButtonBack).last);
    await tester.pumpAndSettle();

    expect(find.byType(LoadGamePage), findsNothing);
    expect(find.byType(StartPage), findsOneWidget);
    expect(buttonImage(Assets.resources.assets.images.imgButtonNewGame), findsNWidgets(2));
  });

  testWidgets('Level starts at home with the HUD and the map switches location', (
    WidgetTester tester,
  ) async {
    final images = Assets.resources.assets.images;
    await pumpApp(tester);

    await tester.tap(buttonImage(images.imgButtonNewGame).last);
    await tester.pumpAndSettle();
    await tester.tap(buttonImage(images.imgButtonLevel1).last);
    await pumpScene(tester);

    expect(find.byType(Level1Page), findsOneWidget);
    expect(buttonImage(images.imgHouseRectangle), findsOneWidget);
    expect(find.byType(CharacterContainer), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.text('80'), findsNWidgets(2));
    expect(buttonImage(images.imgInventory12), findsOneWidget);
    expect(buttonImage(images.imgMap), findsNothing);

    await tester.tap(buttonImage(images.imgMapIconPixel).last);
    await pumpScene(tester);

    expect(buttonImage(images.imgMap), findsOneWidget);
    expect(buttonImage(images.imgSvalkaIcon), findsNWidgets(2));
    expect(buttonImage(images.imgStoreIcon), findsNothing);

    await tester.tap(buttonImage(images.imgForestIcon).last);
    await pumpScene(tester);

    expect(buttonImage(images.imgMap), findsNothing);
    expect(buttonImage(images.imgForestRectangle), findsOneWidget);
    expect(buttonImage(images.imgHouseRectangle), findsNothing);
  });

  testWidgets('Close button on the map returns to the location', (
    WidgetTester tester,
  ) async {
    final images = Assets.resources.assets.images;
    await pumpApp(tester);

    await tester.tap(buttonImage(images.imgButtonNewGame).last);
    await tester.pumpAndSettle();
    await tester.tap(buttonImage(images.imgButtonLevel1).last);
    await pumpScene(tester);
    await tester.tap(buttonImage(images.imgMapIconPixel).last);
    await pumpScene(tester);

    expect(buttonImage(images.imgMap), findsOneWidget);

    await tester.tap(buttonImage(images.imgButtonClose).last);
    await pumpScene(tester);

    expect(buttonImage(images.imgMap), findsNothing);
    expect(buttonImage(images.imgHouseRectangle), findsOneWidget);
  });

  testWidgets('Menu panel saves the game and exits to the main menu', (
    WidgetTester tester,
  ) async {
    final images = Assets.resources.assets.images;
    final saveRepository = SaveRepositoryImpl();
    await pumpApp(tester, saveRepository: saveRepository);

    await tester.tap(buttonImage(images.imgButtonNewGame).last);
    await tester.pumpAndSettle();
    await tester.tap(buttonImage(images.imgButtonLevel1).last);
    await pumpScene(tester);

    expect(opacityOf(tester, images.imgDoneIcon), 0);

    await tester.tap(buttonImage(images.imgButtonMenu).last);
    await pumpScene(tester);
    await tester.tap(buttonImage(images.imgSaveIcon).last);
    await pumpScene(tester);

    expect(saveRepository.saves, hasLength(1));
    expect(saveRepository.saves.single.level, GameLevel.level1);
    expect(saveRepository.saves.single.location, GameLocation.house);
    expect(opacityOf(tester, images.imgDoneIcon), 1);

    await tester.tap(buttonImage(images.imgExitIcon).last);
    await pumpScene(tester);

    expect(find.byType(StartPage), findsOneWidget);
    expect(buttonImage(images.imgButtonNewGame), findsNWidgets(2));
  });

  testWidgets('Keeping found resources adds materials to the counter and food to the inventory', (
    WidgetTester tester,
  ) async {
    final images = Assets.resources.assets.images;
    final materialRepository = MaterialRepositoryImpl();
    final inventoryRepository = InventoryRepositoryImpl();
    await pumpApp(tester, materialRepository: materialRepository, inventoryRepository: inventoryRepository);
    await startLevel1(tester);

    expect(buttonImage(images.imgPlasticBottle), findsNWidgets(2));
    expect(buttonImage(images.imgBushBerriespng), findsNWidgets(4));

    await tester.tap(buttonImage(images.imgPlasticBottle).last);
    await pumpScene(tester);

    expect(find.text('YOU FOUND PLASTIC'), findsOneWidget);
    expect(find.text('WHAT ARE YOU GONNA DO?'), findsOneWidget);

    await tapText(tester, 'KEEP IT');

    expect(find.text('YOU FOUND PLASTIC'), findsNothing);
    expect(materialRepository.stocks.single.material, GameMaterial.plastic);
    expect(materialRepository.stocks.single.count, 1);
    expect(find.byType(MaterialContainer), findsOneWidget);

    await tester.tap(buttonImage(images.imgBushBerriespng).last);
    await pumpScene(tester);

    expect(find.text('YOU FOUND BERRIES'), findsOneWidget);
    expect(buttonImage(images.imgBerries), findsOneWidget);

    await tapText(tester, 'KEEP IT');

    expect(buttonImage(images.imgBushBerriespng), findsNWidgets(2));
    expect(inventoryRepository.stacks.single.item, InventoryItem.berries);
    expect(find.byType(InventorySlotContainer), findsOneWidget);
  });

  testWidgets('Throwing away materials pollutes the chosen place and food pollutes nothing', (
    WidgetTester tester,
  ) async {
    final images = Assets.resources.assets.images;
    final pollutionRepository = PollutionRepositoryImpl();
    final materialRepository = MaterialRepositoryImpl();
    await pumpApp(tester, pollutionRepository: pollutionRepository, materialRepository: materialRepository);
    await startLevel1(tester);

    await tester.tap(buttonImage(images.imgPlasticBottle).last);
    await pumpScene(tester);
    await tapText(tester, 'THROW AWAY');

    expect(find.text('WHERE TO THROW IT?'), findsOneWidget);

    await tapText(tester, 'DUMP');

    expect(find.text('WHERE TO THROW IT?'), findsNothing);
    expect(buttonImage(images.imgPlasticBottle), findsNothing);
    expect(materialRepository.stocks, isEmpty);
    expect(pollutionRepository.pollution.airPoints, 3);
    expect(pollutionRepository.pollution.isWaterPolluted, isFalse);

    await tester.tap(buttonImage(images.imgBushBerriespng).last);
    await pumpScene(tester);
    await tapText(tester, 'THROW AWAY');
    await tapText(tester, 'LAKE');
    await tester.tap(buttonImage(images.imgBushBerriespng).last);
    await pumpScene(tester);
    await tapText(tester, 'THROW AWAY');
    await tapText(tester, 'FOREST');

    expect(buttonImage(images.imgBushBerriespng), findsNothing);
    expect(pollutionRepository.pollution.airPoints, 3);
    expect(pollutionRepository.pollution.isWaterPolluted, isFalse);
    expect(pollutionRepository.pollution.isSoilPolluted, isFalse);
  });

  testWidgets('Throwing a material into the lake or the forest pollutes water or soil', (
    WidgetTester tester,
  ) async {
    final images = Assets.resources.assets.images;
    final pollutionRepository = PollutionRepositoryImpl();
    await pumpApp(tester, pollutionRepository: pollutionRepository);
    await startLevel1(tester);
    await tester.tap(buttonImage(images.imgMapIconPixel).last);
    await pumpScene(tester);
    await tester.tap(buttonImage(images.imgForestIcon).last);
    await pumpScene(tester);

    await tester.tap(buttonImage(images.imgWood).first);
    await pumpScene(tester);
    await tapText(tester, 'THROW AWAY');
    await tapText(tester, 'LAKE');

    expect(pollutionRepository.pollution.isWaterPolluted, isTrue);
    expect(pollutionRepository.pollution.isSoilPolluted, isFalse);

    await tester.tap(buttonImage(images.imgWood).first);
    await pumpScene(tester);
    await tapText(tester, 'THROW AWAY');
    await tapText(tester, 'FOREST');

    expect(pollutionRepository.pollution.isSoilPolluted, isTrue);
    expect(pollutionRepository.pollution.airPoints, 0);
  });

  testWidgets('Keeping food with a full inventory shows a message and leaves the item', (
    WidgetTester tester,
  ) async {
    final images = Assets.resources.assets.images;
    final inventoryRepository = InventoryRepositoryImpl();
    await pumpApp(tester, inventoryRepository: inventoryRepository);
    await startLevel1(tester);
    for (var i = 0; i < 60; i++) {
      inventoryRepository.add(InventoryItem.algae);
    }
    await pumpScene(tester);

    await tester.tap(buttonImage(images.imgBushBerriespng).last);
    await pumpScene(tester);
    await tapText(tester, 'KEEP IT');

    expect(find.text('YOUR INVENTORY IS FULL'), findsOneWidget);

    await tapText(tester, 'OK');

    expect(find.text('YOUR INVENTORY IS FULL'), findsNothing);
    expect(buttonImage(images.imgBushBerriespng), findsNWidgets(4));
  });

  testWidgets('Collected items show their name on hover and highlight when tapped', (
    WidgetTester tester,
  ) async {
    final images = Assets.resources.assets.images;
    await pumpApp(tester);
    await startLevel1(tester);

    await tester.tap(buttonImage(images.imgBushBerriespng).last);
    await pumpScene(tester);
    await tapText(tester, 'KEEP IT');

    final slot = find.ancestor(of: find.byType(InventorySlotContainer), matching: find.byType(SelectableContainer));
    expect(find.text('Berries'), findsNothing);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(slot));
    await pumpScene(tester);

    expect(find.text('Berries'), findsOneWidget);
    expect(tester.widget<SelectableContainer>(slot).isSelected, isFalse);

    await tester.tap(slot);
    await pumpScene(tester);

    expect(tester.widget<SelectableContainer>(slot).isSelected, isTrue);

    await tester.tap(slot);
    await pumpScene(tester);

    expect(tester.widget<SelectableContainer>(slot).isSelected, isFalse);
  });

  testWidgets('Trips to and from a far location cost thirst', (
    WidgetTester tester,
  ) async {
    final images = Assets.resources.assets.images;
    final playerRepository = PlayerRepositoryImpl();
    await pumpApp(tester, playerRepository: playerRepository);
    await startLevel1(tester);

    await tester.tap(buttonImage(images.imgMapIconPixel).last);
    await pumpScene(tester);
    await tester.tap(buttonImage(images.imgForestIcon).last);
    await pumpScene(tester);

    expect(playerRepository.stats.thirst, 80);

    await tester.tap(buttonImage(images.imgMapIconPixel).last);
    await pumpScene(tester);
    await tester.tap(buttonImage(images.imgSvalkaIcon).last);
    await pumpScene(tester);

    expect(playerRepository.stats.thirst, 70);

    await tester.tap(buttonImage(images.imgMapIconPixel).last);
    await pumpScene(tester);
    await tester.tap(buttonImage(images.imgHomeIcon).last);
    await pumpScene(tester);

    expect(playerRepository.stats.thirst, 60);
    expect(find.text('60'), findsOneWidget);
  });

  test('Inventory stacks five items per slot and holds twelve slots', () {
    final inventoryRepository = InventoryRepositoryImpl();

    for (var i = 0; i < 60; i++) {
      expect(inventoryRepository.add(InventoryItem.algae), isTrue);
    }

    expect(inventoryRepository.stacks, hasLength(12));
    expect(inventoryRepository.stacks.every((stack) => stack.count == 5), isTrue);
    expect(inventoryRepository.add(InventoryItem.berries), isFalse);
  });

  testWidgets('Sky and clouds darken smoothly as air pollution grows', (
    WidgetTester tester,
  ) async {
    final images = Assets.resources.assets.images;
    final pollutionRepository = PollutionRepositoryImpl()..addAirPoints(5);
    await pumpApp(tester, pollutionRepository: pollutionRepository);

    await tester.tap(buttonImage(images.imgButtonNewGame).last);
    await tester.pumpAndSettle();
    await tester.tap(buttonImage(images.imgButtonLevel1).last);
    await pumpScene(tester);

    expect(pollutionRepository.pollution.airPoints, 0);
    expect(opacityOf(tester, images.imgSkyBlack), 0);
    expect(opacityOf(tester, images.imgClaudBlack), 0);
    expect(opacityOf(tester, images.imgClaudBlue), 1);

    pollutionRepository.addAirPoints(1);
    await pumpScene(tester);

    expect(opacityOf(tester, images.imgSkyBlack), 0);
    expect(opacityOf(tester, images.imgClaudBlack), 1);
    expect(opacityOf(tester, images.imgClaudBlue), 0);

    pollutionRepository.addAirPoints(3);
    await pumpScene(tester);

    expect(opacityOf(tester, images.imgSkyBlack), 1);
    expect(opacityOf(tester, images.imgClaudBlack), 1);
  });

  testWidgets('Opening a level URL directly redirects to the start screen', (
    WidgetTester tester,
  ) async {
    tester.binding.platformDispatcher.defaultRouteNameTestValue = '/level-2';
    addTearDown(tester.binding.platformDispatcher.clearDefaultRouteNameTestValue);

    await pumpApp(tester);

    expect(find.byType(StartPage), findsOneWidget);
    expect(find.byType(Level2Page), findsNothing);
  });
}
