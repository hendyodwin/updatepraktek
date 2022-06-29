import 'package:praktek_app/models/cart_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const ID = "id";
  static const UID = "uid";
  static const NAME = "name";
  static const EMAIL = "email";
  static const CART = "cart";
  static const MONTHSALES = "monthlySales";

  late String? id;
  late String? uid;
  late String? name;
  late String? email;
  late int? monthlySales;
  late List<CartItemModel>? cart;

  UserModel(
      {this.id, this.uid, this.name, this.email, this.monthlySales, this.cart});

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    name = snapshot[NAME] ?? '';
    email = snapshot[EMAIL] ?? '';
    id = snapshot[ID] ?? '';
    uid = snapshot[UID] ?? '';
    monthlySales = snapshot[MONTHSALES] ?? 0;
    cart = convertCartItems(snapshot[CART] ?? []);
  }

  List<CartItemModel> convertCartItems(List cartFomDb) {
    print('Cart Items: ${cartFomDb}');
    List<CartItemModel> _result = [];
    if (cartFomDb.isNotEmpty) {
      for (var element in cartFomDb) {
        try {
          _result.add(CartItemModel.fromMap(element));
        } on Exception catch (e) {
          print('CartItemModel ==> ${e.toString()}');
        }
      }
    }
    return _result;
  }

  List cartItemsToJson() => cart!.map((item) => item.toJson()).toList();
  @override
  String toString() {
    return 'User: {name: ${name}, uid: ${uid}, monthlySales: ${monthlySales}, cart: ${cart.toString()}';
  }
}
