import 'package:flutter_web2/controllers/authController.dart';
import 'package:flutter_web2/controllers/userController.dart';
import 'package:flutter_web2/layout/mainLayout.dart';
import 'package:flutter_web2/models/user.dart';
import 'package:flutter_web2/receivingBoy/receiveHome.dart';
import 'package:flutter_web2/screens/OrdersListByUser.dart';
import 'package:flutter_web2/screens/adminScreen/adminHome.dart';
import 'package:flutter_web2/screens/appByUser/home.dart';
import 'package:flutter_web2/screens/auth/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web2/screens/fbpage/fbpageHome.dart';
import 'package:flutter_web2/screens/fbpage/fbpageStatus.dart';
import 'package:get/get.dart';
import 'package:flutter_web2/screens/appByUser/orderInput.dart';
import 'package:flutter_web2/screens/homeAdmin.dart';
import 'package:flutter_web2/screens/ordersList.dart';
import 'package:flutter_web2/screens/userList.dart';
import 'package:flutter_web2/testing/mainTest.dart';
import 'package:flutter_web2/testing/test2.dart';

// ignore: must_be_immutable
class Root extends GetWidget<AuthController> {
  //Just For Switching to Home to Login
  UserModel userModel = UserModel();
  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
      initState: (_) async {
        Get.put<UserController>(UserController());
      },
      builder: (_) {
        if (Get.find<AuthController>().user != null) {
          // var user = Get.find<AuthController>().user;

          //    print(user['isAdmin'].toString());
          // return Home();
          // return Test2();
          // return MainLayout();
          // return MainTest();
          // return HomeAdmin();
          // return AdminHome();
          //  return ReceiveHome();
          // return FbPageStatus();
          return MainLayout();
          // return OrdersList();
          // return UserList();
          // return OrderInput(
          //     //  userId: user.uid,
          //     );
        } else {
          // return Test2();
          // return MainTest();
          // return ReceiveHome();
          // return MainLayout();
          // return MainTest();
          // return AdminHome();
          // return HomeAdmin();
          return Login();
        }
      },
    );
  }
}
