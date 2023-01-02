import 'package:flutter/material.dart';
import '../../models/monthly_sales_model.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class MonthlySalesTile extends StatelessWidget {
  final MonthlySalesModel monthlySalesModelTile;
  const MonthlySalesTile({Key? key, required this.monthlySalesModelTile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: SizedBox(
        height: 8.5.h,
        child: Padding(
          padding: EdgeInsets.all(3.sp),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
                      child: Text(
                        'Cash: ₱ ' +
                            NumberFormat().format(monthlySalesModelTile.cash),
                        style: TextStyle(fontFamily: 'Quicksand', fontSize: 8.5.sp),
                      )),
                  Expanded(
                      child: Text(
                        'Ar: ₱ ' + NumberFormat().format(monthlySalesModelTile.ar),
                        style: TextStyle(fontFamily: 'Quicksand', fontSize: 8.5.sp),
                      )),
                  Expanded(
                      child: Text(
                        'Number of Products Sold: ' +
                            NumberFormat()
                                .format(monthlySalesModelTile.numberOfProductsSold),
                        style: TextStyle(fontFamily: 'Quicksand', fontSize: 8.5.sp),
                      )),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.yMMMd().format(monthlySalesModelTile.dateTime),
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Net Sales: ₱ ' +
                        NumberFormat().format(monthlySalesModelTile.netSales),
                    style: TextStyle(fontFamily: 'Quicksand', fontSize: 8.5.sp),
                  ),
                  Text(
                    'Gross Profit: ₱ ' +
                        NumberFormat()
                            .format(monthlySalesModelTile.grossProfit),
                    style: TextStyle(fontFamily: 'Quicksand', fontSize: 8.5.sp),
                  )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
