import 'package:navigation/navigation.dart';
import 'package:auth/src/navigation/router.dart';
import 'package:core/core.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(
  modules: [AuthModuleRouter],
)
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => <AutoRoute>[
        AutoRoute(initial: true, page: StartAuthRoute.page),
        AutoRoute(page: RegisterRoute.page),
        AutoRoute(page: LoginRoute.page),
        CustomRoute(
          page: FailurePopupRoute.page,
          path: '/failure_popup',
          customRouteBuilder: RouteBuilder.modalDialogWithoutAnimation,
        ),
      ];
}
