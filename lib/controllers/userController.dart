import 'package:flutter_web2/controllers/authController.dart';
import 'package:flutter_web2/models/user.dart';
import 'package:flutter_web2/services/fireDb.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Rx<UserModel> userModel = UserModel().obs; //Observable

  var currentUser = ''.obs;

//Getter

  UserModel get user => userModel.value;

//Setter
  set user(UserModel userVal) => this.userModel.value = userVal;

  getUser() async {
    var fireUser = Get.find<AuthController>().user;
    if (fireUser != null) {
      this.user = await FireDb().getUser(uid: fireUser.uid);
      //this._userModel.value = await FireDb().getUser(fireuser.uid);
    }
  }

//ClearModal
  void clear() {
    userModel.value = UserModel();
  }
}
