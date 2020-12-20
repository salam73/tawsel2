import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_web2/layout/usersLayout.dart';
import 'package:flutter_web2/screens/adminScreen/sortOrderByCity.dart';
import 'package:flutter_web2/screens/adminScreen/sortOrdersByDate.dart';
import 'package:flutter_web2/screens/ordersList.dart';
import 'package:flutter_web2/screens/userList.dart';
import 'package:flutter_web2/testing/mainTest.dart';

class MainLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('company'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  Get.to(UsersLayout());
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Colors.deepOrangeAccent,
                  child: Text(
                    'عملاء',
                    style: TextStyle(
                        fontSize: (MediaQuery.of(context).size.width * 0.3) / 4,
                        color: Colors.white),
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Colors.lightBlueAccent,
                  child: Text(
                    'محافظات',
                    style: TextStyle(
                        fontSize: (MediaQuery.of(context).size.width * 0.3) / 5,
                        color: Colors.white),
                  )),
              /* RaisedButton(
                onPressed: () {
                  Get.to(UserList());
                },
                child: Text('المحلات'),
              ),
              RaisedButton(
                onPressed: () {
                  Get.to(SortOrdersByDate());
                },
                child: Text('التاريخ'),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
