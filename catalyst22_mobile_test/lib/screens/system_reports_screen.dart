import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import '../../models/system_reports_model.dart';
import '../../models/hive_boxes.dart';

class SystemReportsScreen extends StatelessWidget {
  const SystemReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _reportProvider = Provider.of<SystemReportsModelProvider>(context);
    final TextEditingController _authorizationCodeController =
    TextEditingController();
    const String _authorizationCode = '248258';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          'SYSTEM REPORTS',
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
                                    keyboardType: TextInputType.number,
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
                                          HiveBoxes.getSystemReportsData()
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
              child: ValueListenableBuilder<Box<SystemReportsModel>>(
                  valueListenable:
                  HiveBoxes.getSystemReportsData().listenable(),
                  builder: (context, box, _) {
                    _reportProvider.systemReports =
                        box.values.toList().cast<SystemReportsModel>();
                    return GroupedListView<SystemReportsModel, DateTime>(
                      elements: _reportProvider.systemReports,
                      groupBy: (e) => e.dateTime,
                      itemBuilder: (context, e) {
                        return Card(
                          elevation: 8.0,
                          child: SizedBox(
                            height: 7.h,
                            child: Padding(
                              padding: EdgeInsets.all(3.0.sp),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        e.description,
                                        style: TextStyle(
                                            fontSize: 8.5.sp,
                                            fontFamily: 'Quicksand'),
                                      ),
                                      Text(
                                        DateFormat().format(e.dateTime),
                                        style: TextStyle(
                                            fontSize: 8.sp,
                                            fontFamily: 'Quicksand'),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      groupSeparatorBuilder: (DateTime date) => Text(
                        '',
                        style: TextStyle(fontSize: 0),
                      ),
                      itemComparator: (item1, item2) =>
                          item1.dateTime.compareTo(item2.dateTime),
                      order: GroupedListOrder.DESC,
                    );
                  })),
        ],
      ),
    );
  }
}
