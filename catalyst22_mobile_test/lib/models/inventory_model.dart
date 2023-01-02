import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'hive_boxes.dart';


part 'inventory_model.g.dart';

@HiveType(typeId: 1)
class InventoryModel {
  @HiveField(8)
  final String  name;

  @HiveField(9)
  double  cost;

  @HiveField(10)
  double  price;

  @HiveField(11)
  int  quantity;

  @HiveField(12)
  String  index;

  @HiveField(95)
  int  minimumQuantity;

  @HiveField(119)
  String ? id;

  InventoryModel(
      {required this.name,
        required this.cost,
        required this.price,
        required this.quantity,
        required this.index,
        required this.minimumQuantity,
        required this.id
      });
}

class InventoryModelProvider with ChangeNotifier {
  List<InventoryModel> listOfInventoryData = [];

  void addInventory(
      String name, double cost, double price, int quantity, String index, int minimumQuantity, ) {

      final _inventoryProducts = InventoryModel(
          name: name, cost: cost, price: price, quantity: quantity, index:index ,
          minimumQuantity: minimumQuantity, id: ''
      );

      listOfInventoryData.add(_inventoryProducts);
      HiveBoxes.getInventoryData().put(name, _inventoryProducts);

      notifyListeners();


  }

  void purchaseProduct(String name, double cost, double price, int quantity,
      int newQuantity, String index, int minimumQuantity, String id)  {

    final _inventoryProducts = InventoryModel(
        name: name,
        cost: cost,
        price: price,
        quantity: quantity - newQuantity,
        index:index,
        minimumQuantity: minimumQuantity,id: id
    );
    listOfInventoryData.add(_inventoryProducts);
    final _box = HiveBoxes.getInventoryData();
    _box.put(name, _inventoryProducts);
    notifyListeners();

  }

  void addProduct(String name, double price, int quantity, int newQuantity,
      double newCost, String index, int minimumQuantity, String id ) {

    final _inventoryProducts = InventoryModel(
        name: name,
        cost: newCost,
        price: price,
        quantity: quantity + newQuantity,
        index: index,
        minimumQuantity: minimumQuantity,id: id
    );

    listOfInventoryData.add(_inventoryProducts);
    final _box = HiveBoxes.getInventoryData();
    _box.put(name, _inventoryProducts);
    notifyListeners();
  }

  void returnProduct(String name, double cost, double price, int quantity,
      int newQuantity, String index, int minimumQuantity, String id, int newMinQuantity)  {

    final _inventoryProducts = InventoryModel(
        name: name,
        cost: cost,
        price: price,
        quantity: quantity + newQuantity,
        index: index,
      minimumQuantity: minimumQuantity + newMinQuantity,id: id
    );

  listOfInventoryData.add(_inventoryProducts);
    final _box = HiveBoxes.getInventoryData();
    _box.put(name, _inventoryProducts);
    notifyListeners();
  }

  void changePrice(String name, double cost, double price, double newPrice,
      int quantity, String index, int minimumQuantity, String id) {

    final _inventoryProducts = InventoryModel(
        name: name,
        cost: cost,
        price: newPrice,
        quantity: quantity,
        index: index,
        minimumQuantity: minimumQuantity,id: id
    );
   listOfInventoryData.add(_inventoryProducts);
    final _box = HiveBoxes.getInventoryData();
    _box.put(name, _inventoryProducts);
    notifyListeners();
  }

  void cancelProduct(String name, double cost, double price, int quantity,
      double discount, String index, int minimumQuantity, String id)  {

    final _inventoryProducts = InventoryModel(
        name: name,
        cost: cost,
        price: price + discount,
        quantity: quantity,
        index: index,
        minimumQuantity: minimumQuantity,id: id
    );
    listOfInventoryData.add(_inventoryProducts);
    final _box = HiveBoxes.getInventoryData();
    _box.put(name, _inventoryProducts);
    notifyListeners();
  }

  void deleteInventoryData(String name, String id) {
    HiveBoxes.getInventoryData().delete(name);
  }
}
