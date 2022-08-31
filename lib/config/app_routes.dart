import 'package:boilerplate/views/splash.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String splash = '/splash';

  static List<GetPage> getPages = [
    GetPage(name: splash, page: () => const SplashScreen()),
  ];
}
