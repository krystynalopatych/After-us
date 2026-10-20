import 'package:domain/app/repository/app_repository.dart';
import 'package:web/web.dart' as web;

final class AppRepositoryImpl implements AppRepository {
  @override
  void exit() => web.window.close();
}
