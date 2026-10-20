import 'package:flutter/material.dart';
import 'package:presentation/design/src/widget/character/model/character_state.dart';
import 'package:presentation/design/src/widget/pressable_container/tap_builder.dart';

final class CharacterContainer extends StatelessWidget {
  static const _heightFactor = 0.41;

  final CharacterState state;
  final VoidCallback onTap;

  const CharacterContainer({
    super.key,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: .bottomLeft,
      child: FractionallySizedBox(
        heightFactor: _heightFactor,
        child: TapBuilder(
          onTap: onTap,
          builder: (context, isPressed, isHovered) => state.image.image(fit: .contain),
        ),
      ),
    );
  }
}
