


import 'package:navigation/navigation.dart';
final navigationGetIt = GetIt.instance;
void setupNavigationDependencies() {
   navigationGetIt.registerSingleton<AppRouter>(AppRouter());       
}
