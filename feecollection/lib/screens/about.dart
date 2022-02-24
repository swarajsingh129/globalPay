import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Card(
            child: Text(
                "About the app \n. \n. \n. \n. \n. \n. \n. \n. \n. \n. \n. \n. \n. \n. \n. \n. \n. \n. \n. \n. \n. \n. \n. \n. \n. \n.  Over."),
          ),
        ),
      ),
    );
  }
}
