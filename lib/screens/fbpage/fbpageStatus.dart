import 'package:flutter/widgets.dart';
import 'package:flutter_web2/controllers/authController.dart';
import 'package:flutter_web2/controllers/themeController.dart';
import 'package:flutter_web2/controllers/orderController.dart';
import 'package:flutter_web2/controllers/userController.dart';
import 'package:flutter_web2/models/user.dart';
import 'package:flutter_web2/screens/appByUser/orderInput.dart';
import 'package:flutter_web2/screens/auth/login.dart';
import 'package:flutter_web2/screens/delivery/deliveryAdmin.dart';
import 'package:flutter_web2/screens/delivery/deliveryHome.dart';
import 'package:flutter_web2/screens/fbpage/fbpageHome.dart';
import 'package:flutter_web2/services/fireDb.dart';
import 'package:flutter_web2/widgets/orderCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_web2/widgets/orderAlert.dart';

class FbPageStatus extends StatelessWidget {
  //
  final ThemeController _themeController = Get.put(ThemeController());

  OrderController orderController = Get.put(OrderController());

  var listStatusTitle = [
    'جاهز',
    'تم الإستلام',
    'واصل',
    'راجع',
    'مؤجل',
    'قيد التوصيل'
  ];

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

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "مرحبا",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: listStatusTitle.length,
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(FbPageHome(
                        myStatus: listStatusTitle[index],
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Container(
                        color: Colors.lightBlue,
                        child: Text(
                          listStatusTitle[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }),
          )

          //  Obx(() => Text('subtitle' + allAmount.toString() ?? ''))
        ],
      ),
    );
  }
}
