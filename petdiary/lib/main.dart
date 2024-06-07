import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'presentation/screens/auth/sign_in_screen.dart';
import 'presentation/screens/root_screen.dart';
import 'presentation/themes/app_theme.dart';
import 'services/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en', 'US'),
      ],
      path: 'assets/langs',
      startLocale: const Locale('tr', 'TR'),
      fallbackLocale: const Locale('tr', 'TR'),
      assetLoader: const JsonAssetLoader(),
      saveLocale: true,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Future<String?> _contextUserIdFuture;

  @override
  void initState() {
    super.initState();
    _contextUserIdFuture = getContextUserId();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _contextUserIdFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildAppWithUserInfo(snapshot.data!);
        } else {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: const SignInScreen(),
          );
        }
      },
    );
  }

  Widget buildAppWithUserInfo(String contextUserId) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: RootScreen(
          contextUserId: contextUserId,
        ));
  }
}

class ContextUserInfo extends InheritedWidget {
  final String? contextUserId;

  const ContextUserInfo({
    required this.contextUserId,
    required super.child,
    super.key,
  });

  static ContextUserInfo of(BuildContext context) {
    final ContextUserInfo? result =
        context.dependOnInheritedWidgetOfExactType<ContextUserInfo>();
    assert(result != null, 'No ContextUserInfo found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ContextUserInfo oldWidget) {
    return oldWidget.contextUserId != contextUserId;
  }
}

Future<String?> getContextUserId() async {
  SharedPreferencesUtils sharedPreferencesUtils = SharedPreferencesUtils();
  final contextUser = await sharedPreferencesUtils.getUserId();

  return contextUser;
}

Future<bool> checkAuthentication() async {
  SharedPreferencesUtils sharedPreferencesUtils = SharedPreferencesUtils();
  final token = await sharedPreferencesUtils.getToken();

  return token != null;
}

// Future<User?> getContextUser(String contextUserId) async {
//   UserService userService = UserService();
//   try {
//     final user = await userService.getUserById(contextUserId);
//     return user.first;
//   } catch (e) {
//     return null;
//   }
// }
