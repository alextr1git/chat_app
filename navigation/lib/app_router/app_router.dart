import 'package:navigation/navigation.dart';
import 'package:auth/src/navigation/router.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(modules:[
  AuthModuleRouter
],)
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => <AutoRoute>[
    AutoRoute(initial: true,page: RegisterRoute.page),
    AutoRoute(page: LoginRoute.page)
  ];
}
