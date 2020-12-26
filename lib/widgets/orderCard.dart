import 'dart:ui';
import 'package:flutter/cupertino.dart';
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

  var mycolor = Color(0xff885566);

  OrderCard({Key key, this.uid, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (order.status) {
      case 'جاهز':
        {
          mycolor = null;
        }
        break;
      case 'واصل':
        {
          mycolor = Color(0xff8be08f);
        }
        break;

      case 'راجع':
        {
          mycolor = Color(0xffff8e7a);
        }
        break;
      case 'مؤجل':
        {
          mycolor = Color(0xfffce653);
        }
        break;
      case 'قيد الإرسال':
        {
          mycolor = Color(0xff8bc7e0);
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
        Get.to(OrderDetail(order: order));
      },
      child: Card(
        color: mycolor,
        margin: EdgeInsets.fromLTRB(10, 2.5, 10, 2.5),
        child: Container(
          margin: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    order.statusTitle,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      // color: (order.done) ? Colors.green : Colors.white
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    order.status,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      // color: (order.done) ? Colors.green : Colors.white
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    order.orderNumber,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      // color: (order.done) ? Colors.green : Colors.white
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
