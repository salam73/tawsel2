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
    return Dismissible(
      key: Key(order.orderId),
      background: Container(
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(Icons.edit),
              ),
            ],
          )),
      secondaryBackground: Container(
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.delete),
              ),
            ],
          )),
      direction: DismissDirection.horizontal,
      dragStartBehavior: DragStartBehavior.start,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          OrderAlert().editOrderDialog(order);
          return false;
        } else {
          return true;
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          FireDb().deleteOrder(order, uid);
        }
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 2.5, 10, 2.5),
        child: Container(
          margin: EdgeInsets.all(5),
          child: ListTile(
            leading: Checkbox(
              value: order.done,
              onChanged: (newValue) {
                order.done = newValue;
                FireDb().updateOrder(
                  order,
                  uid,
                );
              },
            ),
            title: InkWell(
              onTap: () {
                //OrderAlert().editOrderDialog(order);
                Get.to(OrderDetail(orderId: order.orderId));
              },
              child: Row(
                children: [
                  Text(
                    order.orderNumber,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: (order.done) ? Colors.green : Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
