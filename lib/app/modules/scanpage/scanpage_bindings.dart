import 'package:get/get.dart';
import './scanpage_controller.dart';

class ScanpageBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(ScanpageController());
    }
}