import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter_web2/models/order.dart';
import 'package:flutter_web2/screens/appByUser/orderDetail.dart';
import 'package:flutter_web2/services/fireDb.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web2/widgets/orderAlert.dart';

class OrderCard extends StatelessWidget {
  final String uid;
  final OrderModel order;

  const OrderCard({Key key, this.uid, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(OrderDetail(order: order));
      },
      child: Card(
        color: Colors.green,
        margin: EdgeInsets.fromLTRB(10, 2.5, 10, 2.5),
        child: Container(
          margin: EdgeInsets.all(5),
          child: ListTile(
            leading: Text(order.status),
            title: Row(
              children: [
                Text(
                  order.orderNumber,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                     // color: (order.done) ? Colors.green : Colors.white
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
