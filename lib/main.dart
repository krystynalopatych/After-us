import 'package:flutter/material.dart';
import 'package:presentation/feature/app/page/app_page.dart';

import 'di/injection.dart';

void main() {
  runApp(
    AppPage(
      createAppBloc: createAppBloc,
      appRepository: createAppRepository(),
      characterRepository: createCharacterRepository(),
      progressRepository: createProgressRepository(),
      saveRepository: createSaveRepository(),
    ),
  );
}
