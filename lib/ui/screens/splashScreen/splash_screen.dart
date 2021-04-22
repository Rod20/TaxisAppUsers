import 'package:custom_splash/custom_splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servisurusers/ui/screens/auth/auth_screen.dart';
import 'package:servisurusers/ui/screens/home/home_screen.dart';
// ignore: must_be_immutable
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget one ;

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    print('== ${auth.currentUser}');
    if(auth.currentUser!=null){
      print('SI HAY USUARIO');
      one = HomeScreen();
    }else{
      print('NO HAY USUARIO');
      one = AuthScreen();

    }

  }

  @override
  Widget build(BuildContext context) {
    return CustomSplash(
      imagePath: 'assets/icon/icon.png',
      // backGroundColor: Colors.deepOrange,
      animationEffect: 'zoom-in',
      logoSize: 200,
      home: one,
      // customFunction: ()=>Future.delayed(Duration(seconds: 3))
      duration: 2500,
      type: CustomSplashType.StaticDuration,
    );
  }
}