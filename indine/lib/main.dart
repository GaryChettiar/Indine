import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:indine/firebase_options.dart';
import 'package:indine/home.dart';
import 'package:indine/item_tile.dart';
import 'package:indine/login.dart';
import 'package:indine/model/cart_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var auth = FirebaseAuth.instance;
  bool isLogin = false;

  void checkIfLogin() async {
    auth.authStateChanges().listen((event) {
      if (event != null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  void initState() {
    checkIfLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => isLogin ? HomePage() : LoginPage()),
      );
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(107, 144, 128, 1),
        ),
        child: Center(
          child: Image.asset(
            'assets/logo_transparent.png',
            height: 200,
            width: 200,
          ),
        ),
      ),
    );
  }
}
