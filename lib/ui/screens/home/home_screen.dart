import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:servisurusers/core/api/api_firebase.dart';
import 'package:servisurusers/core/api/api_location.dart';
import 'package:servisurusers/core/providers/taxi_provider.dart';
import 'package:servisurusers/core/utils/user_preferences.dart';
import 'package:servisurusers/ui/resources/app_colors.dart';
import 'package:servisurusers/ui/screens/requestTaxi/request_taxi.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserPreferences prefs = UserPreferences();

  final TextEditingController controller = TextEditingController();


  LocationData position;
  ApiLocation apiUbication = ApiLocation();

  ApiFirebase apiFirebase = ApiFirebase();
  TaxiProvider taxiProvider;

  CollectionReference taxis = FirebaseFirestore.instance.collection('taxis');
  StreamSubscription<LocationData> positionStream;
  int i = 0;

  GoogleMapController mapController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taxiProvider = Provider.of<TaxiProvider>(context,listen: false);
    apiFirebase.taxisConsult(taxiProvider);
    getUbication();
    cargarMarker();
  }

  @override
  void dispose() {
    try {
      positionStream.cancel();
      // mapController.dispose();
      _markers={};
    } catch (e) {
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Radio Taxis Servisur"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: lightPrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                prefs.userPhotoUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: taxisMaps()),
          ],
        ),
      ),
    );
  }

  BitmapDescriptor markerBitMap;
  cargarMarker()async{
    markerBitMap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
            devicePixelRatio: 2.5),'assets/images/icons/carTop.png');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    taxiProvider = Provider.of<TaxiProvider>(context,listen: true);
    print("============DIDCHANGE===========");
    readMarkers();
  }

  readMarkers(){
    _markers={};
    taxiProvider.listaTaxis?.forEach((element) {
      print("####___");
      _markers.add(
          Marker(
            markerId: MarkerId(element.matricula),
            position: LatLng(element.latitude,element.longitude ),
            icon: markerBitMap,
            infoWindow: InfoWindow(
              title: '${element.matricula}',
              snippet: '${element.userName}',
              onTap: () {
                try {
                  showDialog(context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              element.userPhoto,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                        content: Text("hola"),
                      );
                    },
                  );
                } catch (e) {
                }
              },
            ),

            rotation: element.heading,
            anchor: Offset(0.5, 0.5),
          )
      );
      /*if(this.widget.matricula!=null){
        try {
          print("==ENTRO  == ${this.widget.matricula} == $mapController == ${element.latitude} == ${element.longitude}");
          mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(element.latitude,element.longitude ), zoom: 16),
          ));
        } catch (e) {
        }
      }*/
    });

    setState(() {

    });
  }

  getUbication()async{
    try {
      position = await apiUbication.determinePosition();
      print("===> $position");
      try {
        mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(position.latitude,position.longitude ), zoom: 14),
        ));
      } catch (e) {
      }
      setState(() {});
    } catch (e) {
    }
  }

  CameraPosition positionMap = CameraPosition(
      target: LatLng(-16.482557865279468, -68.1214064732194),
      zoom: 16
  );

  Set<Marker> _markers = {};

  Widget taxisMaps() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: Colors.grey[50],
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: positionMap,
            markers: _markers??{},
            myLocationEnabled: true,
            trafficEnabled: false,
            indoorViewEnabled: false,
            myLocationButtonEnabled: true,
            minMaxZoomPreference: MinMaxZoomPreference(12, 20.5),
            rotateGesturesEnabled: false,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: false,
            onMapCreated: (controller) {
              // _controller.complete(controller);
              mapController = controller;
              try {
                rootBundle.loadString('assets/map_style.txt').then((string) {
                  try {
                    mapController.setMapStyle(string);
                  } catch (e) {
                  }
                });
              } catch (e) {
              }
            },
          ),
        ),
        Positioned(
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoButton(
                child: Text("Pedir Taxi"),
                color: extraLightPrimary,
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => RequestTaxi())
                  );
                }
            ),
          ),
        )
      ],
    );
  }
}