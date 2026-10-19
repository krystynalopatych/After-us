import 'package:flutter/material.dart';
import 'package:presentation/design/src/widget/character/model/character_state.dart';

final class CharacterContainer extends StatelessWidget {
  final CharacterState state;

  const CharacterContainer({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: .bottomLeft,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: state.image.image(fit: .contain),
      ),
    );
  }
}
