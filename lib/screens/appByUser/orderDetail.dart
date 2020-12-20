import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web2/controllers/authController.dart';
import 'package:get/get.dart';
import 'package:flutter_web2/services/fireDb.dart';

class OrderDetail extends StatelessWidget {
  final AuthController _authController = Get.find();

  final String orderId;

  OrderDetail({
    this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('order detail'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                // initialData: FireDb().getOrder(uid: _authController.user.uid, orderId:orderId ),
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(_authController.user.uid)
                    .collection('orders')
                    .doc(orderId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  print('orderId :' + snapshot.data.id);
                  print('orderId2 :' + orderId);
                  return Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "التفاصيل",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      orderDetialText(
                          'رقم الاورد', snapshot.data['orderNumber']),
                      // orderDetialText('إسم المتجر', snapshot.data['shopName']),
                      // orderDetialText(
                      //     'المدينة', snapshot.data['deliveryToCity'] ?? ''),
                      //   orderDetialText(
                      //       'رقم الوكيل', snapshot.data['clientPhone'] ?? ''),

                      orderDetialText(
                          'إسم الزبون', snapshot.data['customerName'] ?? ''),
                      orderDetialText('عنوان الزبون',
                          snapshot.data['customerAddress'] ?? ''),
                      orderDetialText('تم الإستلام',
                          snapshot.data['isPickup'] ? 'نعم' : 'لا'),
                      orderDetialText(
                          'تم التوصيل', snapshot.data['done'] ? 'نعم' : 'لا'),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding orderDetialText(String name, String detailName) {
    return Padding(
      padding: EdgeInsets.only(right: 18.0),
      child: Container(
        alignment: Alignment.centerRight,
        child: Text(
          '$name: $detailName',
          style: TextStyle(fontSize: 27),
        ),
      ),
    );
  }
}
