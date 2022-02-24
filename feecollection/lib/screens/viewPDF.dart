import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class View extends StatefulWidget {
  String url;
  View({required this.url});

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Innovice"),
      ),
      body: Center(
          child: /* _isLoading
              ? Center(child: CircularProgressIndicator())
              : */
              SfPdfViewer.network(widget.url)),
    );
  }
}
