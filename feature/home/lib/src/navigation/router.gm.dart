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
    AddChatRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AddChatView(),
      );
    },
    ChatsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChatsView(),
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
/// [AddChatView]
class AddChatRoute extends PageRouteInfo<void> {
  const AddChatRoute({List<PageRouteInfo>? children})
      : super(
          AddChatRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddChatRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ChatsView]
class ChatsRoute extends PageRouteInfo<void> {
  const ChatsRoute({List<PageRouteInfo>? children})
      : super(
          ChatsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatsRoute';

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
