import 'package:flutter/material.dart';
import 'package:home/home.dart';
import 'package:navigation/navigation.dart';

import '../views/add_chat_view.dart';
import '../views/personal_chat_view.dart';

part 'router.gm.dart';

@AutoRouterConfig.module(replaceInRouteName: 'View,Route')
class HomeModuleRouter extends _$HomeModuleRouter {}
