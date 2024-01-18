// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$HomeModuleRouter extends AutoRouterModule {
  @override
  final Map<String, PageFactory> pagesMap = {
    ChatHomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChatHomeView(),
      );
    },
    PersonalChatRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PersonalChatView(),
      );
    },
    SharedNavbarRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SharedNavbarView(),
      );
    },
  };
}

/// generated route for
/// [ChatHomeView]
class ChatHomeRoute extends PageRouteInfo<void> {
  const ChatHomeRoute({List<PageRouteInfo>? children})
      : super(
          ChatHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatHomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PersonalChatView]
class PersonalChatRoute extends PageRouteInfo<void> {
  const PersonalChatRoute({List<PageRouteInfo>? children})
      : super(
          PersonalChatRoute.name,
          initialChildren: children,
        );

  static const String name = 'PersonalChatRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SharedNavbarView]
class SharedNavbarRoute extends PageRouteInfo<void> {
  const SharedNavbarRoute({List<PageRouteInfo>? children})
      : super(
          SharedNavbarRoute.name,
          initialChildren: children,
        );

  static const String name = 'SharedNavbarRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
