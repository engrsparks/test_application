
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'hive_boxes.dart';



part 'distribution_model.g.dart';

@HiveType(typeId: 0)
class DistributionModel extends HiveObject {
  @HiveField(1)
  final String index;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final double cost;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final int quantity;

  @HiveField(6)
  final DateTime dateTime;

  @HiveField(7)
  bool isClicked = true;

  @HiveField(122)
  final String ?id;

  DistributionModel(
      {required this.index,
        required this.name,
        required this.cost,
        required this.price,
        required this.quantity,
        required this.dateTime,
        required this.isClicked,
        required this.id});
}

class DistributionModelProvider with ChangeNotifier {
  final List<DistributionModel> calculateDistributionProducts = [];

  String _search = '';

  void addDistribution(
      String index, String name, double cost, double price, int quantity)  {

      final _distributionProducts = DistributionModel(
          index: index,
          name: name,
          cost: cost,
          price: price,
          quantity: quantity,
          dateTime: DateTime.now(),
          isClicked: true,id:'');
      HiveBoxes.getDistributionData().add(_distributionProducts);
      notifyListeners();

  }

  void calculateDistribution(
      String index, String name, double cost, double price, int quantity, String id) {
    calculateDistributionProducts.add(DistributionModel(
        index: index,
        name: name,
        cost: cost,
        price: price,
        quantity: quantity,
        dateTime: DateTime.now(),
        isClicked: true,id: id));
    notifyListeners();
  }

  double get totalDistributionCost {
    var total = 0.0;
    for (int i = 0; i < calculateDistributionProducts.length; i++) {
      total = total +
          (calculateDistributionProducts[i].cost *
              calculateDistributionProducts[i].quantity);
    }
    return total;
  }

  void removeCalculation(String index) {
    calculateDistributionProducts
        .removeWhere((element) => element.index == index);
    notifyListeners();
  }

  void deleteDistributedData(DistributionModel distributionModel, String id) {
    distributionModel.delete();
  }

  String getDistributionSearch() => _search;

  googleListOfDistribution(val) {
    _search = val;
    notifyListeners();
  }
}
