import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/distribution_model.dart';
import 'models/inventory_model.dart';
import 'models/checkout_model.dart';
import 'models/sales_model.dart';
import 'models/sales_report_model.dart';
import 'models/daily_sales_model.dart';
import 'models/monthly_sales_model.dart';

import 'models/system_reports_model.dart';
import 'models/cash_out_model.dart';
import 'main_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('license_code');
  await Hive.openBox('enterprise_info');
  Hive.registerAdapter(DistributionModelAdapter());
  await Hive.openBox<DistributionModel>('distribution_box');
  Hive.registerAdapter(InventoryModelAdapter());
  await Hive.openBox<InventoryModel>('inventory_box');
  Hive.registerAdapter(CheckOutModelAdapter());
  await Hive.openBox<CheckOutModel>('checkout_box');
  Hive.registerAdapter(SalesModelAdapter());
  await Hive.openBox<SalesModel>('sales_box');
  Hive.registerAdapter(SalesReportModelAdapter());
  await Hive.openBox<SalesReportModel>('sales_report_box');
  Hive.registerAdapter(DailySalesModelAdapter());
  await Hive.openBox<DailySalesModel>('daily_sales_box');
  Hive.registerAdapter(MonthlySalesModelAdapter());
  await Hive.openBox<MonthlySalesModel>('monthly_sales_box');
  Hive.registerAdapter(SystemReportsModelAdapter());
  await Hive.openBox<SystemReportsModel>('system_reports_box');
  Hive.registerAdapter(CashOutModelAdapter());
  await Hive.openBox<CashOutModel>('cash_out_box');
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (context) => DistributionModelProvider()),
            ChangeNotifierProvider(
                create: (context) => InventoryModelProvider()),
            ChangeNotifierProvider(
                create: (context) => CheckOutModelProvider()),
            ChangeNotifierProvider(create: (context) => SalesModelProvider()),
            ChangeNotifierProvider(
                create: (context) => SalesReportModelProvider()),
            ChangeNotifierProvider(
                create: (context) => DailySalesModelProvider()),
            ChangeNotifierProvider(
                create: (context) => MonthlySalesModelProvider()),
            ChangeNotifierProvider(
                create: (context) => SystemReportsModelProvider()),
            ChangeNotifierProvider(create: (context) => CashOutModelProvider())
          ],
          child: MaterialApp(
            home: MainScreen(),
          ));
    });
  }
}
