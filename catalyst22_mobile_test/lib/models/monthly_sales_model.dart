import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'hive_boxes.dart';


part 'monthly_sales_model.g.dart';

@HiveType(typeId: 8)
class MonthlySalesModel {
  @HiveField(66)
  final double cash;


  @HiveField(68)
  final double ar;

  @HiveField(69)
  final double netSales;

  @HiveField(70)
  final double grossProfit;

  @HiveField(71)
  final DateTime dateTime;

  @HiveField(72)
  final int numberOfProductsSold;

  @HiveField(81)
  final double expenses;

  MonthlySalesModel(
      {required this.cash,

        required this.ar,
        required this.netSales,
        required this.grossProfit,
        required this.dateTime,
        required this.numberOfProductsSold,
        required this.expenses
      });
}

class MonthlySalesModelProvider with ChangeNotifier {
  List<MonthlySalesModel> listOfMonthlySales = [];


  Future <void> addMonthlySales(double cash,  double netSales,
      double grossProfit, int numberOfProductsSold, double expenses)async {
    final _listOfMonthlySales = MonthlySalesModel(
        cash: cash,
        ar: 0,
        netSales: netSales,
        grossProfit: grossProfit,
        dateTime: DateTime.now(),
        numberOfProductsSold: numberOfProductsSold,
        expenses: expenses
    );

      listOfMonthlySales.add(_listOfMonthlySales);
      HiveBoxes.getMonthlySalesData().add(_listOfMonthlySales);
      notifyListeners();


  }


  double get monthlySalesCash {
    var total = 0.0;
    for (int i = 0; i < listOfMonthlySales.length; i++) {
      total = total + (listOfMonthlySales[i].cash);
    }
    return total;
  }




  int get monthlySalesProductsSold {
    var total = 0;
    for (int i = 0; i < listOfMonthlySales.length; i++) {
      total = total + (listOfMonthlySales[i].numberOfProductsSold);
    }
    return total;
  }



}
