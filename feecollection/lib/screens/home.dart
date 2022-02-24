import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feecollection/constant.dart';
import 'package:feecollection/main.dart';
import 'package:feecollection/screens/about.dart';
import 'package:feecollection/screens/history.dart';
import 'package:feecollection/screens/payfees.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DocumentSnapshot<Map<String, dynamic>> value;
  bool isA = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future getData() async {
    await FirebaseFirestore.instance
        .collection("testUser")
        .doc("Yg4g9ofbjnCUBaVhmacI")
        .get()
        .then((value1) {
      if (value1.exists) {
        value = value1;
        setState(() {
          isA = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.width,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        child: Image.asset("assets/images/person.png"),
                        radius: 50,
                      ),
                    ),
                    isA
                        ? Row(
                            children: [
                              Center(
                                child: CircularProgressIndicator(),
                              ),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 30, left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${value["name"]}",
                                  style:
                                      TextStyle(color: p1Color, fontSize: 25),
                                ),
                                Text(
                                  "Phone : +91 ${value["Phone"]}",
                                  style:
                                      TextStyle(color: p1Color, fontSize: 15),
                                ),
                                Text(
                                  "Semester : ${value["Semester"]} ${value["Section"]}",
                                  style:
                                      TextStyle(color: p1Color, fontSize: 15),
                                ),
                                Text(
                                  "RollNo. : ${value["Roll"]}",
                                  style:
                                      TextStyle(color: p1Color, fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) => SignIn()));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Log Out ",
                                        style: TextStyle(
                                            color: Colors.indigoAccent,
                                            fontSize: 18),
                                      ),
                                      Icon(
                                        Icons.logout,
                                        size: 18,
                                        color: Colors.indigoAccent,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              padding: EdgeInsets.all(8.0),
              childAspectRatio: 1,
              children: [
                Card(
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PayFees()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: Image.asset("assets/images/pay.png"),
                        ),
                        Text(
                          "Pay Fees",
                          style: TextStyle(color: p1Color, fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => History()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: Image.asset("assets/images/history.png"),
                        ),
                        Text(
                          "History",
                          style: TextStyle(color: p1Color, fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      dailogbox();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: Image.asset("assets/images/edu.png"),
                        ),
                        Text(
                          "Exam Details",
                          style: TextStyle(color: p1Color, fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      dailogbox();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: Image.asset("assets/images/acad.png"),
                        ),
                        Text(
                          "Academic",
                          style: TextStyle(color: p1Color, fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => About()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: Image.asset("assets/images/about.png"),
                        ),
                        Text(
                          "About",
                          style: TextStyle(color: p1Color, fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                )
              ]),
        ],
      ),
    ));
  }

  dailogbox() {
    return showDialog(
        context: context,
        builder: (contaxt) {
          return CupertinoAlertDialog(
            title: Text("Feature Comming Soon..."),
          );
        });
  }
}
