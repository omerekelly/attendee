import 'package:get/get.dart';

import '../modules/list_page/list_page_binding.dart';
import '../modules/list_page/list_page_page.dart';

class ListPageRoutes {
  ListPageRoutes._();

  static const listPage = '/list-page';

  static final routes = [
    GetPage(
      name: listPage,
      page: ListPagePage.new,
      binding: ListPageBinding(),
    ),
  ];
}
