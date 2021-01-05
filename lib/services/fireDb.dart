import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web2/models/deliveryBoy.dart';
import 'package:flutter_web2/models/order.dart';
import 'package:flutter_web2/models/user.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;

class FireDb {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection("users").doc(user.id).set({
        "name": user.name,
        "email": user.email,
        "password": user.password,
        "shopName": user.shopName,
        "shopAddress": user.shopAddress,
        'phoneNumber': user.phoneNumber,
        // 'isShopOwner': false,
        // 'isDeliveryBoy': false,
        // 'isDeliveryProvince': false,
        // 'isAdmin': false,
        'role': user.role
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createNewDeliveryBoy(DeliveryBoyModel user) async {
    try {
      await _firestore.collection("deliveryBoy").doc(user.id).set({
        "name": user.name,
        "email": user.email,
        "password": user.password,
        "province": user.province,
        "deliveryBoyAddress": user.deliveryBoyAddress,
        'phoneNumber': user.phoneNumber,
        // 'isShopOwner': false,
        // 'isDeliveryBoy': false,
        // 'isDeliveryProvince': false,
        // 'isAdmin': false,
        'role': user.role ?? ''
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel> getUser({String uid}) async {
    try {
      DocumentSnapshot _doc =
          await _firestore.collection("users").doc(uid).get();

      return UserModel.fromSnapShot(_doc);
    } catch (e) {
      rethrow;
    }
  }

  Future<DeliveryBoyModel> getDeliveryBoy({String uid}) async {
    try {
      DocumentSnapshot _doc =
          await _firestore.collection("deliveryboy").doc(uid).get();

      return DeliveryBoyModel.fromSnapShot(_doc);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addOrder({
    String uid,
    String orderNumber,
    String deliveryToCity,
    int deliveryCost,
    String customerName,
    String customerAddress,
    String customerPhone,
    int amountAfterDelivery,
    String orderType,
    // String content,
    String commit,
    // bool isPickup,
    // bool isReturn,
    // bool isSolve,
    String status,
    String statusTitle,
  }) async {
    var orderID = randomAlpha(20);

    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("orders")
          .doc(orderID)
          .set({
        'dateCreated': Timestamp.now(),
        'byUserId': uid,
        // 'content': content ?? '',
        'deliveryBoyId': '',
        'done': false,
        'orderNumber': orderNumber ?? '',
        'deliveryToCity': deliveryToCity ?? '',
        'deliveryCost': deliveryCost ?? 5000,
        'customerName': customerName ?? '',
        'customerAddress': customerAddress ?? '',
        'customerPhone': customerPhone ?? '',
        'amountAfterDelivery': amountAfterDelivery ?? 0,
        'orderType': orderType ?? '',
        'commit': commit ?? '',
        // 'content': content ?? '',
        'status': status ?? 'جاهز',
        'statusTitle': statusTitle ?? 'جاهز',
        // 'isPickup': isPickup ?? false,
        // 'isReturn': isReturn ?? false,
        // 'isSolve': isSolve ?? false,
      });
    } catch (e) {
      print(e);
      rethrow;
    }

    try {
      await _firestore.collection("orders").doc(orderID).set({
        'dateCreated': Timestamp.now(),
        'byUserId': uid,
        'deliveryBoyId': '',
        // 'content': content,
        'done': false,
        'orderNumber': orderNumber ?? '',
        'deliveryToCity': deliveryToCity ?? '',
        'deliveryCost': deliveryCost ?? 5000,
        'customerName': customerName ?? '',
        'customerAddress': customerAddress ?? '',
        'customerPhone': customerPhone ?? '',
        'amountAfterDelivery': amountAfterDelivery ?? 0,
        'orderType': orderType ?? '',
        'commit': commit ?? '',
        // 'content': content ?? '',
        'status': status ?? 'جاهز',
        'statusTitle': statusTitle ?? 'جاهز',
        // 'isPickup': isPickup ?? false,
        // 'isReturn': isReturn ?? false,
        // 'isSolve': isSolve ?? false,
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> getUserList() {
    try {
      return FirebaseFirestore.instance
          .collection('users')
          //  .where('type', isEqualTo: 'shop')
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> getOrdersList() {
    try {
      return FirebaseFirestore.instance
          .collection('orders')
          .where('type', isEqualTo: 'shop')
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<OrderModel>> orderStream(String uid) {
    // print('user id' + uid);
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("orders")
        // .where('byUserId', isEqualTo: uid ?? '')
        // .orderBy("dateCreated", descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<OrderModel> retVal = List();
      query.docs.forEach((element) {
        retVal.add(OrderModel.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }

  Stream<List<OrderModel>> allOrderStreamByStatus(
      {String status, String sortingName, String clientId}) {
    return _firestore
        .collection("users")
        .doc(clientId)
        .collection("orders")
        .where('status', isEqualTo: status ?? '')
        // .where('byUserId', isEqualTo: clientId ?? '')
        .orderBy(sortingName ?? 'dateCreated', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<OrderModel> retVal = List();
      query.docs.forEach((element) {
        retVal.add(OrderModel.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }

  Stream<List<OrderModel>> orderStreamByUserId(String uid) {
    return _firestore
        // .collection("users")
        // .doc(uid)
        .collection("orders")
        .where('byUserId', isEqualTo: uid)
        .orderBy('deliveryToCity')
        // .orderBy("dateCreated", descending: true)

        //
        .snapshots()
        .map((QuerySnapshot query) {
      List<OrderModel> retVal = List();
      query.docs.forEach((element) {
        retVal.add(OrderModel.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }

  Future<void> updateOrder(OrderModel order, String uid) async {
    try {
      _firestore
          .collection("users")
          .doc(uid)
          .collection("orders")
          .doc(order.orderId)
          .update(order.toJson());
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateOrder2(
      {OrderModel order, String clientId, String uid}) async {
    try {
      _firestore.collection("users").doc(clientId).collection("orders").doc(uid)
          // .update({'status': 'راجع'});
          //
          .update({'status': order.status, 'statusTitle': order.statusTitle});

      //  _firestore.collection("orders").doc(uid).update(order.toJson());
    } catch (e) {
      print(e);
      rethrow;
    }

    try {
      _firestore
          .collection("orders")
          .doc(uid)
          .update({'status': order.status, 'statusTitle': order.statusTitle});
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteOrder(OrderModel order, String uid) async {
    try {
      _firestore
          .collection("users")
          .doc(uid)
          .collection("orders")
          .doc(order.orderId)
          .delete();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
