import 'package:flutter_web2/controllers/authController.dart';
import 'package:flutter_web2/controllers/themeController.dart';
import 'package:flutter_web2/controllers/orderController.dart';
import 'package:flutter_web2/controllers/userController.dart';
import 'package:flutter_web2/models/user.dart';
import 'package:flutter_web2/screens/appByUser/orderInput.dart';
import 'package:flutter_web2/screens/auth/login.dart';
import 'package:flutter_web2/screens/delivery/deliveryAdmin.dart';
import 'package:flutter_web2/screens/delivery/deliveryHome.dart';
import 'package:flutter_web2/services/fireDb.dart';
import 'package:flutter_web2/widgets/orderCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_web2/widgets/orderAlert.dart';

class FbPageHome extends StatelessWidget {
  final AuthController _authController = Get.find();
  final UserController userModel = Get.find();
  //
  final ThemeController _themeController = Get.put(ThemeController());
  OrderController orderController = Get.put(OrderController());

  var allAmount = 0.obs;

  final String myStatus;

  FbPageHome({Key key, this.myStatus}) : super(key: key);

  getLightIcon() {
    if (_themeController.themeChange) {
      return Icon(Icons.lightbulb);
    } else {
      return Icon(Icons.lightbulb_outline);
    }
  }

  getUserName() {
    return GetX<UserController>(
      init: Get.put(UserController()),
      initState: (_) async {
        Get.find<UserController>().user =
            await FireDb().getUser(uid: Get.find<AuthController>().user.uid);
      },
      builder: (_userController) {
        return Text((_userController.user == null)
            ? ""
            : _userController.user.name.toString());
      },
    );
  }

  void updateLayout({String status}) {
    orderController.streamStatus(status: status, clientId: userModel.user.id);
  }

  @override
  Widget build(BuildContext context) {
    print(myStatus);
    updateLayout(status: myStatus);

    return Scaffold(
      appBar: AppBar(
        title: getUserName(),
        centerTitle: true,
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
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _authController.logOut();
              // Get.to(Login());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // OrderAlert().addOrderDialog();
          Get.to(OrderInput());
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            myStatus,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          GetX<OrderController>(
            init: Get.put<OrderController>(OrderController()),
            builder: (OrderController orderController) {
              if (orderController != null &&
                  orderController.allOrders != null) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: orderController.allOrders.length,
                    itemBuilder: (_, index) {
                      return OrderCard(
                          uid: _authController.user.uid,
                          order: orderController.allOrders[index]);
                    },
                  ),
                );
              } else {
                return Container(
                    child: Center(
                        child: CircularProgressIndicator(
                  value: 10,
                )));
              }
            },
          ),
          //  Obx(() => Text('subtitle' + allAmount.toString() ?? ''))
        ],
      ),
    );
  }
}
