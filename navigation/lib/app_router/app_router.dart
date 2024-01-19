import 'package:home/home.dart';
import 'package:navigation/navigation.dart';
import 'package:auth/src/navigation/router.dart';
import 'package:home/src/navigation/router.dart';
import 'package:core/core.dart';

import 'app_router_guard.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(
  modules: [
    AuthModuleRouter,
    HomeModuleRouter,
  ],
)
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => <AutoRoute>[
        AutoRoute(initial: true, page: StartAuthRoute.page),
        AutoRoute(page: RegisterRoute.page),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: ChatsRoute.page),
        AutoRoute(page: EmailVerificationRoute.page),
        AutoRoute(page: SharedNavbarRoute.page),
        AutoRoute(page: PersonalChatRoute.page),
        AutoRoute(page: AddChatRoute.page),
        CustomRoute(
          page: FailurePopupRoute.page,
          path: '/failure_popup',
          customRouteBuilder: RouteBuilder.modalDialogWithoutAnimation,
        ),
      ];
}
