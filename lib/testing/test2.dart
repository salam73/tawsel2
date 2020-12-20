import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_web2/controllers/orderController.dart';

class Test2 extends StatelessWidget {
  OrderController status = Get.put(OrderController());
  @override
  Widget build(BuildContext context) {
    // status.orderStatus.value = 'hello';
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Obx(
        () => Column(
          children: [
            Container(
              child: Text(status.orderStatus.value),
            ),
            RaisedButton(
              child: Text('ok'),
              onPressed: () {
                status.orderStatus.value = 'hello';
              },
            ),
            RaisedButton(
              child: Text('ok'),
              onPressed: () {
                status.orderStatus.value = 'salam';
              },
            ),
          ],
        ),
      ),
    );
  }
}
