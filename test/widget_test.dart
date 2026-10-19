import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/feature/app/page/app_page.dart';
import 'package:presentation/feature/level_2/page/level_2_page.dart';
import 'package:presentation/feature/start/page/start_page.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

import 'package:after_us_game/di/injection.dart';

void main() {
  Finder characterImage(AssetGenImage image) => find.descendant(
    of: find.byType(CharacterContainer),
    matching: find.byWidgetPredicate(
      (widget) => widget is Image && (widget.image as AssetImage).assetName == image.path,
    ),
  );

  testWidgets('Start screen opens a level, which changes the character mood', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      AppPage(
        createAppBloc: createAppBloc,
        characterRepository: createCharacterRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(StartPage), findsOneWidget);
    expect(find.byType(PressableContainer), findsNWidgets(3));
    expect(characterImage(Assets.resources.assets.images.imgMainCharacter), findsOneWidget);

    await tester.tap(find.byType(PressableContainer).at(1));
    await tester.pumpAndSettle();

    expect(find.byType(Level2Page), findsOneWidget);
    expect(find.byType(StartPage), findsNothing);
    expect(characterImage(Assets.resources.assets.images.imgMainCharacterSad), findsOneWidget);
  });

  testWidgets('Opening a level URL directly redirects to the start screen', (
    WidgetTester tester,
  ) async {
    tester.binding.platformDispatcher.defaultRouteNameTestValue = '/level-2';
    addTearDown(tester.binding.platformDispatcher.clearDefaultRouteNameTestValue);

    await tester.pumpWidget(
      AppPage(
        createAppBloc: createAppBloc,
        characterRepository: createCharacterRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(StartPage), findsOneWidget);
    expect(find.byType(Level2Page), findsNothing);
  });
}
