import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web2/layout/tableByProvinceId.dart';
import 'package:flutter_web2/layout/tableByUserId.dart';
import 'package:get/get.dart';
import 'package:flutter_web2/controllers/authController.dart';
import 'package:flutter_web2/controllers/orderController.dart';
import 'package:flutter_web2/controllers/themeController.dart';
import 'package:flutter_web2/controllers/userController.dart';
import 'package:flutter_web2/models/order.dart';
import 'package:flutter_web2/models/user.dart';
import 'package:flutter_web2/screens/adminScreen/adminHome.dart';
import 'package:flutter_web2/screens/adminScreen/orderInputByAdmin.dart';
import 'package:flutter_web2/screens/appByUser/home.dart';
import 'package:flutter_web2/screens/homeAdmin.dart';
import 'package:flutter_web2/services/fireDb.dart';
// import 'flutter_web2/tutorial/getOrderList.dart';
import 'package:flutter_web2/screens/OrdersListByUser.dart';
import 'package:flutter_web2/testing/mainTest.dart';

import '../screens/adminScreen/orderInputByAdmin.dart';
import '../screens/adminScreen/orderInputByAdmin.dart';

// ignore: must_be_immutable
class ProvincesLayout extends StatelessWidget {
  // var userList = FireDb().getUsers();

  final OrderController orderController = Get.put(OrderController());
  // final AuthController _authController = Get.find();
  final ThemeController _themeController = Get.put(ThemeController());

  // final UserModel userModel = Get.put(UserModel());
  getLightIcon() {
    if (_themeController.themeChange) {
      return Icon(Icons.lightbulb);
    } else {
      return Icon(Icons.lightbulb_outline);
    }
  }

  getUserName() {
    // return GetX<UserController>(
    //   init: Get.put(UserController()),
    //   initState: (_) async {
    //     Get.find<UserController>().user =
    //         await FireDb().getUser(uid: Get.find<AuthController>().user.uid);
    //   },
    //   builder: (_userController) {
    //     return Text((_userController.user == null)
    //         ? ""
    //         : _userController.user.name.toString());
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Obx(
              () => IconButton(
                icon: getLightIcon(),
                onPressed: () {
                  if (Get.isDarkMode) {
                    Get.changeTheme(ThemeData.light());
                    _themeController.themeChange = false;
                  } else {
                    Get.changeTheme(ThemeData.dark());
                    _themeController.themeChange = true;
                  }
                },
              ),
            ),
          ],
        ),
        body: Center(
          child: ListView.builder(
            itemCount: OrderInputByAdmin().country.length,
            itemBuilder: (_, index) {
              orderController.streamOrdersByProvince(
                  deliveryToCity: OrderInputByAdmin().country[index]);
              return InkWell(
                onTap: () {
                  orderController.deliveryToCity.value =
                      OrderInputByAdmin().country[index];
                  Get.to(TableByProvinceId());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    // padding: EdgeInsets.all(8.0),
                    constraints: BoxConstraints(minWidth: 100),
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: Text(
                      OrderInputByAdmin().country[index],
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
