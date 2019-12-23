
import 'package:architech1/Firebase.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';
import 'Login Screen/loginPageController.dart';
import 'User.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget _waitPhoto() {
    return Scaffold(
      body: new Center(
        child: new Image.asset('assets/pet.png'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase().checkUser(),
      builder: (context, value) {
        print(value);

        if (value.hasData) {
          user.uid = value.data.uid;
          return HomePage();
        } else if (value.connectionState == ConnectionState.done &&
            !value.hasData) {
          return LoginPage();
        } else if (value.connectionState == ConnectionState.waiting) {
          return _waitPhoto();
        }
        return Container();
      },
    );
  }
}
