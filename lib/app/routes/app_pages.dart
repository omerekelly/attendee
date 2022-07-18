import 'home_routes.dart';
import 'list_page_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = '/home';

  static final routes = [
    ...HomeRoutes.routes,
		...ListPageRoutes.routes,
  ];
}
