import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:google_fonts/google_fonts.dart';

import '../../models/order.dart';

class FbPageHome extends StatelessWidget {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find();
  var myStatus = 'جاهز'.obs;
  int getAmount(List<QueryDocumentSnapshot> list) {
    int start = 0;
    list.forEach((element) {
      start = start + element['amountAfterDelivery'];
    });
    return start;
  }

  int getDeliveryCost(List<QueryDocumentSnapshot> list) {
    int start = 0;
    list.forEach((element) {
      start = start + element['deliveryCost'];
    });
    return start;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
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
          title: Obx(
            () => Text(
              '${myStatus.value}',
              style: GoogleFonts.cairo(),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            // OrderAlert().addOrderDialog();
            Get.to(OrderInput());
          },
        ),
        body: Center(
          child: Container(
            child: Obx(
              () => StreamBuilder(
                stream: _firestore
                    .collection('orders')
                    .where('byUserId', isEqualTo: _authController.user.uid)
                    .where('status', isEqualTo: myStatus.value)
                    .snapshots(),
                builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Obx(
                          () => Text(
                              '${myStatus.value}: ${snapshot.data.docs.length}'),
                        ),
                        Wrap(
                          children: [
                            statusButton(title: 'جاهز', color: Colors.blue),
                            statusButton(
                                title: 'تم الإستلام', color: Colors.grey),
                            statusButton(title: 'راجع', color: Colors.red),
                            statusButton(title: 'مؤجل', color: Colors.purple),
                            statusButton(
                                title: 'قيد التوصيل', color: Colors.amber),
                            statusButton(
                                title: 'واصل', color: Colors.greenAccent),
                            statusButton(
                                title: 'تم الدفع', color: Colors.green),
                          ],
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (_, index) {
                              if (snapshot.data.docs.length > 0)
                                return Card(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          (index + 1).toString(),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            buttonTitle(
                                                list: snapshot.data.docs,
                                                index: index,
                                                title: 'customerName'),
                                            buttonTitle(
                                                list: snapshot.data.docs,
                                                index: index,
                                                title: 'customerAddress'),
                                            buttonTitle(
                                                list: snapshot.data.docs,
                                                index: index,
                                                title: 'deliveryToCity'),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            buttonTitle(
                                                list: snapshot.data.docs,
                                                index: index,
                                                title: 'customerPhone'),
                                            buttonTitle(
                                                list: snapshot.data.docs,
                                                index: index,
                                                title: 'orderType'),
                                            buttonTitle(
                                                list: snapshot.data.docs,
                                                index: index,
                                                title: 'commit'),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            buttonTitle(
                                                list: snapshot.data.docs,
                                                index: index,
                                                title: 'amountAfterDelivery'),
                                            buttonTitle(
                                                list: snapshot.data.docs,
                                                index: index,
                                                title: 'deliveryCost'),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            buttonTitle(
                                                list: snapshot.data.docs,
                                                index: index,
                                                title: 'status'),
                                            buttonTitle(
                                                list: snapshot.data.docs,
                                                index: index,
                                                title: 'statusTitle'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              return Text('noDataa');
                            },
                          ),
                        ),
                        Column(
                          children: [
                            Text(getAmount(snapshot.data.docs).toString()),
                            Text(
                                getDeliveryCost(snapshot.data.docs).toString()),
                          ],
                        )
                      ],
                    );
                  }

                  return Text('noData');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonTitle(
      {List<QueryDocumentSnapshot> list, int index, String title}) {
    return Container(
      child: Text(
        list[index][title].toString(),
      ),
      // alignment: Alignment.centerRight,
    );
  }

  Widget statusButton({String title, Color color}) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: RaisedButton(
        color: color,
        onPressed: () {
          myStatus.value = title;
        },
        child: Text(title, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
