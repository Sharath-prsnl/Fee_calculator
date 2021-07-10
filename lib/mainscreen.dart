import 'package:fee_calculator/feecalculator.dart';
import 'package:flutter/material.dart';
import 'package:fee_calculator/addnew.dart';
import 'package:fee_calculator/Data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class mainscreen extends StatefulWidget {
  @override
  _mainscreenState createState() => _mainscreenState();
}

class _mainscreenState extends State<mainscreen> {
  // late final Data data;
  // List<Map<String, Object>> names = [
  //   {
  //     "name": "Abheesh",
  //     "fees": 400,
  //     "classes": 3,
  //   },
  //   {
  //     "name": "Prathyush",
  //     "fees": 450,
  //     "classes": 3,
  //   },
  //   {
  //     "name": "Girl1",
  //     "fees": 350,
  //     "classes": 4,
  //   },
  //   {
  //     "name": "Girl2",
  //     "fees": 350,
  //     "classes": 4,
  //   },
  //   {
  //     "name": "Sharath",
  //     "fees": 500,
  //     "classes": 3,
  //   },
  // ];

  @override
  // Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  //   return ListView(
  //     padding: const EdgeInsets.only(top: 20.0),
  //     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  //   );
  // }

  // Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  //   final record = Record.fromSnapshot(data);

  //   return Padding(
  //     key: ValueKey(record.name),
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: Colors.grey),
  //         borderRadius: BorderRadius.circular(5.0),
  //       ),
  //       child: Card(
  //         child: Column(children: [
  //           ListTile(
  //             title: Text(record.name),
  //           ),
  //           ButtonBar(
  //             alignment: MainAxisAlignment.start,
  //             children: [
  //               ElevatedButton(
  //                 // textColor: const Color(0xFF6200EE),
  //                 onPressed: () {
  //                   //Navigator.of(context).pop();
  //                   Navigator.of(context).push(
  //                     MaterialPageRoute(
  //                         builder: (context) => feeCalculator(
  //                               name: record.name,
  //                               total: (record.fees * record.classes),
  //                             )),
  //                   );
  //                 },
  //                 child: const Text('Calculate'),
  //               ),
  //               Spacer(),
  //               Spacer(),
  //               Align(
  //                 alignment: Alignment.centerRight,
  //                 child: ElevatedButton(
  //                   onPressed: () {},
  //                   child: Icon(Icons.add),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ]),
  //       ),
  //     ),
  //   );
  // }

  // Widget buildBody(BuildContext context, int index) {
  //   // Data data = new Data(
  //   //     name: names[index]["name"].toString(),
  //   //     fees: int.parse(names[index]["fees"].toString()),
  //   //     classes: int.parse(names[index]["classes"].toString()));

  // }

  Widget build(BuildContext context) {
    final students = FirebaseFirestore.instance.collection("students");
    return Scaffold(
      appBar: AppBar(
        title: Text("My Guitar Students"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: students.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            return ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctxt, index) {
                return Card(
                  child: Column(children: [
                    ListTile(
                      title: Text(snapshot.data!.docs[index]['name'] + "             FEE: " + snapshot.data!.docs[index]['fees'].toString()),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          // textColor: const Color(0xFF6200EE),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => feeCalculator(
                                        name: snapshot.data!.docs[index]
                                            ['name'],
                                        total: (snapshot.data!.docs[index]
                                                ['fees'] *
                                            snapshot.data!.docs[index]
                                                ['classes']),
                                        dates: snapshot.data!.docs[index]
                                            ['dates'],
                                      )),
                            );
                          },
                          child: const Text('Calculate'),
                        ),
                        Spacer(),
                        Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              var x = snapshot.data!.docs[index].reference;
                              DateTime currentDate = DateTime.now();
                              // print(currentDate.);
                              Timestamp today = Timestamp.fromDate(currentDate);
                              DateTime date = today.toDate();
                              x.update({
                                'classes': FieldValue.increment(1),
                                'dates': FieldValue.arrayUnion([date]),
                              });
                            },
                            child: Text(snapshot.data!.docs[index]['classes'].toString()),
                          ),
                        ),
                        Spacer(),
                        Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              var x = snapshot.data!.docs[index].reference;
                              x.update({
                                'classes': 0,
                                'dates': new List<DateTime>.empty(),
                              });
                            },
                            child: Text("RESET"),
                          ),
                        Spacer(),
                        Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              var x = snapshot.data!.docs[index].reference;
                              x.delete();
                            },
                            child: Icon(Icons.delete_outlined,),
                          ),
                      ],
                    ),
                  ]),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => newStudent()),
          );
        },
        label: const Text('Add Student'),
        icon: const Icon(
          Icons.person_add,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}

// class Record {
//   final String name;
//   final int classes;
//   final int fees;
//   final DocumentReference reference;

//   Record.fromMap(Map<String, dynamic> map, {required this.reference})
//       : assert(map['name'] != null),
//         assert(map['classes'] != null),
//         assert(map['fees'] != null),
//         name = map['name'],
//         classes = map['classes'],
//         fees = map['fees'];

//   Record.fromSnapshot(DocumentSnapshot snapshot)
//       : this.fromMap(snapshot.data(), reference: snapshot.reference);

//   @override
//   String toString() => "Record<$name:$classes>";
// }
