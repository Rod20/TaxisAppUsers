import 'package:flutter/cupertino.dart';
import 'package:servisurusers/core/models/taxi_model.dart';

class TaxiProvider with ChangeNotifier{
  List<TaxiModel> _listaTaxis;
  List<TaxiModel> get listaTaxis => this._listaTaxis;
  set listaTaxis(lista){
    this._listaTaxis = lista;
    notifyListeners();
  }
}