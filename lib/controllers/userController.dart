import 'package:flutter_web2/controllers/authController.dart';
import 'package:flutter_web2/models/user.dart';
import 'package:flutter_web2/services/fireDb.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Rx<UserModel> _userModel = UserModel().obs; //Observable

//Getter

  UserModel get user => _userModel.value;

//Setter
  set user(UserModel userVal) => this._userModel.value = userVal;

  getUser() async {
    var fireuser = Get.find<AuthController>().user;
    if (fireuser != null) {
      this.user = await FireDb().getUser(uid: fireuser.uid);
      //this._userModel.value = await FireDb().getUser(fireuser.uid);
    }
  }

//ClearModal
  void clear() {
    _userModel.value = UserModel();
  }
}
