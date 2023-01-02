import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'sales_report_screen.dart';
import 'daily_sales_screen.dart';
import 'monthly_sales_screen.dart';
import 'sales_tile.dart';
import '../../models/sales_model.dart';
import '../../models/hive_boxes.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _salesProvider = Provider.of<SalesModelProvider>(context);
    final TextEditingController _authorizationCodeController = TextEditingController();
    const _authorizationCode = '248258';
    return Scaffold(
      body: Consumer<SalesModelProvider>(
        builder: (context, data, _) => Column(
          children: [
            !_salesProvider.getSalesShowTabs()
                ? Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              _salesProvider.salesShow();
                            },
                            icon: Icon(
                              !_salesProvider.getSalesShow()
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_drop_up,
                              size: 16.sp,
                            )),
                        Padding(
                          padding: EdgeInsets.all(5.0.sp),
                          child: SizedBox(
                            width: 90.w,
                            child: TextField(
                              onChanged: (val) {
                                _salesProvider.googleListOfSales(val);
                              },
                              style: TextStyle(fontSize: 10.sp),
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                    fontSize: 10.sp,
                                    fontFamily: 'Quicksand'),
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 12.sp,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(20),
                                    borderSide:
                                    BorderSide(color: Colors.black)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                !_salesProvider.getSalesShow()
                    ? Padding(
                  padding: EdgeInsets.only(
                      left: 2.w, right: 2.w, top: 1.h, bottom: 1.h),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.all(
                          Radius.elliptical(30.w, 15.h)),
                    ),
                    padding: EdgeInsets.all(5.sp),
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SalesReportScreen()));
                            },
                            child: Text(
                              'SALES REPORT',
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DailySalesScreen()));
                            },
                            child: Text(
                              'DAILY SALES',
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {

                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          size: 20.sp,
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          'WARNING!',
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontFamily: 'Quicksand'),
                                        ),
                                      ],
                                    ),
                                    content: Builder(builder: (context) {
                                      return SizedBox(
                                        height: 18.h,
                                        width: 50.w,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                EdgeInsets.all(5.0.sp),
                                                child: TextField(
                                                  keyboardType: TextInputType.number,
                                                  obscureText: true,
                                                  controller:
                                                  _authorizationCodeController,
                                                  style: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontFamily:
                                                      'Quicksand'),
                                                  decoration: InputDecoration(
                                                      hintText:
                                                      'Enter Authorization Code',
                                                      hintStyle: TextStyle(
                                                          fontSize: 10.sp)),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                EdgeInsets.only(top: 4.h),
                                                child: Container(
                                                  height: 5.h,
                                                  width: 18.w,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.all(
                                                              Radius
                                                              .circular(
                                                              20)),
                                                      gradient:
                                                      LinearGradient(
                                                          colors: const [
                                                            Colors.purple,
                                                            Colors.red
                                                          ],
                                                          begin: Alignment.bottomRight,
                                                          end: Alignment.topLeft)),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      if (_authorizationCodeController
                                                          .text ==
                                                          _authorizationCode) {

                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    MonthlySalesScreen()));

                                                        _authorizationCodeController
                                                            .clear();

                                                      } else {
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    },
                                                    child: Text(
                                                      'Confirm',
                                                      style: TextStyle(
                                                          fontSize: 10.sp,
                                                          fontFamily:
                                                          'Quicksand',
                                                          color:
                                                          Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ));
                            },
                            child: Text(
                              'MONTHLY SALES',
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ]),
                  ),
                )
                    : Container(),
                _salesProvider.getSalesShow()
                    ? Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL CASH: ₱ ' +
                                NumberFormat().format(
                                    _salesProvider.totalSalesCash),
                            style: TextStyle(
                                fontSize: 8.sp,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w600),
                          ),

                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          Text(
                            'NO. OF ITEMS SOLD: ' +
                                NumberFormat().format(_salesProvider
                                    .totalSalesProducts),
                            style: TextStyle(
                                fontSize: 8.sp,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ])
                    : Container(),
              ],
            )
                : Container(),
            Expanded(
                child: ValueListenableBuilder<Box<SalesModel>>(
                  valueListenable: HiveBoxes.getSalesData().listenable(),
                  builder: (context, box, _) {
                    _salesProvider.listOfSales =
                        box.values.toList().cast<SalesModel>();
                    return GroupedListView<SalesModel, int>(
                      elements: _salesProvider.listOfSales,
                      groupBy: (e) => e.index,
                      itemBuilder: (context, e) {
                        if (_salesProvider.getSalesSearch().isEmpty) {
                          return SalesTile(salesModelTile: e);
                        } else if (DateFormat()
                            .format(e.dateTime)
                            .toLowerCase()
                            .contains(_salesProvider.getSalesSearch())) {
                          return SalesTile(salesModelTile: e);
                        } else if (e.customerName
                            .toLowerCase()
                            .contains(_salesProvider.getSalesSearch())) {
                          return SalesTile(salesModelTile: e);
                        } else {
                          return Container();
                        }
                      },
                      groupSeparatorBuilder: (int index) {
                        if (_salesProvider.getSalesSearch().isNotEmpty) {
                          return Container();
                        } else {
                          return GestureDetector(
                            onTap: () {
                              _salesProvider.salesShowTabs();
                            },
                            child: Container(),
                          );
                        }
                      },
                      itemComparator: (item1, item2) =>
                          item2.index.compareTo(item1.index),
                      order: GroupedListOrder.DESC,
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }
}
