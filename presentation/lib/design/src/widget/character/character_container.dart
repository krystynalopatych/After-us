import 'package:flutter/material.dart';
import 'package:presentation/design/src/widget/character/model/character_state.dart';
import 'package:presentation/design/src/widget/pressable_container/tap_builder.dart';

final class CharacterContainer extends StatelessWidget {
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
        heightFactor: 0.41,
        child: TapBuilder(
          onTap: onTap,
          builder: (context, isPressed, isHovered) => state.image.image(fit: .contain),
        ),
      ),
    );
  }
}
