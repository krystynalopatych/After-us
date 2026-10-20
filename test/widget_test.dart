import 'package:data/air/repository/air_repository_impl.dart';
import 'package:data/character/repository/character_repository_impl.dart';
import 'package:data/location/repository/location_repository_impl.dart';
import 'package:data/material/repository/material_repository_impl.dart';
import 'package:data/player/repository/player_repository_impl.dart';
import 'package:data/progress/repository/progress_repository_impl.dart';
import 'package:data/save/repository/save_repository_impl.dart';
import 'package:domain/air/repository/air_repository.dart';
import 'package:domain/app/repository/app_repository.dart';
import 'package:domain/character/repository/character_repository.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/player/repository/player_repository.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/repository/progress_repository.dart';
import 'package:domain/save/model/game_save.dart';
import 'package:domain/save/repository/save_repository.dart';
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

  Future<void> pumpApp(
    WidgetTester tester, {
    AirRepository? airRepository,
    AppRepository? appRepository,
    SaveRepository? saveRepository,
  }) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await diContainer.reset();
    diContainer
      ..registerSingleton<AirRepository>(airRepository ?? AirRepositoryImpl())
      ..registerSingleton<AppRepository>(appRepository ?? _FakeAppRepository())
      ..registerSingleton<CharacterRepository>(CharacterRepositoryImpl())
      ..registerSingleton<LocationRepository>(LocationRepositoryImpl())
      ..registerSingleton<MaterialRepository>(MaterialRepositoryImpl())
      ..registerSingleton<PlayerRepository>(PlayerRepositoryImpl())
      ..registerSingleton<ProgressRepository>(ProgressRepositoryImpl())
      ..registerSingleton<SaveRepository>(saveRepository ?? SaveRepositoryImpl());

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

    for (final image in [images.imgMainCharacterHappy, images.imgMainCharacterSad, images.imgMainCharacter]) {
      tester.widget<CharacterContainer>(find.byType(CharacterContainer)).onTap();
      await pumpScene(tester);
      expect(buttonImage(image), findsOneWidget);
    }
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

  testWidgets('Sky and clouds darken smoothly as air pollution grows', (
    WidgetTester tester,
  ) async {
    final images = Assets.resources.assets.images;
    final airRepository = AirRepositoryImpl()..addPoints(5);
    await pumpApp(tester, airRepository: airRepository);

    await tester.tap(buttonImage(images.imgButtonNewGame).last);
    await tester.pumpAndSettle();
    await tester.tap(buttonImage(images.imgButtonLevel1).last);
    await pumpScene(tester);

    expect(airRepository.points, 0);
    expect(opacityOf(tester, images.imgSkyBlack), 0);
    expect(opacityOf(tester, images.imgClaudBlack), 0);
    expect(opacityOf(tester, images.imgClaudBlue), 1);

    airRepository.addPoints(1);
    await pumpScene(tester);

    expect(opacityOf(tester, images.imgSkyBlack), 0);
    expect(opacityOf(tester, images.imgClaudBlack), 1);
    expect(opacityOf(tester, images.imgClaudBlue), 0);

    airRepository.addPoints(3);
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
