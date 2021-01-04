import 'package:flutter_web2/controllers/orderController.dart';

import '../authController.dart';
import 'package:get/get.dart';

class AuthBinginds extends Bindings {
  // Create Pipeline between contrller to UI
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(OrderController());
    // It will help us to load controller to Ui
  }
}
