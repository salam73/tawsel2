import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_web2/controllers/orderController.dart';
import 'package:flutter_web2/models/order.dart';
import 'package:flutter_web2/screens/adminScreen/orderDetailByAdmin.dart';
import 'package:flutter_web2/screens/appByUser/home.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:flutter_web2/services/fireDb.dart';

class MainTest extends StatelessWidget {
/*   Future<Widget> getUsers() async {
    await FirebaseFirestore.instance
        .collection('users')
        .orderBy('deliveryToCity', descending: true)
        .get()
        .then((e) => {
              e.docs.map(
                (e) => Text(
                  e.data()['shopName'],
                ),
              )
            });
    return Text('hel');
  } */

  // ignore: unused_element
  _onPressed() {
    FirebaseFirestore.instance
        .collection("users")
        // .orderBy('deliveryToCity')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print('userid' + result.id);

//.set({'statusTitle': 'non'}, SetOptions(merge: true))
        FirebaseFirestore.instance
            .collection('users')
            .doc(result.id)
            .collection('orders')
            .get()
            .then((value) => {
                  value.docs.forEach((element) {
                    print('orderid' + element.id);
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(result.id)
                        .collection('orders')
                        .doc(element.id)
                        .set({'status': 'non'}, SetOptions(merge: true)).then(
                            (value) => {});
                  })
                });
      });
    });
  }

  var sumOfAmount = 0.obs;
  var orderStatus = ''.obs;
  var _value = 0.obs;

  String orderCondition = '';
  var fireDb = FireDb();

  var _listOption = ['مؤجل', 'واصل', 'راجع', 'جاهز', 'مشكلة'];

  OrderModel orderModel = OrderModel();
  OrderController orderController = Get.put(OrderController());

  void getAllAmount({String status, String sortingByName}) {
    orderStatus.value = status;
    var g = fireDb.allOrderStreamByStatus(
        status: status, sortingName: sortingByName);
    g.forEach((element) {
      int start = 0;
      element.forEach((element) {
        start = start + element.amountAfterDelivery;
        sumOfAmount.value = start;
        // print('foreach' + start.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getAllAmount(
        status: Get.find<OrderController>().orderStatus.value,
        sortingByName: Get.find<OrderController>().orderBySortingName.value);
    //_onPressed();
    // orderController.orderStatus.value = 'non';
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Column(
          children: [
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    orderStatus.toString(),
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    orderController.allOrders.length.toString(),
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //Obx(() => Text(orderController.allOrders.length.toString())),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  statusButton(
                    title: 'جاهز',
                    controller: orderController,
                    status: 'جاهز',
                  ),
                  statusButton(
                      title: 'راجع',
                      controller: orderController,
                      status: 'راجع'),
                  statusButton(
                      title: 'واصل',
                      controller: orderController,
                      status: 'واصل'),
                  statusButton(
                      title: 'مؤجل',
                      controller: orderController,
                      status: 'مؤجل'),
                  statusButton(
                      title: 'قيد التسليم',
                      controller: orderController,
                      status: 'مشكلة'),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            //جدول المعلومات
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text('Nr.'),
                    ),
                    headerTitle(
                        arbTitle: 'الرقم',
                        engTitle: 'orderNumber',
                        controller: orderController),
                    headerTitle(
                        arbTitle: 'الإسم',
                        engTitle: 'customerName',
                        controller: orderController),
                    headerTitle(
                        arbTitle: 'المحافظة',
                        engTitle: 'deliveryToCity',
                        controller: orderController),
                    headerTitle(
                        arbTitle: 'المبلغ',
                        engTitle: 'amountAfterDelivery',
                        controller: orderController),
                    headerTitle(
                        arbTitle: 'التاريخ',
                        engTitle: 'dateCreated',
                        controller: orderController),
                    orderStatus.value != 'تمت'
                        ? Expanded(
                            child: Text('الحالة'),
                          )
                        : Container()
                  ],
                )),
            Divider(
              thickness: 1,
              color: Colors.black,
            ),
            SizedBox(
              height: 10,
            ),
            GetX<OrderController>(
              // init: Get.put(OrderController()),
              builder: (OrderController orderController) {
                // orderController.sumAmount.value = 0;
                if (orderController != null &&
                    orderController.allOrders != null) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: orderController.allOrders.length,
                      itemBuilder: (_, index) {
                        orderController.sumAmount.value =
                            orderController.sumAmount.value +
                                orderController
                                    .allOrders[index].amountAfterDelivery;

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Text(
                                    (index + 1).toString(),
                                  ),
                                ),
                                Expanded(
                                    child: InkWell(
                                  onTap: () {
                                    Get.to(OrderDetailByAdmin(
                                      orderId: orderController
                                          .allOrders[index].orderId,
                                      userId: orderController
                                          .allOrders[index].byUserId,
                                    ));
                                  },
                                  child: Text(orderController
                                      .allOrders[index].orderNumber),
                                )),
                                Expanded(
                                    child: Text(orderController
                                        .allOrders[index].customerName)),
                                Expanded(
                                    child: Text(orderController
                                        .allOrders[index].deliveryToCity)),
                                Expanded(
                                    child: Text(orderController
                                        .allOrders[index].amountAfterDelivery
                                        .toString())),
                                Expanded(
                                  child: Text(
                                    DateFormat('yyyy-MM-dd').format(
                                        orderController
                                            .allOrders[index].dateCreated
                                            .toDate()),
                                  ),
                                ),
                                Expanded(
                                    child: InkWell(
                                  onTap: () {
                                    print(orderController
                                        .allOrders[index].orderId);
                                    print(orderStatus);
                                    print(_value.value);

                                    Get.defaultDialog(

                                        //confirm: Text('ok'),
                                        textConfirm: 'ok',
                                        confirmTextColor: Colors.white,
                                        onConfirm: () {
                                          orderModel =
                                              orderController.allOrders[index];
                                          orderModel.status =
                                              _listOption[_value.value];

                                          FireDb().updateOrder2(
                                              order: orderModel,
                                              uid: orderController
                                                  .allOrders[index].orderId);
                                          print(_listOption[_value.value]);
                                          Get.back();
                                        },
                                        title:
                                            'نغير حالة الطلب :${orderController.allOrders[index].orderNumber}',
                                        content: Column(
                                          children: <Widget>[
                                            for (int i = 0; i < 5; i++)
                                              ListTile(
                                                title: Text(
                                                  _listOption[i],
                                                ),
                                                leading: Obx(() => Radio(
                                                      value: i,
                                                      groupValue: _value.value,
                                                      activeColor:
                                                          Color(0xFF6200EE),
                                                      onChanged: (value) {
                                                        _value.value = value;

                                                        print(_value);
                                                      },
                                                    )),
                                              ),
                                          ],
                                        ),
                                        middleText: orderController
                                            .allOrders[index].orderId);
                                  },
                                  child: Text(orderController
                                      .allOrders[index].statusTitle),
                                ))
                              ],
                            ),
                            Divider(
                              thickness: 2,
                            ),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        value: 10,
                      ),
                    ),
                  );
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('المجموع: '),
                Obx(() => Text(sumOfAmount.value.toString())),
              ],
            ),
            SizedBox(
              height: 30,
            ),
          ],
        )),
      ),
    );
  }

  Widget statusButton({
    String title,
    OrderController controller,
    String status,
  }) {
    return RaisedButton(
      child: Text(title),
      onPressed: () {
        controller.orderStatus.value = status;

        controller.streamStatus(status: status);
        getAllAmount(status: status);
      },
    );
  }

  Widget headerTitle({
    String arbTitle,
    String engTitle,
    OrderController controller,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          controller.orderBySortingName.value = engTitle;
          getAllAmount(
              sortingByName: engTitle,
              status: orderController.orderStatus.value);
          controller.streamStatus(
              orderByName: engTitle, status: orderController.orderStatus.value);
        },
        child: Text(arbTitle),
      ),
    );
  }
}
