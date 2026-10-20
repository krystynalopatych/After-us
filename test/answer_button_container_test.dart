import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

void main() {
  const hint = 'Not enough resources!';

  Future<int Function()> pumpButton(
    WidgetTester tester, {
    bool isEnabled = true,
    bool isDone = false,
  }) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: DesignSystemTheme(
          data: .light(),
          brightness: .light,
          child: Center(
            child: SizedBox(
              width: 320,
              height: 192,
              child: AnswerButtonContainer(
                text: 'CAMPFIRE',
                isEnabled: isEnabled,
                isDone: isDone,
                hint: hint,
                onTap: () => taps++,
              ),
            ),
          ),
        ),
      ),
    );
    return () => taps;
  }

  Finder doneIcon() => find.byWidgetPredicate(
    (widget) =>
        widget is Image && (widget.image as AssetImage).assetName == Assets.resources.assets.images.imgDoneIcon.path,
  );

  Future<void> hover(WidgetTester tester) async {
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byType(AnswerButtonContainer)));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'An enabled button reacts to taps and shows no hint',
    (
      WidgetTester tester,
    ) async {
      final taps = await pumpButton(tester);

      await hover(tester);
      await tester.tap(find.byType(AnswerButtonContainer));
      await tester.pumpAndSettle();

      expect(
        taps(),
        1,
      );
      expect(
        find.text(hint),
        findsNothing,
      );
    },
  );

  testWidgets(
    'A disabled button ignores taps and shows its hint on hover',
    (
      WidgetTester tester,
    ) async {
      final taps = await pumpButton(
        tester,
        isEnabled: false,
      );

      expect(
        find.text(hint),
        findsNothing,
      );

      await hover(tester);
      await tester.tap(find.byType(AnswerButtonContainer));
      await tester.pumpAndSettle();

      expect(
        taps(),
        0,
      );
      expect(
        find.text(hint),
        findsOneWidget,
      );
      expect(
        tester.getCenter(find.text(hint)).dx,
        greaterThan(tester.getRect(find.byType(AnswerButtonContainer)).right),
      );
    },
  );

  testWidgets(
    'A done button shows the check mark',
    (
      WidgetTester tester,
    ) async {
      await pumpButton(
        tester,
        isEnabled: false,
        isDone: true,
      );

      expect(
        doneIcon(),
        findsOneWidget,
      );
    },
  );
}
