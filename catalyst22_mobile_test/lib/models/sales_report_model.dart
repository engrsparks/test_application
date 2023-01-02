import 'package:flutter/foundation.dart';
import 'checkout_model.dart';
import 'package:hive/hive.dart';
import 'hive_boxes.dart';


part 'sales_report_model.g.dart';

@HiveType(typeId: 4)
class SalesReportModel {
  @HiveField(35)
  final int index;

  @HiveField(36)
  final String customerName;

  @HiveField(37)
  double cash;

  @HiveField(40)
  final double discount;

  @HiveField(41)
  final double gross;

  @HiveField(42)
  final List<CheckOutModel> soldProducts;

  @HiveField(43)
  final DateTime dateTime;

  @HiveField(44)
  final int numberOfProducts;

  @HiveField(45)
  double cashOut;

  @HiveField(46)
  double cashIn;

  @HiveField(121)
  final String ?id;


  SalesReportModel(
      {required this.index,
        required this.customerName,
        required this.cash,
        required this.discount,
        required this.gross,
        required this.soldProducts,
        required this.dateTime,
        required this.numberOfProducts,
        required this.cashOut,
        required this.cashIn,
        required this.id
      });
}

class SalesReportModelProvider with ChangeNotifier {
  bool _show = true;
  bool _showTabs = true;
  List<SalesReportModel> listOfSalesReport = [];

  void addSalesReport(
      int index,
      String customerName,
      double cash,

      double discount,
      double gross,
      List<CheckOutModel> soldProducts,
      int numberOfProducts)  {




      final _listOfSalesReportData = SalesReportModel(
          index: index,
          customerName: customerName,
          cash: cash,
          discount: discount,
          gross: gross,
          soldProducts: soldProducts,
          dateTime: DateTime.now(),
          numberOfProducts: numberOfProducts,
          cashOut: 0.0,
          cashIn: 0.0, id: '');
      listOfSalesReport.add(_listOfSalesReportData);
      HiveBoxes.getSalesReportData().put(index, _listOfSalesReportData);
      notifyListeners();




  }

  void saleReportAccountsReceivablePayment(
      String customerName,
      double cash,
      double discount,
      double gross,
      List<CheckOutModel> soldProducts,
      DateTime dateTime,
      int numberOfProducts,
      double payment,
      int index,
      double cashIn,
      double cashOut,String id
      ) {
    final _listOfSalesReportData = SalesReportModel(
        index: index,
        customerName: customerName,
        cash: cash,
        discount: discount,
        gross: gross,
        soldProducts: soldProducts,
        dateTime: dateTime,
        numberOfProducts: numberOfProducts,
        cashOut: cashOut,
        cashIn: cashIn,id: id
    );
   HiveBoxes.getSalesReportData().put(index, _listOfSalesReportData);
  }



  void deleteSalesReportData(int index, String id) {
    HiveBoxes.getSalesReportData().delete(index);
  }
  double get salesReportCashIn {
    var total = 0.0;

    for (int i = 0; i < listOfSalesReport.length; i++) {
      total = total + (listOfSalesReport[i].cashIn);
    }
    return total;
  }
  double get salesReportCashOut {
    var total = 0.0;

    for (int i = 0; i < listOfSalesReport.length; i++) {
      total = total + (listOfSalesReport[i].cashOut);
    }
    return total;
  }

  double get salesReportCash {
    var total = 0.0;

    for (int i = 0; i < listOfSalesReport.length; i++) {
      total = total + (listOfSalesReport[i].cash);
    }
    return total;
  }



  int get salesReportProductsSold {
    var total = 0;

    for (int i = 0; i < listOfSalesReport.length; i++) {
      total = total + (listOfSalesReport[i].numberOfProducts);
    }
    return total;
  }

  double get salesReportGrossSales {
    var total = 0.0;

    for (int i = 0; i < listOfSalesReport.length; i++) {
      total = total + (listOfSalesReport[i].gross);
    }
    return total;
  }

  bool getSalesReportShow() => _show;
  bool getSalesReportShowTabs() => _showTabs;

  salesReportShow() {
    _show = !_show;
    notifyListeners();
  }

  salesReportShowTabs() {
    _showTabs = !_showTabs;
    notifyListeners();
  }
}
