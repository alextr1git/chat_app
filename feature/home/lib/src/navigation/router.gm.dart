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
    ChatSettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChatSettingsView(),
      );
    },
    ChatsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChatsView(),
      );
    },
    PersonalChatRoute.name: (routeData) {
      final args = routeData.argsAs<PersonalChatRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PersonalChatView(
          key: args.key,
          chatModel: args.chatModel,
        ),
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
/// [ChatSettingsView]
class ChatSettingsRoute extends PageRouteInfo<void> {
  const ChatSettingsRoute({List<PageRouteInfo>? children})
      : super(
          ChatSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatSettingsRoute';

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
class PersonalChatRoute extends PageRouteInfo<PersonalChatRouteArgs> {
  PersonalChatRoute({
    Key? key,
    required ChatModel chatModel,
    List<PageRouteInfo>? children,
  }) : super(
          PersonalChatRoute.name,
          args: PersonalChatRouteArgs(
            key: key,
            chatModel: chatModel,
          ),
          initialChildren: children,
        );

  static const String name = 'PersonalChatRoute';

  static const PageInfo<PersonalChatRouteArgs> page =
      PageInfo<PersonalChatRouteArgs>(name);
}

class PersonalChatRouteArgs {
  const PersonalChatRouteArgs({
    this.key,
    required this.chatModel,
  });

  final Key? key;

  final ChatModel chatModel;

  @override
  String toString() {
    return 'PersonalChatRouteArgs{key: $key, chatModel: $chatModel}';
  }
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
