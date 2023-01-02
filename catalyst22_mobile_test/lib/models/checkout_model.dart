import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'checkout_model.g.dart';

@HiveType(typeId: 2)
class CheckOutModel {
  @HiveField(13)
  final String name;

  @HiveField(14)
  final double cost;

  @HiveField(15)
  final double price;

  @HiveField(16)
  final int quantity;

  @HiveField(17)
  final double discount;

  @HiveField(18)
  final int initialQuantity;

  @HiveField(19)
  final String index;

  @HiveField(86)
  final int minimumQuantity;

  @HiveField(120)
  final String id;

  CheckOutModel(
      {required this.name,
        required this.cost,
        required this.price,
        required this.quantity,
        required this.discount,
        required this.initialQuantity,
        required this.index,
        required this.minimumQuantity,required this.id
      });
}

class CheckOutModelProvider with ChangeNotifier {
  Map<String, CheckOutModel> _checkOutProducts = {};

  Map<String, CheckOutModel> get checkOutProducts {
    return {..._checkOutProducts};
  }

  double _totalAmount = 0.0;
  double _totalCost = 0.0;
  double _totalDiscount = 0.0;
  double checkOutChange = 0.0;
  int _numberOfProductsSold = 0;

  double get totalAmount {
    return _totalAmount;
  }

  double get totalCost {
    return _totalCost;
  }

  double get totalDiscount {
    return _totalDiscount;
  }

  int get numberOfProductsSold {
    return _numberOfProductsSold;
  }

  void addCheckOut(String name, double cost, double price, int quantity,
      double discount, int initialQuantity, String index, int minimumQuantity, String id ) {
    if (_checkOutProducts.containsKey(name)) {
      _checkOutProducts.update(
          name,
              (value) => CheckOutModel(
              name: value.name,
              cost: value.cost,
              price: value.price,
              quantity: value.quantity + quantity,
              discount: discount,
              initialQuantity: value.initialQuantity,
              index: index,
              minimumQuantity: minimumQuantity,id:id
              ));
    } else {
      _checkOutProducts.putIfAbsent(
          name,
              () => CheckOutModel(
              name: name,
              cost: cost,
              price: price,
              quantity: quantity,
              discount: discount,
              initialQuantity: initialQuantity,
              index: index,
              minimumQuantity: minimumQuantity,id:id
              ));
    }
    _totalAmount = 0.0;
    _checkOutProducts.forEach((key, value) {
      _totalAmount = _totalAmount + (value.quantity * value.price);
    });
    _totalCost = 0.0;
    _checkOutProducts.forEach((key, value) {
      _totalCost = _totalCost + (value.quantity * (value.price - value.cost));
    });
    _totalDiscount = 0.0;
    _checkOutProducts.forEach((key, value) {
      _totalDiscount = _totalDiscount + (value.discount * value.quantity);
    });
    _numberOfProductsSold = 0;
    _checkOutProducts.forEach((key, value) {
      _numberOfProductsSold = _numberOfProductsSold + (value.quantity);
    });

    notifyListeners();
  }

  void clear() {
    _checkOutProducts = {};
    _totalAmount = 0.0;
    checkOutChange = 0.0;
    notifyListeners();
  }

  void addDeliveryCharge(double val) {
    _totalAmount = _totalAmount + (val * numberOfProductsSold);
    notifyListeners();
  }

  void removeCheckOutProduct(String name) {
    _totalAmount = 0.0;
    _checkOutProducts.removeWhere((key, value) => value.name == name);
    _checkOutProducts.forEach((key, value) {
      _totalAmount = _totalAmount + value.quantity * value.price;
    });
    _totalDiscount = 0;
    notifyListeners();
  }
}
