import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feecollection/constant.dart';
import 'package:feecollection/screens/viewPDF.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PayFees extends StatefulWidget {
  PayFees({Key? key}) : super(key: key);

  @override
  State<PayFees> createState() => _PayFeesState();
}

class _PayFeesState extends State<PayFees> {
  final _razorpay = Razorpay();
  bool isl = false;
  final pdf = pw.Document();
  late File file;
  String res = "";
  TextEditingController controller = TextEditingController();
  bool isA = false;
  var data;
  late DocumentSnapshot<Map<String, dynamic>> value;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getData();
    controller.text = "37500";
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
          isA = true;
        });
      }
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Do something when payment succeeds
    /* await FirebaseFirestore.instance.collection("history").add({
      "name": "Swaraj Singh",
      "Roll": "303602218056",
      "College": "Shri Shankaracharya Technical Campus",
      "Semester": "7",
      "Section": "D",
      "Date": "${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now())}",
      "Amount": "37500",
      "tId": response.paymentId,
    });*/
    res = response.paymentId.toString();
    await reportView(context, response);
    await uploadFile();

    setState(() {
      isl = false;
    });
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => View(url: downloadUrl)));

/*await reportView(context, response, documentSnapshot).then((value) {
          print(value.toString());
        }).whenComplete(() async {
          await uploadFile().whenComplete(() {
            Navigator.of(context).pop();
            Navigator.popAndPushNamed(context, Trust.routName);
          });
        });*/
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    // Do something when payment fails

    await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Payment Failed"),
          );
        });
    setState(() {
      isl = false;
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pay"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: isA
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                          SizedBox(
                            height: 25,
                          ),
                          Text("Fee Details :",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 26,
                                  color: p1Color,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Name :  ${value["name"]}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          Text("Roll No. :  ${value["Roll"]}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          Text("College :  ${value["College"]}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          Text("Semester :  ${value["Semester"]}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          Text("Section :  ${value["Section"]}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          Text("Date : ${cDate} ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Amount : Rs ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                width: 80,
                                child: TextField(
                                  controller: controller,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 50,
                            width: 100,
                            child: isl
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        setState(() {
                                          isl = true;
                                        });
                                      });
                                      await getPayment();
                                    },
                                    child: Text("Pay")),
                          ),
                        ])
                  : Center(
                      child: Text("No User Available"),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  getPayment() async {
    var options = {
      'key': "rzp_test_3PPu1S760AyU62",
      'amount': int.parse(controller.text) * 100,
      'name': '${value["name"]}',
      'username': "username",
      'description': 'Fees',
      'prefill': {'contact': '8235003502', 'email': 'swarajsingh129@gmail.com'}
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print("errrrrrrrrrooorrrrr is - " + e.toString());
    }
  }

  String cDate = DateFormat('yyyy-MM-dd  kk:mm').format(DateTime.now());
  String finalpath = "";
  String downloadUrl = "";
  Future uploadFile() async {
    file = File(finalpath);
    UploadTask uploadTask;

    Reference docref;
    try {
      docref = FirebaseStorage.instance.ref('Invoice/${DateTime.now()}}.pdf');

      uploadTask = docref.putFile(file);
      await uploadTask.whenComplete(() async {
        downloadUrl = await docref.getDownloadURL();
        if (downloadUrl != "") {
          await FirebaseFirestore.instance.collection("history").add({
            "name": "${value["name"]}",
            "Roll": "${value["Roll"]}",
            "College": "${value["College"]}",
            "Semester": "${value["Semester"]}",
            "Section": "${value["Section"]}",
            "Date": "${cDate}",
            "Amount": int.parse(controller.text),
            "tId": res,
            "InvoiceUrl": downloadUrl
          });
        }
        print("urlll is - " + downloadUrl);
      });
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print("error with firestorage" + e.message.toString());
    }
  }

  Future reportView(
    context,
    PaymentSuccessResponse response,
  ) async {
    /*final svgimage = await rootBundle.loadString("assets/images/barcode.svg");
    final logosvg =
        await rootBundle.loadString("assets/images/AlHisab_logo.svg");
    Uint8List data =
        (await rootBundle.load('assets/images/card.png')).buffer.asUint8List();
*/
    final svgimage = await rootBundle.loadString("assets/images/tick.svg");
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Container(
              decoration: pw.BoxDecoration(color: PdfColor.fromHex("#f56a5d")),
              child: pw.Padding(
                  padding: pw.EdgeInsets.all(12),
                  child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Row(children: [pw.Spacer()]),
                        pw.SizedBox(
                          height: 15,
                        ),
                        pw.Text("Global Fee Payment \nInvoice",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontSize: 38,
                                color: PdfColor.fromHex("#ffffff"),
                                fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 25),
                        pw.Container(
                            height: 100,
                            width: 100,
                            child: pw.SvgImage(svg: svgimage)),
                        pw.SizedBox(height: 10),
                        pw.Text(" Payment Sucessfull ",
                            style: pw.TextStyle(
                                fontSize: 28,
                                color: PdfColor.fromHex("#3deb49"),
                                fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(
                          height: 30,
                        ),
                        pw.Text("Amount : Rs ${controller.text}/-",
                            style: pw.TextStyle(
                                fontSize: 25,
                                color: PdfColor.fromHex("#e0f255"),
                                fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(
                          height: 20,
                        ),
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text("Name :  Swaraj Singh",
                                  style: pw.TextStyle(
                                    fontSize: 18,
                                  )),
                              pw.Text("Roll No. :  303602218056",
                                  style: pw.TextStyle(
                                    fontSize: 18,
                                  )),
                              pw.Text(
                                  "College :  Shri Shankaracharya Technical Campus",
                                  style: pw.TextStyle(
                                    fontSize: 18,
                                  )),
                              pw.Text("Semester :  7",
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                    fontSize: 18,
                                  )),
                              pw.Text("Section :  D",
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                    fontSize: 18,
                                  )),
                              pw.Text("Date : ${cDate} ",
                                  style: pw.TextStyle(
                                    fontSize: 18,
                                  )),
                            ]),
                        pw.SizedBox(height: 16),
                      ])));
        }));
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    print("sasasasasa" + documentPath.toString());

    finalpath = "$documentPath/${DateTime.now()}.pdf";
    final file = File(finalpath);
    print("bbbbbbbbb ---------------- " + finalpath);
    return await file.writeAsBytes(await pdf.save());
  }
}
