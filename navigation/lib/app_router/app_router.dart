import 'package:home/home.dart';
import 'package:navigation/navigation.dart';
import 'package:auth/auth.dart';
import 'package:core/core.dart';

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
        AutoRoute(
          initial: true,
          page: AuthWrapperRoute.page,
          children: [
            AutoRoute(initial: true, page: StartAuthRoute.page),
            AutoRoute(page: RegisterRoute.page),
            AutoRoute(page: LoginRoute.page),
          ],
        ),
        AutoRoute(page: ChatsRoute.page),
        AutoRoute(page: EmailVerificationRoute.page),
        AutoRoute(page: SharedNavbarRoute.page),
        AutoRoute(
          page: SingleChatWrapperRoute.page,
          children: [
            AutoRoute(page: PersonalChatRoute.page),
            AutoRoute(page: ChatSettingsRoute.page),
            AutoRoute(page: AddChatRoute.page),
          ],
        ),
        CustomRoute(
          page: FailurePopupRoute.page,
          path: '/failure_popup',
          customRouteBuilder: RouteBuilder.modalDialogWithoutAnimation,
        ),
      ];
}
