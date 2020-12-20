import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

// ignore: must_be_immutable
class UsersLayout extends StatelessWidget {
  // var userList = FireDb().getUsers();

  final OrderController orderController = Get.put(OrderController());
  final AuthController _authController = Get.find();
  final ThemeController _themeController = Get.put(ThemeController());

  final UserModel userModel = Get.put(UserModel());
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Obx(
          //   () => IconButton(
          //     icon: getLightIcon(),
          //     onPressed: () {
          //       if (Get.isDarkMode) {
          //         Get.changeTheme(ThemeData.light());
          //         _themeController.themeChange = false;
          //       } else {
          //         Get.changeTheme(ThemeData.dark());
          //         _themeController.themeChange = true;
          //       }
          //     },
          //   ),
          // ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _authController.logOut();
            },
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder(
            stream: FireDb().getUserList(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return Wrap(
                direction: Axis.vertical,
                children: snapshot.data.docs.map((e) {
                  return InkWell(
                    onTap: () {
                      // orderController.userId = 'ePVan9xf2YNpIiPPWkGgdF3wwf62';

                      //  print(userModel.name);
                      // e['isAdmin']
                      //     ? Get.to(HomeAdmin(
                      //         userId: e.id,
                      //       ))
                      //     : Get.to(OrdersListByUser(
                      //         userId: e.id,
                      //       ));
                      // Get.to(OrdersListByUser(
                      // //  userId: e.id,
                      // ));
                      print(e.id.toString());
                      Get.to(MainTest());
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Container(
                        // alignment: Alignment.center,
                        height: 140,
                        color: Colors.amberAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${e['name']}',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${e['shopName']}',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}
