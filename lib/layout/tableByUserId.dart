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

// ignore: must_be_immutable
class TableByUserId extends StatelessWidget {
  var sumOfAmountOBX = 0.obs;
  var orderStatusOBX = ''.obs;
  var headerStatusOBX = ''.obs;
  var orderTitleStatusOBX = ''.obs;
  var _valueOBX = 0.obs;

  String orderCondition = '';
  var fireDb = FireDb();

  var _listOption = ['واصل', 'راجع', 'مؤجل', 'قيد الإرسال'];

  OrderModel orderModel = OrderModel();
  OrderController orderController = Get.put(OrderController());
  var statusTitleController = TextEditingController();

  void getAllAmount({String status, String sortingByName}) {
    headerStatusOBX.value = status;
    sumOfAmountOBX.value = 0;
    int start = 0;
    var g = fireDb.allOrderStreamByStatus(
        status: status,
        sortingName: sortingByName,
        clientId: orderController.clientId.value);
    g.forEach((element) {
      element.forEach((element) {
        start = start + element.amountAfterDelivery;
        sumOfAmountOBX.value = start;
        // print('foreach' + start.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // orderController.clientId.value = clientId;
    orderController.streamStatus(
        status: orderController.orderStatus.value,
        orderByName: orderController.orderBySortingName.value,
        clientId: orderController.clientId.value);
    getAllAmount(
        status: orderController.orderStatus.value,
        sortingByName: orderController.orderBySortingName.value);
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
                    headerStatusOBX.toString(),
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
                      title: 'واصل',
                      controller: orderController,
                      status: 'واصل'),
                  statusButton(
                      title: 'راجع',
                      controller: orderController,
                      status: 'راجع'),
                  statusButton(
                      title: 'مؤجل',
                      controller: orderController,
                      status: 'مؤجل'),
                  statusButton(
                      title: 'قيد الإرسال',
                      controller: orderController,
                      status: 'قيد الإرسال'),
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

            Row(
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
                Expanded(
                  child: Text('الحالة'),
                )
              ],
            ),
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
                                    // print(orderController
                                    //     .allOrders[index].orderId);
                                    // print(orderStatusOBX);
                                    // print(_valueOBX.value);
                                    // print('orderTitleStatusOBX ' +
                                    //     orderTitleStatusOBX.value);

                                    _valueOBX.value = 0;
                                    orderTitleStatusOBX.value = '';
                                    statusTitleController.text = '';
                                    orderStatusOBX.value = 'واصل';

                                    Get.defaultDialog(

                                        //confirm: Text('ok'),
                                        textCancel: 'إلغاء',
                                        onCancel: null,
                                        textConfirm: 'ok',
                                        confirmTextColor: Colors.white,
                                        onConfirm: () {
                                          orderModel =
                                              orderController.allOrders[index];
                                          orderModel.status =
                                              _listOption[_valueOBX.value];
                                          orderModel.statusTitle =
                                              statusTitleController.text;

                                          // statusTitleController.text

                                          FireDb().updateOrder2(
                                              orderModel,
                                              orderController
                                                  .allOrders[index].orderId);

                                          orderController.streamStatus(
                                              status: orderController
                                                  .orderStatus.value,
                                              orderByName: orderController
                                                  .orderBySortingName.value,
                                              clientId: orderController
                                                  .clientId.value);

                                          print(_listOption[_valueOBX.value]);
                                          Get.back();
                                        },
                                        title:
                                            'تغير حالة الطلب إلى :${orderController.allOrders[index].orderNumber}',
                                        content: Column(
                                          children: <Widget>[
                                            for (int i = 0;
                                                i < _listOption.length;
                                                i++)
                                              ListTile(
                                                title: Text(
                                                  _listOption[i],
                                                ),
                                                leading: Obx(() => Radio(
                                                      value: i,
                                                      groupValue:
                                                          _valueOBX.value,
                                                      activeColor:
                                                          Color(0xFF6200EE),
                                                      onChanged: (value) {
                                                        _valueOBX.value = value;
                                                        // orderStatus.value =
                                                        //     _listOption[value];
                                                        orderTitleStatusOBX
                                                                .value =
                                                            _listOption[value];
                                                        orderStatusOBX.value =
                                                            _listOption[value];
                                                        // statusTitleController.text= _listOption[value];

                                                        print(_valueOBX);
                                                        print(
                                                            'orderStatusOBX.value' +
                                                                orderStatusOBX
                                                                    .value);
                                                      },
                                                    )),
                                              ),
                                            Obx(() => orderStatusOBX.value !=
                                                    'واصل'
                                                ? TextField(
                                                    controller:
                                                        statusTitleController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          orderTitleStatusOBX
                                                              .value,
                                                      labelStyle: TextStyle(
                                                          fontSize: 14),
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10),
                                                    ),
                                                  )
                                                : Container())
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
                Obx(() => Text(sumOfAmountOBX.value.toString())),
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
        // orderStatus.value = status;

        controller.streamStatus(
            status: status, clientId: orderController.clientId.value);
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
              orderByName: engTitle,
              status: orderController.orderStatus.value,
              clientId: orderController.clientId.value);
        },
        child: Text(arbTitle),
      ),
    );
  }
}
