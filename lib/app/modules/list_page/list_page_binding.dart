import 'package:get/get.dart';

import 'list_page_controller.dart';

class ListPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListPageController>(
      ListPageController.new,
    );
  }
}
