import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'hive_boxes.dart';


part 'cash_out_model.g.dart';

@HiveType(typeId: 9)
class CashOutModel extends HiveObject {
  @HiveField(73)
  final DateTime dateTime;
  @HiveField(74)
  final double cashOut;
  @HiveField(75)
  final String description;
  @HiveField(123)
  final String id;


  CashOutModel({
    required this.dateTime,
    required this.cashOut,
    required this.description,
    required this.id

  });
}

class CashOutModelProvider with ChangeNotifier {
  List<CashOutModel> listOfCashOuts = [];


  void addCashOut(double amount, String description) {

      final _cashOutModel = CashOutModel(
        dateTime: DateTime.now(),
        cashOut: amount,
        description: description,
        id: ''
      );
      listOfCashOuts.add(_cashOutModel);
      HiveBoxes.getCashOutData().add(_cashOutModel);
      notifyListeners();



  }


  double get overallCashOut {
    var total = 0.0;

    for (int i = 0; i < listOfCashOuts.length; i++) {
      total = total + (listOfCashOuts[i].cashOut);
    }
    return total;
  }

  void deleteCashOutData(CashOutModel cashOutModel, String id) {
    cashOutModel.delete();
  }




}
