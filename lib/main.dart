import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servisurusers/core/providers/taxi_provider.dart';
import 'package:servisurusers/core/utils/user_preferences.dart';
import 'package:servisurusers/ui/screens/auth/auth_screen.dart';
import 'package:servisurusers/ui/screens/splashScreen/splash_screen.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = UserPreferences();
  prefs.initPreferences();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot){
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => TaxiProvider()),
          ],
          child: MaterialApp(
            title: 'ServiSur',
            theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'Poppins',
            ),
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          ),
        );
      },
    );
  }
}
