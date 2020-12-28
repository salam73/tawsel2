import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web2/controllers/authController.dart';
import 'package:flutter_web2/controllers/userController.dart';
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
  var orderStatusOBX = ''.obs;
  var headerStatusOBX = ''.obs;
  var orderTitleStatusOBX = ''.obs;
  var _valueOBX = 0.obs;

  var fireDb = FireDb();

  var _listOption = ['تم التسليم', 'واصل', 'راجع', 'مؤجل', 'قيد التوصيل'];

  OrderModel orderModel = OrderModel();
  OrderController orderController = Get.put(OrderController());
  var statusTitleController = TextEditingController();
  var deliveryCostController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(Get.find<UserController>().currentUser.value),
        ),
        body: Center(
            child: Column(
          children: [
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    orderController.orderStatus.toString(),
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
                    title: 'تم التسليم',
                    controller: orderController,
                    status: 'تم التسليم',
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
                      title: 'قيد التوصيل',
                      controller: orderController,
                      status: 'قيد التوصيل'),
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
                    arbTitle: 'النقل',
                    engTitle: 'deliveryCost',
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
              init: Get.put(OrderController()),
              builder: (OrderController orderController) {
                // orderController.sumAmount.value = 0;
                if (orderController != null &&
                    orderController.allOrders != null) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: orderController.allOrders.length,
                      itemBuilder: (_, index) {
                        // orderController.sumAmount.value =
                        //     orderController.sumAmount.value +
                        //         orderController
                        //             .allOrders[index].amountAfterDelivery;

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
                                    child: InkWell(
                                  onTap: () {
                                    Get.defaultDialog(
                                        textCancel: 'إلغاء',
                                        onCancel: null,
                                        textConfirm: 'ok',
                                        confirmTextColor: Colors.white,
                                        onConfirm: () {
                                          orderModel =
                                              orderController.allOrders[index];

                                          orderModel.deliveryCost = int.parse(
                                              deliveryCostController.text);

                                          // statusTitleController.text

                                          FireDb().updateOrder2(
                                              order: orderModel,
                                              clientId: orderController
                                                  .clientId.value,
                                              uid: orderController
                                                  .allOrders[index].orderId);

                                          /*orderController.streamStatus(
                                              status: orderController
                                                  .orderStatus.value,
                                              orderByName: orderController
                                                  .orderBySortingName.value,
                                              clientId: orderController
                                                  .clientId.value);*/
                                          /*  getAllAmount(
                                              status: orderController
                                                  .orderStatus.value,
                                              sortingByName: orderController
                                                  .orderBySortingName.value);*/

                                          // print(_listOption[_valueOBX.value]);
                                          Get.back();
                                        },
                                        title:
                                            'تغير سعر النقل ${orderController.allOrders[index].orderNumber} إلى ',
                                        content: TextField(
                                          controller: deliveryCostController,
                                        ));
                                  },
                                  child: Text(orderController
                                      .allOrders[index].deliveryCost
                                      .toString()),
                                )),
                                Expanded(
                                  child: Text(
                                    DateFormat('yyyy-MM-dd').format(
                                        orderController
                                            .allOrders[index].dateCreated
                                            .toDate()),
                                  ),
                                ),

                                // هنا قسم الحالة وعن طريقة يمكن تغير الحاله
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

                                          print('clinetid ' +
                                              orderController.clientId.value);

                                          FireDb().updateOrder2(
                                              order: orderModel,
                                              clientId: orderController
                                                  .clientId.value,
                                              uid: orderController
                                                  .allOrders[index].orderId);

                                          /* orderController.streamStatus(
                                              status: orderController
                                                  .orderStatus.value,
                                              orderByName: orderController
                                                  .orderBySortingName.value,
                                              clientId: orderController
                                                  .clientId.value);*/
                                          /*  getAllAmount(
                                              status: orderController
                                                  .orderStatus.value,
                                              sortingByName: orderController
                                                  .orderBySortingName.value);*/

                                          print(_listOption[_valueOBX.value]);
                                          Get.back();
                                        },
                                        title:
                                            'تغير حالة الطلب ${orderController.allOrders[index].orderNumber} إلى :',
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
                                            Obx(
                                              () => orderStatusOBX.value ==
                                                          'واصل' ||
                                                      orderStatusOBX.value ==
                                                          'تم التسليم'
                                                  ? Container()
                                                  : TextField(
                                                      controller:
                                                          statusTitleController,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            orderTitleStatusOBX
                                                                .value,
                                                        labelStyle: TextStyle(
                                                            fontSize: 14),
                                                        hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                            )
                                          ],
                                        ),
                                        middleText: orderController
                                            .allOrders[index].orderId);
                                  },
                                  child: Container(
                                    child: Text(orderController
                                        .allOrders[index].statusTitle),
                                    color: Colors.lightBlueAccent,
                                  ),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('المجموع: '),
                Obx(
                  () => Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      orderController.getAllAmount().toString(),
                    ),
                  ),
                ),
                Text('النقل: '),
                Obx(() => Text(orderController.getDeliveryCost().toString())),
                Text('الباقي: '),
                Obx(
                  () => Text(
                    (orderController.getAllAmount() -
                            orderController.getDeliveryCost())
                        .toString(),
                  ),
                ),
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(title),
      ),
      onPressed: () {
        controller.orderStatus.value = status;
        // orderStatus.value = status;

        controller.streamStatus(
            status: status, clientId: orderController.clientId.value);
        /*  getAllAmount(status: status);*/
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

          controller.streamStatus(
              orderByName: engTitle,
              status: controller.orderStatus.value,
              clientId: controller.clientId.value);
        },
        child: Text(arbTitle),
      ),
    );
  }
}
