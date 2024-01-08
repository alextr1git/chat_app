import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import '../views/login_view.dart';
import '../views/register_view.dart';
import '../views/start_auth_view.dart';
import '../widgets/failure_popup.dart';
part 'router.gm.dart';

@AutoRouterConfig.module(replaceInRouteName: 'View,Route')
class AuthModuleRouter extends _$AuthModuleRouter {}
