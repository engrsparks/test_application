import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../models/monthly_sales_model.dart';
import '../../models/hive_boxes.dart';
import 'monthly_sales_tile.dart';
import '../models/pdf_api.dart';

class MonthlySalesScreen extends StatelessWidget {
  const MonthlySalesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final TextEditingController _authorizationCodeController =
    TextEditingController();

    final String _authorizationCode = '1010';

    final _monthlySalesProvider =
    Provider.of<MonthlySalesModelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.redAccent,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back,size: 10.sp,)),
        title: Text(
          'MONTHLY SALES',
          style: TextStyle(fontSize: 12.sp, fontFamily: 'Quicksand'),
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
                          height: 18.5.h,
                          width: 50.w,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5.0.sp),
                                  child: TextField(
                                    obscureText: true,
                                    controller:
                                    _authorizationCodeController,
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: 'Quicksand'),
                                    decoration: InputDecoration(
                                        hintText:
                                        'Enter Authorization Code',
                                        hintStyle:
                                        TextStyle(fontSize: 10.sp)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 4.h),
                                  child: Container(
                                    height: 5.h,
                                    width: 18.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        gradient: LinearGradient(
                                            colors: const [
                                              Colors.green,
                                              Colors.blue
                                            ])),
                                    child: TextButton(
                                      onPressed: () {
                                        if (_authorizationCodeController
                                            .text ==
                                            _authorizationCode) {
                                          HiveBoxes.getMonthlySalesData()
                                              .clear();
                                          _authorizationCodeController
                                              .clear();
                                          Navigator.of(context).pop();
                                        } else {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: Text(
                                        'Confirm',
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            fontFamily: 'Quicksand',
                                            color: Colors.white),
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
              child: Text('CLEAR',
                  style: TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'Quicksand',
                      color: Colors.white))),
          SizedBox(width: 5.w,),
          IconButton(
              onPressed: () async {
                try {
                  PdfDocument document = PdfDocument();
                  final page = document.pages.add();
                  //Draw rectangle
                  page.graphics.drawRectangle(
                      brush: PdfSolidBrush(PdfColor(66, 182, 245, 255)),
                      bounds: Rect.fromLTWH(0, 0, 70.w, 8.h));

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
                      'ANNUAL SALES REPORT \n' +
                          DateFormat.y().format(DateTime.now()),
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
                            .format(_monthlySalesProvider.monthlySalesCash),
                    PdfStandardFont(PdfFontFamily.helvetica, 13),
                    brush: PdfBrushes.black,
                    bounds: Rect.fromLTWH(10, 145, 70.w, 8.h),
                  );

                  page.graphics.drawString(
                    'Total Sales: ' +
                        NumberFormat().format(
                            _monthlySalesProvider.monthlySalesCash
                              ),
                    PdfStandardFont(PdfFontFamily.helvetica, 13),
                    brush: PdfBrushes.black,
                    bounds: Rect.fromLTWH(10, 160, 70.w, 8.h),
                  );
                  page.graphics.drawString(
                    'Total Items Items: ' +
                        NumberFormat()
                            .format(_monthlySalesProvider.monthlySalesProductsSold),
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
                  grid.columns.add(count: 5);
                  grid.headers.add(1);

                  PdfGridRow header = grid.headers[0];
                  header.cells[0].value = 'Month';
                  header.cells[1].value = 'No. of Items Sold';
                  header.cells[2].value = 'Cash';
                  header.cells[3].value = 'Cheque';
                  header.cells[4].value = 'Total';

                  grid.applyBuiltInStyle(
                      PdfGridBuiltInStyle.gridTable5DarkAccent3);

                  for (int i = 0;
                  i < _monthlySalesProvider.listOfMonthlySales.length;
                  i++) {
                    PdfGridRow row = grid.rows.add();
                    row.cells[0].value = DateFormat.yMMMM().format(
                        _monthlySalesProvider.listOfMonthlySales[i].dateTime);
                    row.cells[0].stringFormat = PdfStringFormat(
                        lineAlignment: PdfVerticalAlignment.middle,
                        alignment: PdfTextAlignment.center);

                    row.cells[1].value = NumberFormat().format(
                        _monthlySalesProvider
                            .listOfMonthlySales[i].numberOfProductsSold);
                    row.cells[1].stringFormat = PdfStringFormat(
                        lineAlignment: PdfVerticalAlignment.middle,
                        alignment: PdfTextAlignment.center);

                    row.cells[2].value = NumberFormat()
                        .format(_monthlySalesProvider.listOfMonthlySales[i].cash);
                    row.cells[2].stringFormat = PdfStringFormat(
                        lineAlignment: PdfVerticalAlignment.middle,
                        alignment: PdfTextAlignment.center);


                    row.cells[3].value = NumberFormat().format(
                        (_monthlySalesProvider.listOfMonthlySales[i].cash
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
                    bounds: Rect.fromLTWH(0, 20.5.h, 0, 0),
                  );

                  List<int> bytes =await document.save();
                  document.dispose();

                  saveAndLaunchFile(bytes, 'annual_sales_report.pdf');
                } catch (e) {
                  Navigator.of(context).pop();
                }
              },
              icon: Icon(
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
          Expanded(
            child: ValueListenableBuilder<Box<MonthlySalesModel>>(
                valueListenable: HiveBoxes.getMonthlySalesData().listenable(),
                builder: (context, box, _) {
                  _monthlySalesProvider.listOfMonthlySales =
                      box.values.toList().cast<MonthlySalesModel>();
                  return GroupedListView<MonthlySalesModel, DateTime>(
                    elements: _monthlySalesProvider.listOfMonthlySales,
                    groupBy: (e) => e.dateTime,
                    itemBuilder: (context, e) {
                      return MonthlySalesTile(monthlySalesModelTile: e);
                    },
                    groupSeparatorBuilder: (DateTime date) => Text(''),
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
