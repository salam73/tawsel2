import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web2/controllers/orderController.dart';
import 'package:flutter_web2/controllers/userController.dart';
import 'package:flutter_web2/receivingBoy/receivedOrderList.dart';
import 'package:flutter_web2/services/fireDb.dart';
import 'package:get/get.dart';
import 'dart:ui';

class ReceiveHome extends StatelessWidget {
  OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('أسماء الشركات'),
        centerTitle: true,
      ),
      body: Center(
        child: Center(
          child: StreamBuilder(
              stream: FireDb().getUserList(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return Wrap(
                  // direction: Axis.vertical,
                  children: snapshot.data.docs.map((e) {
                    return InkWell(
                      onTap: () {
                        print('user id : ' + e.id.toString());
                        //  print('order id : ' + orderController..toString());

                        orderController.clientId.value = e.id;
                        orderController.orderStatus.value = 'جاهز';

                        Get.find<UserController>().currentUser.value =
                            e['name'];

                        Get.to(ReceivedOrderList());
                      },
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Container(
                          // alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.29,
                          height: MediaQuery.of(context).size.height * 0.25,
                          color: Colors.amberAccent,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '${e['name']}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '${e['shopName']}',
                                    style: TextStyle(fontSize: 20),
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
      ),
    );
  }
}
