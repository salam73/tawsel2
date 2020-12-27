import 'package:flutter_web2/models/order.dart';

import 'package:flutter_web2/controllers/authController.dart';
import 'package:flutter_web2/controllers/userController.dart';
import 'package:flutter_web2/services/fireDb.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  Rx<List<OrderModel>> orderList = Rx<List<OrderModel>>();
  Rx<List<OrderModel>> allOrderList = Rx<List<OrderModel>>();

  var orderStatus = 'جاهز'.obs;
  var orderBySortingName = 'dateCreated'.obs;
  var sumAmount = 0.obs;
  var sumDelivery = 0.obs;
  var clientId = ''.obs;

  var sumOfAmountOBX = 0.obs;
  var sumOfDeliveryCostOBX = 0.obs;

  List<OrderModel> get orders => orderList.value;
  List<OrderModel> get allOrders => allOrderList.value;

  @override
  @mustCallSuper
  void onInit() async {
    var fireUser = Get.find<AuthController>().user;
    clear();

    if (fireUser != null) {
      await FireDb().getUser(uid: Get.find<AuthController>().user.uid);
      var user = Get.find<UserController>().user;
      orderList.bindStream(FireDb().orderStream(user.id));
    }
    allOrderList.bindStream(FireDb().allOrderStreamByStatus(
        status: orderStatus.value,
        sortingName: orderBySortingName
            .value)); //stream coming from firebase For todo List

    super.onInit();
  }

  void orderByUser({String userId}) {
    orderList.bindStream(FireDb().orderStreamByUserId(userId));
  }

  int getAllAmount() {
    int allAmount = 0;
    allOrders.forEach((element) {
      allAmount = allAmount + element.amountAfterDelivery;
    });
    return allAmount;
  }

  int getDeliveryCost() {
    int deliveryCost = 0;
    allOrders.forEach((element) {
      deliveryCost = deliveryCost + element.deliveryCost;
    });
    return deliveryCost;
  }

  // String printOrder() {
  //   return 'printController' + sumAmount.toString();
  // }

  void streamStatus({String status, String orderByName, String clientId}) {
    allOrderList.bindStream(FireDb().allOrderStreamByStatus(
        status: orderStatus.value,
        sortingName: orderBySortingName.value,
        clientId: clientId));
  }

  void clear() {
    this.orderList.value = List<OrderModel>();
    this.allOrderList.value = List<OrderModel>();
  }
}
