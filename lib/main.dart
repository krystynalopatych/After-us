import 'package:after_us_game/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:presentation/feature/app/page/app_page.dart';

void main() {
  registerDependencies();
  runApp(
    AppPage(
      createAppBloc: createAppBloc,
    ),
  );
}
