import 'package:flutter/material.dart';
import 'package:flutter_web2/controllers/orderController.dart';
import 'package:flutter_web2/controllers/userController.dart';
import 'package:flutter_web2/models/order.dart';
import 'package:flutter_web2/models/user.dart';
import 'package:flutter_web2/services/fireDb.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'dart:ui' as ui;

class ReceivedOrderList extends StatelessWidget {
  var sumOfAmountOBX = 0.obs;
  var sumOfDeliveryCostOBX = 0.obs;
  var orderStatusOBX = ''.obs;
  var headerStatusOBX = ''.obs;
  var orderTitleStatusOBX = ''.obs;
  var _valueOBX = 0.obs;

  String orderCondition = '';
  var fireDb = FireDb();

  var _listOption = ['واصل', 'راجع', 'مؤجل', 'قيد الإرسال'];

  OrderModel orderModel = OrderModel();
  OrderController orderController = Get.put(OrderController());
  UserModel _userModel = UserModel();
  var statusTitleController = TextEditingController();
  var deliveryCostController = TextEditingController();

  void getAllAmount({String status, String sortingByName, String clientId}) {
    // orderController.streamStatus(
    //     clientId: clientId, status: status, orderByName: sortingByName);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(Get.find<UserController>().currentUser.value ?? ''),
        ),
        body: Center(
            child: Column(
          children: [
            //جدول المعلومات
            GetX<OrderController>(
              init: Get.put(OrderController()),
              builder: (OrderController orderController) {
                print(orderController.allOrders);
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
                                    child: Text(orderController
                                        .allOrders[index].orderNumber)),

                                // هنا قسم الحالة وعن طريقة يمكن تغير الحاله
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
