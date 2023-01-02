import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'hive_boxes.dart';

part 'system_reports_model.g.dart';

@HiveType(typeId: 7)
class SystemReportsModel {
  @HiveField(64)
  final String description;

  @HiveField(65)
  final DateTime dateTime;

  SystemReportsModel({required this.description, required this.dateTime});
}

class SystemReportsModelProvider with ChangeNotifier {
  List<SystemReportsModel> systemReports = [];

  Future<void> addReport(String desc)async {
    final _inventoryReports =
    SystemReportsModel(description: desc, dateTime: DateTime.now());
    systemReports.add(_inventoryReports);


      HiveBoxes.getSystemReportsData().add(_inventoryReports);
      notifyListeners();


  }
}
