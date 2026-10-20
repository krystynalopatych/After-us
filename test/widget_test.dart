import 'package:data/character/repository/character_repository_impl.dart';
import 'package:data/progress/repository/progress_repository_impl.dart';
import 'package:data/save/repository/save_repository_impl.dart';
import 'package:domain/app/repository/app_repository.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/save/model/game_save.dart';
import 'package:domain/save/repository/save_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/design/design_src.dart';
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

  Future<void> pumpApp(
    WidgetTester tester, {
    AppRepository? appRepository,
    SaveRepository? saveRepository,
  }) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      AppPage(
        createAppBloc: AppBloc.new,
        appRepository: appRepository ?? _FakeAppRepository(),
        characterRepository: CharacterRepositoryImpl(),
        progressRepository: ProgressRepositoryImpl(),
        saveRepository: saveRepository ?? SaveRepositoryImpl(),
      ),
    );
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
    await tester.pumpAndSettle();
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
    await tester.pumpAndSettle();

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
