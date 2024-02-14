import 'package:get_it/get_it.dart';
import 'package:navigation/di/navigation_di.dart';

final AppDI appDI = AppDI();
final GetIt appLocator = GetIt.instance;

class AppDI {
  static void initDependencies() {
    setupNavigationDependencies();
  }
}
