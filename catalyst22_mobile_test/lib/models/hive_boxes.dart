import 'system_reports_model.dart';
import 'distribution_model.dart';
import 'inventory_model.dart';
import 'sales_model.dart';
import 'sales_report_model.dart';
import 'daily_sales_model.dart';
import 'monthly_sales_model.dart';
import 'cash_out_model.dart';
import 'package:hive/hive.dart';

class HiveBoxes {
  static Box<DistributionModel> getDistributionData() =>
      Hive.box<DistributionModel>('distribution_box');
  static Box<InventoryModel> getInventoryData() =>
      Hive.box<InventoryModel>('inventory_box');
  static Box<SalesModel> getSalesData() => Hive.box<SalesModel>('sales_box');
  static Box<SalesReportModel> getSalesReportData() =>
      Hive.box<SalesReportModel>('sales_report_box');
  static Box<DailySalesModel> getDailySalesData() =>
      Hive.box<DailySalesModel>('daily_sales_box');
  static Box<MonthlySalesModel> getMonthlySalesData() =>
      Hive.box<MonthlySalesModel>('monthly_sales_box');
  static Box<SystemReportsModel> getSystemReportsData() =>
      Hive.box<SystemReportsModel>('system_reports_box');
  static Box<CashOutModel> getCashOutData() =>
      Hive.box<CashOutModel>('cash_out_box');
}
