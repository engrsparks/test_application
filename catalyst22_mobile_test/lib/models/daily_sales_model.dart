import 'package:flutter/material.dart';
import 'sales_report_model.dart';
import 'package:hive/hive.dart';
import 'hive_boxes.dart';


part 'daily_sales_model.g.dart';

@HiveType(typeId: 6)
class DailySalesModel {
  @HiveField(57)
  double cash;

  @HiveField(58)
  double ar;

  @HiveField(60)
  final double gross;

  @HiveField(61)
  final List<SalesReportModel> soldProducts;

  @HiveField(62)
  final DateTime dateTime;

  @HiveField(63)
  final int numberOfProducts;

  @HiveField(80)
  final double expenses;

  DailySalesModel({
    required this.cash,
    required this.ar,
    required this.gross,
    required this.soldProducts,
    required this.dateTime,
    required this.numberOfProducts,
    required this.expenses
  });
}

class DailySalesModelProvider with ChangeNotifier {
  bool _show = true;
  bool _showTabs = true;
  List<DailySalesModel> listOfDailySales = [];

  void addDailySales(
      double cash,
      double gross,
      List<SalesReportModel> soldProducts,
      int numberOfProducts,
      double expenses
      )  {
    final _listOfDailySalesData = DailySalesModel(
      cash: cash,
      ar: 0,
      gross: gross,
      soldProducts: soldProducts,
      dateTime: DateTime.now(),
      numberOfProducts: numberOfProducts,
      expenses: expenses
    );

      listOfDailySales.add(_listOfDailySalesData);
      HiveBoxes.getDailySalesData().add(_listOfDailySalesData);
      notifyListeners();
  }

  double get dailySalesCash {
    var total = 0.0;
    for (int i = 0; i < listOfDailySales.length; i++) {
      total = total + (listOfDailySales[i].cash);
    }
    return total;
  }



  double get dailyExpenses {
    var total = 0.0;
    for (int i = 0; i < listOfDailySales.length; i++) {
      total = total + (listOfDailySales[i].expenses);
    }
    return total;
  }


  int get dailySalesProductsSold {
    var total = 0;
    for (int i = 0; i < listOfDailySales.length; i++) {
      total = total + (listOfDailySales[i].numberOfProducts);
    }
    return total;
  }

  double get dailyGrossSales {
    var total = 0.0;
    for (int i = 0; i < listOfDailySales.length; i++) {
      total = total + (listOfDailySales[i].gross);
    }
    return total;
  }

  bool getDailySalesShow() => _show;
  bool getDailySalesShowTabs() => _showTabs;

  dailySalesShow() {
    _show = !_show;
    notifyListeners();
  }

  dailySalesShowTabs() {
    _showTabs = !_showTabs;
    notifyListeners();
  }
}
