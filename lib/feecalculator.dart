import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class feeCalculator extends StatefulWidget {
  @override
  final String name;
  final int total;
  List<dynamic> dates;
  feeCalculator({required this.name, required this.total, required this.dates});
  _feeCalculatorState createState() =>
      _feeCalculatorState(name: name, total: total, dates: dates);
}

class _feeCalculatorState extends State<feeCalculator> {
  @override
  final String name;
  final int total;
  List<dynamic> dates;
  _feeCalculatorState(
      {required this.name, required this.total, required this.dates});
  Widget build(BuildContext context) {
    List<dynamic> dt = dates.map((date) => date.toDate()).toList();
    for (var i = 0; i < dt.length; i++) {
      dt[i] = DateFormat('dd-MM-yyyy – kk:mm').format(dt[i]);
      print(dt[i]);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(name + ": Fee Pending: " + total.toString()),
        ),
        body: ListView.builder(
            itemCount: dt.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(dt[index].toString()),
              );
            }));
  }
}
