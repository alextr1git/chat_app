// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AuthModuleRouter extends AutoRouterModule {
  @override
  final Map<String, PageFactory> pagesMap = {
    EmailVerificationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const EmailVerificationView(),
      );
    },
    FailurePopupRoute.name: (routeData) {
      final args = routeData.argsAs<FailurePopupRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: FailurePopupView(
          key: args.key,
          exceptionMessage: args.exceptionMessage,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginView(),
      );
    },
    RegisterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterView(),
      );
    },
    StartAuthRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const StartAuthView(),
      );
    },
  };
}

/// generated route for
/// [EmailVerificationView]
class EmailVerificationRoute extends PageRouteInfo<void> {
  const EmailVerificationRoute({List<PageRouteInfo>? children})
      : super(
          EmailVerificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'EmailVerificationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [FailurePopupView]
class FailurePopupRoute extends PageRouteInfo<FailurePopupRouteArgs> {
  FailurePopupRoute({
    Key? key,
    required String exceptionMessage,
    List<PageRouteInfo>? children,
  }) : super(
          FailurePopupRoute.name,
          args: FailurePopupRouteArgs(
            key: key,
            exceptionMessage: exceptionMessage,
          ),
          initialChildren: children,
        );

  static const String name = 'FailurePopupRoute';

  static const PageInfo<FailurePopupRouteArgs> page =
      PageInfo<FailurePopupRouteArgs>(name);
}

class FailurePopupRouteArgs {
  const FailurePopupRouteArgs({
    this.key,
    required this.exceptionMessage,
  });

  final Key? key;

  final String exceptionMessage;

  @override
  String toString() {
    return 'FailurePopupRouteArgs{key: $key, exceptionMessage: $exceptionMessage}';
  }
}

/// generated route for
/// [LoginView]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterView]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [StartAuthView]
class StartAuthRoute extends PageRouteInfo<void> {
  const StartAuthRoute({List<PageRouteInfo>? children})
      : super(
          StartAuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'StartAuthRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
