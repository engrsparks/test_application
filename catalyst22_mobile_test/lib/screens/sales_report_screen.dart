import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'sales_report_tile.dart';
import '../../models/sales_report_model.dart';
import '../../models/daily_sales_model.dart';
import '../../models/cash_out_model.dart';
import '../../models/pdf_api.dart';
import '../../models/hive_boxes.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({Key? key}) : super(key: key);

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {


  @override
  Widget build(BuildContext context) {
    final _salesReportProvider = Provider.of<SalesReportModelProvider>(context);
    final _cashOutProvider = Provider.of<CashOutModelProvider>(context);


    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title:  GestureDetector(
          onDoubleTap: (){
            _salesReportProvider.salesReportShow();
          },
          child: Text(
              'SALES REPORT',
              style: TextStyle(fontSize: 12.sp, fontFamily: 'Quicksand'),
            ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                fontSize: 12.sp, fontFamily: 'Quicksand'),
                          ),
                        ],
                      ),
                      content: Builder(builder: (context) {
                        return SizedBox(
                          height: 15.h,
                          width: 60.w,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  'Please make sure to print this section,\nBefore taking this action. Thank you!',
                                  style: TextStyle(
                                      fontSize: 9.sp,
                                      fontFamily: 'Quicksand'),
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 4.h),
                                      child: Container(
                                        height: 4.h,
                                        width: 15.w,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            gradient: LinearGradient(
                                                colors: const [
                                                  Colors.purple,
                                                  Colors.red
                                                ],
                                                begin: Alignment.bottomRight,
                                                end: Alignment.topLeft)),
                                        child: TextButton(
                                          onPressed: _salesReportProvider
                                              .listOfSalesReport.isEmpty
                                              ? null
                                              : () {
                                            Provider.of<DailySalesModelProvider>(
                                                context,
                                                listen: false)
                                                .addDailySales(
                                              _salesReportProvider
                                                  .salesReportCash,

                                              _salesReportProvider
                                                  .salesReportGrossSales,
                                              _salesReportProvider
                                                  .listOfSalesReport
                                                  .toList(),
                                              _salesReportProvider
                                                  .salesReportProductsSold,
                                              _cashOutProvider.overallCashOut
                                            );
                                            HiveBoxes
                                                .getSalesReportData()
                                                .clear();
                                            HiveBoxes.getCashOutData().clear();
                                            Navigator.of(context)
                                                .pop();
                                            Navigator.of(context)
                                                .pop();
                                          },
                                          child: Text(
                                            'DONE',
                                            style: TextStyle(
                                                fontSize: 9.sp,
                                                fontFamily: 'Quicksand',
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 4.h),
                                      child: Container(
                                        height: 4.h,
                                        width: 15.w,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            gradient: LinearGradient(
                                                colors: const [
                                                  Colors.purple,
                                                  Colors.red
                                                ])),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'CANCEL',
                                            style: TextStyle(
                                                fontSize: 9.sp,
                                                fontFamily: 'Quicksand',
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ));
              },
              child: Text(
                'SAVE',
                style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: 'Quicksand',
                    color: Colors.white),
              )),
          SizedBox(
            width: 8.w,
          ),
          GestureDetector(
              onDoubleTap: () async {
                try {
                  PdfDocument document = PdfDocument();
                  final page = document.pages.add();
                  //Draw rectangle
                  page.graphics.drawRectangle(
                      brush: PdfSolidBrush(PdfColor(66, 182, 245, 255)),
                      bounds: Rect.fromLTWH(0, 0, 70.w, 8.h));
                  //Draw string

                  page.graphics.drawString(
                      '${Hive.box('enterprise_info').get('enterpriseName')}',
                      PdfStandardFont(PdfFontFamily.helvetica, 20),
                      brush: PdfBrushes.white,
                      bounds: Rect.fromLTWH(10, 17.2, 70.w, 8.h),
                      format: PdfStringFormat(
                          alignment: PdfTextAlignment.center,
                          lineSpacing: 5,
                          lineAlignment: PdfVerticalAlignment.top));
                  page.graphics.drawString(
                      'DAILY SALES REPORT \n' +
                          DateFormat.yMMMd().format(DateTime.now()),
                      PdfStandardFont(PdfFontFamily.helvetica, 15),
                      brush: PdfBrushes.white,
                      bounds: Rect.fromLTWH(10, 17.2, 70.w, 8.h),
                      format: PdfStringFormat(
                          alignment: PdfTextAlignment.center,
                          lineSpacing: 5,
                          lineAlignment: PdfVerticalAlignment.middle));

                  page.graphics.drawString(
                    'Total Cash: ' +
                        NumberFormat()
                            .format(_salesReportProvider.salesReportCash),
                    PdfStandardFont(PdfFontFamily.helvetica, 13),
                    brush: PdfBrushes.black,
                    bounds: Rect.fromLTWH(10, 145, 70.w, 8.h),
                  );

                  page.graphics.drawString(
                    'Total Expenses: ' +
                        NumberFormat()
                            .format(_cashOutProvider.overallCashOut),
                    PdfStandardFont(PdfFontFamily.helvetica, 13),
                    brush: PdfBrushes.black,
                    bounds: Rect.fromLTWH(10, 160, 70.w, 8.h),
                  );

                  page.graphics.drawString(
                    'Total No. Items Sold: ' +
                        NumberFormat().format(
                            _salesReportProvider.salesReportProductsSold),
                    PdfStandardFont(PdfFontFamily.helvetica, 13),
                    brush: PdfBrushes.black,
                    bounds: Rect.fromLTWH(10, 175, 70.w, 8.h),
                  );

                  PdfGrid grid = PdfGrid();
                  grid.style = PdfGridStyle(
                    font: PdfStandardFont(
                      PdfFontFamily.helvetica,
                      4.5.sp,
                    ),
                  );
                  grid.columns.add(count: 4);
                  grid.headers.add(1);

                  PdfGridRow header = grid.headers[0];
                  header.cells[0].value = 'Invoice No.';
                  header.cells[1].value = 'No. of Items Sold';
                  header.cells[2].value = 'Cash';
                  header.cells[3].value = 'Total';

                  grid.applyBuiltInStyle(
                      PdfGridBuiltInStyle.gridTable5DarkAccent3);

                  for (int i = 0;
                  i < _salesReportProvider.listOfSalesReport.length;
                  i++) {
                    PdfGridRow row = grid.rows.add();
                    row.cells[0].value =
                        _salesReportProvider.listOfSalesReport[i].index.toString();
                    row.cells[0].stringFormat = PdfStringFormat(
                        lineAlignment: PdfVerticalAlignment.middle,
                        alignment: PdfTextAlignment.center);
                    row.cells[1].value = NumberFormat().format(
                        _salesReportProvider
                            .listOfSalesReport[i].numberOfProducts);
                    row.cells[1].stringFormat = PdfStringFormat(
                        lineAlignment: PdfVerticalAlignment.middle,
                        alignment: PdfTextAlignment.center);
                    row.cells[2].value = NumberFormat()
                        .format(_salesReportProvider.listOfSalesReport[i].cash + _salesReportProvider.listOfSalesReport[i].cashIn );
                    row.cells[2].stringFormat = PdfStringFormat(
                        lineAlignment: PdfVerticalAlignment.middle,
                        alignment: PdfTextAlignment.center);

                    row.cells[3].value = NumberFormat().format(
                        (_salesReportProvider.listOfSalesReport[i].cash
                           ));
                    row.cells[3].stringFormat = PdfStringFormat(
                        lineAlignment: PdfVerticalAlignment.middle,
                        alignment: PdfTextAlignment.center);
                  }
                  for (int i = 0; i < header.cells.count; i++) {
                    header.cells[i].style.stringFormat = PdfStringFormat(
                        lineAlignment: PdfVerticalAlignment.middle,
                        alignment: PdfTextAlignment.center);
                  }

                  grid.draw(
                    page: page,
                    bounds: Rect.fromLTWH(0, 19.5.h, 0, 0),
                  );

                  List<int> bytes = await document.save();
                  document.dispose();

                  saveAndLaunchFile(bytes, 'daily_sales_report.pdf');
                } catch (e) {
                  Navigator.of(context).pop();
                }
              },
              child: Icon(
                Icons.print,
                size: 12.sp,
              ))
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Spacer(),
              Padding(
                padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                child: Text(
                    'SALES REPORTS FOR TODAY\'S TRANSACTIONS',
                    style: TextStyle(
                        fontSize: 12.sp, fontFamily: 'Lato', wordSpacing: 12),
                  ),
                ),
              Spacer()
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          !_salesReportProvider.getSalesReportShow()?
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'TOTAL SALES: ₱ ' +
                              NumberFormat()
                                  .format(_salesReportProvider.salesReportCash),
                          style: TextStyle(
                              fontSize: 8.sp,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'TOTAL PROFIT: ₱ ' +
                              NumberFormat()
                                  .format(_salesReportProvider.salesReportGrossSales),
                          style: TextStyle(
                              fontSize: 8.sp,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w600),
                        ),

                        Text(
                          'NO. OF ITEMS SOLD: ' +
                              NumberFormat().format(
                                  _salesReportProvider.salesReportProductsSold),
                          style: TextStyle(
                              fontSize: 8.sp,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    Text(
                      'TOTAL EXPENSES: ₱ ' +
                          NumberFormat().format(
                             _cashOutProvider.overallCashOut
                          ),
                      style: TextStyle(
                          fontSize: 8.sp,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'GROSS PROFIT: ₱ ' +
                          NumberFormat().format(
                              _salesReportProvider.salesReportGrossSales -  _cashOutProvider.overallCashOut),
                      style: TextStyle(
                          fontSize: 8.sp,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ]):Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'TOTAL CASH: ₱ ' +
                    NumberFormat().format(
                        _salesReportProvider.salesReportCash
                    ),
                style: TextStyle(
                    fontSize: 8.sp,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'TOTAL NUMBER OF ITEMS SOLD: ' +
                    NumberFormat().format(
                        _salesReportProvider.salesReportProductsSold),
                style: TextStyle(
                    fontSize: 8.sp,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Expanded(
              child: ValueListenableBuilder<Box<SalesReportModel>>(
                valueListenable: HiveBoxes.getSalesReportData().listenable(),
                builder: (context, box, _) {
                  _salesReportProvider.listOfSalesReport =
                      box.values.toList().cast<SalesReportModel>();
                  return GroupedListView<SalesReportModel, int>(
                    elements: _salesReportProvider.listOfSalesReport,
                    groupBy: (e) => e.index,
                    itemBuilder: (context, e) {
                      return SalesReportTile(salesReportModelTile: e);
                    },
                    groupSeparatorBuilder: (int index) => Container(),
                    itemComparator: (item1, item2) =>
                        item2.index.compareTo(item1.index),
                    order: GroupedListOrder.DESC,
                  );
                },
              ))
        ],
      ),
    );
  }
}
