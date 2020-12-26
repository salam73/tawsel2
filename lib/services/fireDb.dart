import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web2/models/order.dart';
import 'package:flutter_web2/models/user.dart';

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

  Future<UserModel> getUser({String uid}) async {
    try {
      DocumentSnapshot _doc =
          await _firestore.collection("users").doc(uid).get();

      return UserModel.fromSnapShot(_doc);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addOrder({
    String uid,
    String orderNumber,
    String deliveryToCity,
    String customerName,
    String customerAddress,
    String customerPhone,
    int amountAfterDelivery,
    String orderType,
    String content,
    String commit,
    bool isPickup,
    bool isReturn,
    bool isSolve,
    String status,
    String statusTitle,
  }) async {
    try {
      await _firestore.collection("users").doc(uid).collection("orders").add({
        'dateCreated': Timestamp.now(),
        'byUserId': uid,
        // 'content': content ?? '',
        'done': false,
        'orderNumber': orderNumber ?? '',
        'deliveryToCity': deliveryToCity ?? '',
        'customerName': customerName ?? '',
        'customerAddress': customerAddress ?? '',
        'customerPhone': customerPhone ?? '',
        'amountAfterDelivery': amountAfterDelivery ?? 0,
        'orderType': orderType ?? '',
        'commit': commit ?? '',
        'content': content ?? '',
        'status': status ?? 'جاهز',
        'statusTitle': statusTitle ?? 'جاهز',
        'isPickup': isPickup ?? false,
        'isReturn': isReturn ?? false,
        'isSolve': isSolve ?? false,
      });

      await _firestore.collection("orders").add({
        'dateCreated': Timestamp.now(),
        'byUserId': uid,
        // 'content': content,
        'done': false,
        'orderNumber': orderNumber ?? '',
        'deliveryToCity': deliveryToCity ?? '',
        'customerName': customerName ?? '',
        'customerAddress': customerAddress ?? '',
        'customerPhone': customerPhone ?? '',
        'amountAfterDelivery': amountAfterDelivery ?? 0,
        'orderType': orderType ?? '',
        'commit': commit ?? '',
        'content': content ?? '',
        'status': status ?? 'جاهز',
        'statusTitle': statusTitle ?? 'جاهز',
        'isPickup': isPickup ?? false,
        'isReturn': isReturn ?? false,
        'isSolve': isSolve ?? false,
      });
    } catch (e) {
      print(e);
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
        .collection("users")
        .doc(uid)
        .collection("orders")
        // .where('done', isEqualTo: false)
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
      _firestore
          .collection("users")
          .doc(clientId)
          .collection("orders")
          .doc(uid)
          .update(order.toJson());
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
