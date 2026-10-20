import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

void main() {
  Future<int Function()> pumpScene(WidgetTester tester, Size screen) async {
    await tester.binding.setSurfaceSize(screen);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: DesignSystemTheme(
          data: .light(),
          brightness: .light,
          child: SceneContainer(
            children: [
              BackgroundContainer(
                image: Assets.resources.assets.images.background,
                elements: [
                  BackgroundElement(
                    left: 960,
                    top: 540,
                    width: 200,
                    height: 400,
                    child: PressableContainer(
                      image: Assets.resources.assets.images.imgMainCharacter,
                      onTap: () => taps++,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return () => taps;
  }

  double glowOpacity(WidgetTester tester) =>
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity;

  double scale(WidgetTester tester) =>
      tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale;

  testWidgets('Scene keeps 16:9 with black bars and scales design pixels', (
    WidgetTester tester,
  ) async {
    await pumpScene(tester, const Size(2000, 1000));

    final scene = tester.getRect(find.byType(BackgroundContainer));
    expect(scene.height, closeTo(1000, 0.01));
    expect(scene.width, closeTo(1000 * 16 / 9, 0.01));
    expect(scene.left, closeTo((2000 - 1000 * 16 / 9) / 2, 0.01));

    final pressable = tester.getRect(find.byType(TapBuilder));
    final factor = 1000 / 1080;
    expect(pressable.left, closeTo(scene.left + 960 * factor, 0.01));
    expect(pressable.top, closeTo(540 * factor, 0.01));
    expect(pressable.width, closeTo(200 * factor, 0.01));
  });

  testWidgets('Press scales down and glows, hover glows, tap fires onTap', (
    WidgetTester tester,
  ) async {
    final taps = await pumpScene(tester, const Size(1920, 1080));
    final center = tester.getCenter(find.byType(TapBuilder));
    expect(glowOpacity(tester), 0);
    expect(scale(tester), 1);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(center);
    await tester.pump();
    expect(glowOpacity(tester), 1);
    expect(scale(tester), 1);

    await mouse.down(center);
    await tester.pump();
    expect(scale(tester), 0.9);

    await mouse.up();
    await tester.pump();
    expect(scale(tester), 1);
    expect(taps(), 1);

    await mouse.moveTo(Offset.zero);
    await tester.pump();
    expect(glowOpacity(tester), 0);
  });
}
