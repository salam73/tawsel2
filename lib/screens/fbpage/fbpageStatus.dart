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
  final AuthController _authController = Get.find();
  var mycolor = Color(0xff885566);

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
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _authController.logOut();
              // Get.to(Login());
            },
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
                  switch (listStatusTitle[index]) {
                    case 'جاهز':
                      {
                        mycolor = Color(0xff808080);
                      }
                      break;
                    case 'واصل':
                      {
                        mycolor = Color(0xff2a6e2e);
                      }
                      break;

                    case 'راجع':
                      {
                        mycolor = Color(0xff7a2a2a);
                      }
                      break;
                    case 'مؤجل':
                      {
                        mycolor = Color(0xffada92b);
                      }
                      break;
                    case 'قيد التوصيل':
                      {
                        mycolor = Color(0xff2b50ad);
                      }
                      break;
                    case 'تم الإستلام':
                      {
                        mycolor = Color(0xff2b8dad);
                      }
                      break;

                    default:
                      {
                        //statements;
                      }
                      break;
                  }
                  return InkWell(
                    onTap: () {
                      Get.to(FbPageHome(
                        myStatus: listStatusTitle[index],
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        constraints:
                            BoxConstraints(minWidth: 100, maxWidth: 200),
                        // padding: EdgeInsets.all(38),
                        //  color: Colors.lightBlue,
                        decoration: BoxDecoration(
                          color: mycolor,
                          // border: Border.all(
                          //     width: 2,
                          //     color: Colors.blue,
                          //     style: BorderStyle.solid),
                          // borderRadius: BorderRadius.all(
                          //   Radius.circular(15),
                          // ),
                          shape: BoxShape.rectangle,
                        ),
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
