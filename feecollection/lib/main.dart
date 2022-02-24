import 'package:feecollection/constant.dart';
import 'package:feecollection/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Global Fees',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          primaryColor: Colors.deepOrange,
          fontFamily: 'NunitoSans',
          appBarTheme: const AppBarTheme(
            color: Colors.deepOrange,
            elevation: 5,
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        home: SignIn());
  }
}

class SignIn extends StatefulWidget {
  SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  Future<String> checkLandingPage() async {
    if (FirebaseAuth.instance.currentUser != null) {
      return 'home';
    } else {
      return 'signIn';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkLandingPage(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.data == 'home')
            return Scaffold(
              appBar: AppBar(
                title: const Text("Global Fees"),
              ),
              body: Home(),
            );
          if (snapshot.data == 'signIn') return Sign();
          return const Center(child: CircularProgressIndicator());
        });
    /*FirebaseAuth.instance.currentUser
        ? Home()
        : Scaffold(
            body: Center(
              child: MaterialButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signInAnonymously();
                  SignIn();
                },
                child: Text("Sign In Anonymously"),
              ),
            ),
          );*/
  }
}

class Sign extends StatefulWidget {
  Sign({Key? key}) : super(key: key);

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepOrange[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Column(
                children: [
                  Icon(
                    Icons.monetization_on_rounded,
                    color: white,
                    size: 200,
                  ),
                  Text("Global Fee Pay ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: white,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ),
            Center(
              child: MaterialButton(
                color: Colors.amber,
                onPressed: () async {
                  await FirebaseAuth.instance.signInAnonymously();
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (q) => SignIn()));
                },
                child: Text("Sign In Anonymously"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
