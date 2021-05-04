import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:servisurusers/core/utils/user_preferences.dart';
import 'package:servisurusers/ui/resources/app_colors.dart';
import 'package:servisurusers/ui/screens/requestTaxi/map_view.dart';
import 'package:servisurusers/ui/widgets/login_button.dart';

class RequestTaxi extends StatelessWidget {

  UserPreferences prefs = new UserPreferences();
  bool _favoritesVisible = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Solicitar Taxi"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: lightPrimary,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8,),
          Text(
            "Usuario: "+ prefs.userName,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "¿A dónde se dirige?",
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 16),
          RaisedButton(
            color: extraLightPrimary,
            onPressed: (){
              _favoritesVisible = !_favoritesVisible;
            },
            child: Text(
              "Favoritos",
              style: TextStyle(
                fontSize: 16.0,
                  color: lightAccent
              ),
            ),
          ),
          _favoritesVisible
          ? ListView()
              : Container(),
          RaisedButton(
            color: lightPrimary,
            onPressed: (){
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => MapView())
              );
            },
            child: Text(
              "Elige tu destino",
              style: TextStyle(
                fontSize: 16.0,
                color: lightAccent
              ),
            ),
          ),
          Center(
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              color: greyBG,
              child: Text(
                "SOLICITAR",
                style: TextStyle(
                  color: lightPrimary,
                  fontSize: 18.0
                ),
              ),
              onPressed: () async {
                try {
                  await firestore.collection('users').doc('requestTaxi').set({
                    'username': prefs.userName,
                    'phone': 213,
                    'destination': "por_ir",
                    'origin': "ubicacion_actual"
                  });
                } catch (e) {
                  print(e);
                }
              }
            ),
          )
        ],
      ),
    );
  }
}
