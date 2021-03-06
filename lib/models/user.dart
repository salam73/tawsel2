import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String email;
  String password;

  String shopName;
  String shopAddress;
  String phoneNumber;
  // bool isShopOwner;
  // bool isDeliveryBoy;
  // bool isDeliveryProvince;
  String role;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.shopName,
      this.shopAddress,
      this.phoneNumber,
      this.password,
      // this.isShopOwner,
      // this.isDeliveryBoy,
      // this.isDeliveryProvince,
      // this.isAdmin
      this.role});

  UserModel.fromSnapShot(DocumentSnapshot userSnapShot) {
    this.id = userSnapShot.id;
    this.name = userSnapShot['name'];
    this.email = userSnapShot['email'];
    this.password = userSnapShot['password'];
    this.shopName = userSnapShot['shopName'];
    this.shopAddress = userSnapShot['shopAddress'];
    this.phoneNumber = userSnapShot['phoneNumber'];
    this.role = userSnapShot['role'];
    // this.isShopOwner = userSnapShot['isShopOwner'];
    // this.isDeliveryBoy = userSnapShot['isDeliveryBoy'];
    // this.isDeliveryProvince = userSnapShot['isDeliveryProvince'];
    // this.isAdmin = userSnapShot['isAdmin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['shopName'] = this.shopName;
    data['shopAddress'] = this.shopAddress;
    data['phoneNumber'] = this.phoneNumber;
    data['role'] = this.role;
    // data['isShopOwner'] = this.isShopOwner;
    // data['isDeliveryBoy'] = this.isDeliveryBoy;
    // data['isDeliveryProvince'] = this.isDeliveryProvince;
    // data['isAdmin'] = this.isAdmin;
    return data;
  }
}
