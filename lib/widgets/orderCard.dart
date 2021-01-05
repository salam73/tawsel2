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
                    'تكلفة النقل :${order.deliveryCost.toString()}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                        // color: (order.done) ? Colors.green : Colors.white
                        ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'المبلغ :${order.amountAfterDelivery.toString()}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                        // color: (order.done) ? Colors.green : Colors.white
                        ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    order.statusTitle,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
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
                        color: Colors.white
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
                        color: Colors.white
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
