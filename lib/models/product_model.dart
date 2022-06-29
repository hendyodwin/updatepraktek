import 'package:flutter/material.dart';

class ProductModel {
  static const ID = "id";
  static const NAME = "name";
  static const PRICE = "price";

  String? id;
  String? name;
  double? price;

  ProductModel({this.id, this.name, this.price});

  ProductModel.fromMap(Map<String, dynamic> data) {
    id = data[ID];
    name = data[NAME];
    price = data[PRICE].toDouble();
  }

  @override
  String toString() {
    return '{"id": ${id},"name": ${name}, "price": ${price}}';
  }
}
