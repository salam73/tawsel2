import 'package:flutter_web2/controllers/authController.dart';
import 'package:flutter_web2/models/deliveryBoy.dart';
import 'package:flutter_web2/models/user.dart';
import 'package:flutter_web2/services/fireDb.dart';
import 'package:get/get.dart';

class DeliveryBoyController extends GetxController {
  // Rx<UserModel> userModel = UserModel().obs; //Observable
  Rx<DeliveryBoyModel> deliveryBoyModel = DeliveryBoyModel().obs; //Observable

  // var currentUser = ''.obs;
  var currentDeliveryBoy = ''.obs;

//Getter

  // UserModel get user => userModel.value;
  DeliveryBoyModel get deliveryBoy => deliveryBoyModel.value;

//Setter
//   set user(UserModel userVal) => this.userModel.value = userVal;
  set deliveryBoy(DeliveryBoyModel userVal) =>
      this.deliveryBoyModel.value = userVal;

  getDeliveryBoy() async {
    var fireUser = Get.find<AuthController>().user;
    if (fireUser != null) {
      this.deliveryBoy = await FireDb().getDeliveryBoy(uid: fireUser.uid);
      //this._userModel.value = await FireDb().getUser(fireuser.uid);
    }
  }

//ClearModal
  void clear() {
    // userModel.value = UserModel();
    deliveryBoyModel.value = DeliveryBoyModel();
  }
}
