import 'package:flutter/material.dart';
import 'checkout_model.dart';
import 'package:hive/hive.dart';
import 'hive_boxes.dart';

part 'sales_model.g.dart';

@HiveType(typeId: 3)
class SalesModel {
  @HiveField(20)
  int index;

  @HiveField(21)
  final String customerName;

  @HiveField(22)
  double cash;


  @HiveField(25)
  final double discount;

  @HiveField(26)
  final double gross;

  @HiveField(27)
  final List<CheckOutModel> soldProducts;

  @HiveField(28)
  final DateTime dateTime;

  @HiveField(29)
  final int numberOfProducts;

  @HiveField(32)
  bool isSelected = true;

  @HiveField(33)
  double deliveryCharge;

  @HiveField(34)
  final String address;

  @HiveField(120)
  final String ? id;


  SalesModel(
      {required this.index,
        required this.customerName,
        required this.cash,
        required this.discount,
        required this.gross,
        required this.soldProducts,
        required this.dateTime,
        required this.numberOfProducts,
        required this.isSelected,
        required this.deliveryCharge,
        required this.address,
        required this.id
      });
}

class SalesModelProvider with ChangeNotifier {
  List<SalesModel> listOfSales = [];
  List<SalesModel> listOfSalesComputations = [];

  String _search = '';
  bool _show = false;
  bool _showTabs = false;

  Future<void> addSales  (
      int index,
      String customerName,
      double cash,
      double discount,
      double gross,
      List<CheckOutModel> soldProducts,
      int numberOfProducts,
      double deliveryCharge,
      String address) async{





    final _listOfSales = SalesModel(
        index: index,
        customerName: customerName,
        cash: cash,

        discount: discount,
        gross: gross,
        soldProducts: soldProducts,
        dateTime: DateTime.now(),
        numberOfProducts: numberOfProducts,
        isSelected: true,
        deliveryCharge: deliveryCharge,
        address: address,
        id:''
    );
      listOfSales.add(_listOfSales);
      HiveBoxes.getSalesData().put(index, _listOfSales);
      notifyListeners();



  }

  void addSalesComputation(
      int index,
      String customerName,
      double cash,
      double discount,
      double gross,
      List<CheckOutModel> soldProducts,
      int numberOfProducts,
      double deliveryCharge,
      String address, String id) {
    listOfSalesComputations.add(SalesModel(
        index: index,
        customerName: customerName,
        cash: cash,
        discount: discount,
        gross: gross,
        soldProducts: soldProducts,
        dateTime: DateTime.now(),
        numberOfProducts: numberOfProducts,
        isSelected: true,
        deliveryCharge: deliveryCharge,
        address: address,id: id

    ));

    notifyListeners();
  }


  double get totalSalesCash {
    var total = 0.0;
    for (int i = 0; i < listOfSalesComputations.length; i++) {
      total = total + (listOfSalesComputations[i].cash);
    }
    return total;
  }





  double get totalSalesProducts {
    var total = 0.0;
    for (int i = 0; i < listOfSalesComputations.length; i++) {
      total = total + (listOfSalesComputations[i].numberOfProducts);
    }
    return total;
  }

  double get totalSales {
    var total = 0.0;
    for (int i = 0; i < listOfSalesComputations.length; i++) {
      total = total +
          (listOfSalesComputations[i].cash);
    }
    return total;
  }

  double get totalGrossSales {
    var total = 0.0;
    for (int i = 0; i < listOfSalesComputations.length; i++) {
      total = total + (listOfSalesComputations[i].gross);
    }
    return total;
  }

  void deleteSalesTileData(int index,String id) {
    HiveBoxes.getSalesData().delete(index);
  }

  void removeSalesCalculation(int index) {
    listOfSalesComputations.removeWhere((element) => element.index == index);
    notifyListeners();
  }

  String getSalesSearch() => _search;
  bool getSalesShow() => _show;
  bool getSalesShowTabs() => _showTabs;

  salesShow() {
    _show = !_show;
    notifyListeners();
  }

  salesShowTabs() {
    _showTabs = !_showTabs;
    notifyListeners();
  }

  googleListOfSales(val) {
    _search = val;
    notifyListeners();
  }
}
