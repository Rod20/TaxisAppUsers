import 'package:flutter/material.dart';
import 'package:servisurusers/core/utils/user_preferences.dart';
import 'package:servisurusers/ui/resources/app_colors.dart';
import 'package:servisurusers/ui/widgets/login_button.dart';

class RequestTaxi extends StatelessWidget {

  UserPreferences prefs = new UserPreferences();
  bool _favoritesVisible = false;

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
    return Column(
      children: [
        Text(
          "Sr(a).: "+ prefs.userName,
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
        RaisedButton(
          color: extraLightPrimary,
          onPressed: (){
            _favoritesVisible = !_favoritesVisible;
          },
          child: Text(
            "Favoritos",
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        _favoritesVisible
        ? ListView()
            : Container(),
        RaisedButton(
          onPressed: (){

          },
          child: Text(
            "Elige tu destino",
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        Center(
          child: LoginButton(
            textButton: "SOLICITAR",
            onPressed: (){

            }
          ),
        )
      ],
    );
  }
}
