import 'package:flutter/material.dart';

class CartItemModel {
  CartItemModel({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.cost,
  });

  static const ID = "id";
  static const IMAGE = "image";
  static const NAME = "name";
  static const QUANTITY = "quantity";
  static const COST = "cost";
  static const PRICE = "price";
  static const PRODUCT_ID = "productId";

  late String name;
  late int quantity;
  late double cost;
  late String productId;
  late double price;

  CartItemModel.fromMap(Map<String, dynamic> data) {
    name = data[NAME];
    quantity = data[QUANTITY];
    cost = data[COST].toDouble();
    productId = data[PRODUCT_ID];
    price = data[PRICE].toDouble();
  }

  Map toJson() => {
        PRODUCT_ID: productId,
        NAME: name,
        QUANTITY: quantity,
        COST: price * quantity,
        PRICE: price,
      };
}
