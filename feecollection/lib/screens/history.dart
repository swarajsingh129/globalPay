import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feecollection/constant.dart';
import 'package:feecollection/screens/viewPDF.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List data = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdate();
  }

  getdate() async {
    data = [];
    await FirebaseFirestore.instance
        .collection("history")
        .orderBy("Date", descending: true)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          print("dataaaaaaaa   " + element.data().toString());
          data.add(element.data());
        });
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: data.length == 0
          ? Center(
              child: Text("No Data Available"),
            )
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    child: ListTile(
                      leading: Icon(
                        Icons.history,
                        color: p1Color,
                      ),
                      title: Text(
                        "ID - " + data[i]["tId"],
                        style: TextStyle(color: p1Color),
                      ),
                      subtitle: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name :  ${data[i]["name"]}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                )),
                            Text("Roll No. :  ${data[i]["Roll"]}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                )),
                            Text("College :  ${data[i]["College"]}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14,
                                )),
                            Text("Semester : ${data[i]["Semester"]}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                )),
                            Text("Section : ${data[i]["Section"]}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                )),
                            Text("Date : ${data[i]["Date"]} ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Amount : Rs${data[i]["Amount"]}/-",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => View(
                                                  url: data[i]["InvoiceUrl"],
                                                )));
                                  },
                                  child: Text("View",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16, color: p1Color)),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title:
                                                Text("Downloaded Successfully"),
                                          );
                                        });
                                  },
                                  child: Text("Download",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16, color: p1Color)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
