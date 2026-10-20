import 'package:flutter/material.dart';
import 'package:presentation/feature/app/page/app_page.dart';

import 'di/injection.dart';

void main() {
  registerDependencies();
  runApp(
    AppPage(
      createAppBloc: createAppBloc,
    ),
  );
}
