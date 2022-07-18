import 'package:get/get.dart';

import 'scanning_page_controller.dart';

class ScanningPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanningPageController>(
      ScanningPageController.new,
    );
  }
}
