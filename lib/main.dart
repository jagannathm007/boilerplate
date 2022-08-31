import 'package:boilerplate/themes/app_theme.dart';
import 'package:boilerplate/config/app_config.dart';
import 'package:boilerplate/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';

import 'utils/zindex.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(AppConfig.appStrorage);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: ((context, widget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
          ),
          child: widget!,
        );
      }),
      title: AppConfig.appName,
      debugShowCheckedModeBanner: AppConfig.appDebugMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      getPages: AppRoutes.getPages,
      initialRoute: AppRoutes.splash,
      themeMode: helper.getTheme(),
    );
  }
}
