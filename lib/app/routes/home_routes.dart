import 'package:get/get.dart';

import '../modules/home/home_binding.dart';
import '../modules/home/home_page.dart';
import '../modules/home/scanning_page/scanning_page_binding.dart';
import '../modules/home/scanning_page/scanning_page_page.dart';

class HomeRoutes {
  HomeRoutes._();

  static const home = '/home';
	static const homeScanningPage = '/home/scanning-page';

  static final routes = [
    GetPage(
      name: home,
      page: HomePage.new,
      binding: HomeBinding(),
    ),
		GetPage(
      name: homeScanningPage,
      page: ScanningPagePage.new,
      binding: ScanningPageBinding(),
    ),
  ];
}
