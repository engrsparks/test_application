import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:grouped_list/grouped_list.dart';
import 'daily_sales_tile.dart';
import '../../models/daily_sales_model.dart';
import '../../models/monthly_sales_model.dart';
import '../../models/pdf_api.dart';
import '../../models/hive_boxes.dart';

class DailySalesScreen extends StatefulWidget {
  const DailySalesScreen({Key? key}) : super(key: key);

  @override
  State<DailySalesScreen> createState() => _DailySalesScreenState();
}

class _DailySalesScreenState extends State<DailySalesScreen> {
  @override
  Widget build(BuildContext context) {
    final _dailySalesProvider = Provider.of<DailySalesModelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,

        title: GestureDetector(
          onDoubleTap: (){
            _dailySalesProvider.dailySalesShow();
          },
          child: Text(
              'DAILY SALES',
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
                                          onPressed:
                                          _dailySalesProvider
                                              .listOfDailySales
                                              .isEmpty
                                              ? null
                                              : () {
                                            Provider.of<MonthlySalesModelProvider>(context, listen: false).addMonthlySales(
                                                _dailySalesProvider
                                                    .dailySalesCash,

                                                (_dailySalesProvider
                                                    .dailySalesCash ),
                                                _dailySalesProvider
                                                    .dailyGrossSales,
                                                _dailySalesProvider
                                                    .dailySalesProductsSold, _dailySalesProvider.dailyExpenses);
                                            HiveBoxes
                                                .getDailySalesData()
                                                .clear();
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
                                                ],
                                                begin: Alignment.bottomRight,
                                                end: Alignment.topLeft)),
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
                  //Draw string enterpriseNameForPrint: Hive

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
                      'MONTHLY SALES REPORT \n' +
                          DateFormat.yMMMM().format(DateTime.now()),
                      PdfStandardFont(PdfFontFamily.helvetica, 17),
                      brush: PdfBrushes.white,
                      bounds: Rect.fromLTWH(10, 17.2, 70.w, 8.h),
                      format: PdfStringFormat(
                          alignment: PdfTextAlignment.center,
                          lineSpacing: 5,
                          lineAlignment: PdfVerticalAlignment.middle));

                  page.graphics.drawString(
                    'Total Cash: ' +
                        NumberFormat()
                            .format(_dailySalesProvider.dailySalesCash),
                    PdfStandardFont(PdfFontFamily.helvetica, 13),
                    brush: PdfBrushes.black,
                    bounds: Rect.fromLTWH(10, 145, 70.w, 8.h),
                  );

                  page.graphics.drawString(
                    'Total Expenses: ' +
                        NumberFormat()
                            .format(_dailySalesProvider.dailyExpenses),
                    PdfStandardFont(PdfFontFamily.helvetica, 13),
                    brush: PdfBrushes.black,
                    bounds: Rect.fromLTWH(10, 160, 70.w, 8.h),
                  );

                  page.graphics.drawString(
                    'Total Sales: ' +
                        NumberFormat().format(
                            _dailySalesProvider.dailySalesCash
                               ),
                    PdfStandardFont(PdfFontFamily.helvetica, 13),
                    brush: PdfBrushes.black,
                    bounds: Rect.fromLTWH(10, 175, 70.w, 8.h),
                  );
                  page.graphics.drawString(
                    'Total Items Sold: ' +
                        NumberFormat()
                            .format(_dailySalesProvider.dailySalesProductsSold),
                    PdfStandardFont(PdfFontFamily.helvetica, 13),
                    brush: PdfBrushes.black,
                    bounds: Rect.fromLTWH(10, 190, 70.w, 8.h),
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
                  header.cells[0].value = 'Date';
                  header.cells[1].value = 'No. of Items Sold';
                  header.cells[2].value = 'Cash';
                  header.cells[3].value = 'Total';


                  grid.applyBuiltInStyle(
                      PdfGridBuiltInStyle.gridTable5DarkAccent3);

                  for (int i = 0;
                  i < _dailySalesProvider.listOfDailySales.length;
                  i++) {
                    PdfGridRow row = grid.rows.add();
                    row.cells[0].value = DateFormat.yMMMd().format(
                        _dailySalesProvider.listOfDailySales[i].dateTime);
                    row.cells[0].stringFormat = PdfStringFormat(
                        lineAlignment: PdfVerticalAlignment.middle,
                        alignment: PdfTextAlignment.center);

                    row.cells[1].value = NumberFormat().format(
                        _dailySalesProvider
                            .listOfDailySales[i].numberOfProducts);
                    row.cells[1].stringFormat = PdfStringFormat(
                        lineAlignment: PdfVerticalAlignment.middle,
                        alignment: PdfTextAlignment.center);

                    row.cells[2].value = NumberFormat()
                        .format(_dailySalesProvider.listOfDailySales[i].cash);
                    row.cells[2].stringFormat = PdfStringFormat(
                        lineAlignment: PdfVerticalAlignment.middle,
                        alignment: PdfTextAlignment.center);


                    row.cells[3].value = NumberFormat().format(
                        (_dailySalesProvider.listOfDailySales[i].cash));
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
                    bounds: Rect.fromLTWH(0, 20.5.h, 0, 0),
                  );

                  List<int> bytes = await document.save() ;
                  document.dispose();

                  saveAndLaunchFile(bytes, 'monthly_sales_report.pdf');
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
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Our Management System is Powered by Catalyst.',
                      style: TextStyle(
                          fontSize: 6.sp,
                          fontFamily: 'Lato',
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          !_dailySalesProvider.getDailySalesShow()?
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL SALES: ₱ ' +
                          NumberFormat()
                              .format(_dailySalesProvider.dailySalesCash),
                      style: TextStyle(
                          fontSize: 8.sp,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'TOTAL PROFIT: ₱ ' +
                          NumberFormat()
                              .format(_dailySalesProvider.dailyGrossSales),
                      style: TextStyle(
                          fontSize: 8.sp,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w600),
                    ),

                    Text(
                      'NO. OF ITEMS SOLD: ' +
                          NumberFormat().format(
                              _dailySalesProvider.dailySalesProductsSold),
                      style: TextStyle(
                          fontSize: 8.sp,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w600),
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
                              _dailySalesProvider.dailyExpenses),
                      style: TextStyle(
                          fontSize: 8.sp,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'GROSS PROFIT: ₱ ' +
                          NumberFormat()
                              .format(_dailySalesProvider.dailyGrossSales - _dailySalesProvider.dailyExpenses),
                      style: TextStyle(
                          fontSize: 8.sp,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ]):Container(),
          Expanded(
            child: ValueListenableBuilder<Box<DailySalesModel>>(
                valueListenable: HiveBoxes.getDailySalesData().listenable(),
                builder: (context, box, _) {
                  _dailySalesProvider.listOfDailySales =
                      box.values.toList().cast<DailySalesModel>();
                  return GroupedListView<DailySalesModel, DateTime>(
                    elements: _dailySalesProvider.listOfDailySales,
                    groupBy: (e) => e.dateTime,
                    itemBuilder: (context, e) {
                      return DailySalesTile(dailySalesModelTile: e);
                    },
                    groupSeparatorBuilder: (DateTime date) => Text(
                      '',
                      style: TextStyle(fontSize: 0),
                    ),
                    itemComparator: (item1, item2) =>
                        item1.dateTime.compareTo(item2.dateTime),
                    order: GroupedListOrder.DESC,
                  );
                }),
          )
        ],
      ),
    );
  }
}
