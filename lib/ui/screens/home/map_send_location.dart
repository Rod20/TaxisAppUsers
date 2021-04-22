import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:servisurusers/core/api/api_firebase.dart';
import 'package:servisurusers/core/api/api_location.dart';
import 'package:servisurusers/core/providers/taxi_provider.dart';
import 'package:servisurusers/core/utils/user_preferences.dart';
class MapSendLocation extends StatefulWidget {

  final String matricula;

  const MapSendLocation({Key key, this.matricula}) : super(key: key);

  @override
  _MapSendLocationState createState() => _MapSendLocationState();
}

class _MapSendLocationState extends State<MapSendLocation> {
  UserPreferences prefs = UserPreferences();
  LocationData position;
  ApiLocation apiUbication = ApiLocation();

  ApiFirebase apiFirebase = ApiFirebase();
  TaxiProvider taxiProvider;

  CollectionReference taxis = FirebaseFirestore.instance.collection('taxis');

  // StreamController streamController;

  // void onPauseHandler() {
  //   print('on Pause');
  // }
  //
  StreamSubscription<LocationData> positionStream;
  int i = 0;


  @override
  void initState() {
    super.initState();
    taxiProvider = Provider.of<TaxiProvider>(context,listen: false);
    if(this.widget.matricula != null){
      apiFirebase.taxisConsultEnrollment(taxiProvider,this.widget.matricula);
    }else{
      apiFirebase.taxisConsult(taxiProvider);
    }
    // getUbication();
    cargarMarker();
    // positionStream = Geolocator.getPositionStream(
    //   desiredAccuracy: LocationAccuracy.best,
    //   distanceFilter: 2,
    //   // intervalDuration: Duration(seconds: 1),
    //   // forceAndroidLocationManager: true
    //   // timeInterval: 1
    // ).listen(
    //   (Position position) {
    //       _markers = {};
    //       this.position = position;
    //       i = i+1;
    //       print(position == null ? 'Unknown' :
    //         position.latitude.toString() + ', ' +
    //         position.longitude.toString() + ' __ ' +
    //         position.floor.toString()  + ' __ ' +
    //         position.accuracy.toString()  + ' __ ' +
    //         position.altitude.toString()  + ' __ ' +
    //         position.heading.toString()  + ' __ ' +
    //         position.isMocked .toString()  + ' __ ' +
    //         position.speed.toString()  + ' __ ' +
    //         position.speedAccuracy.toString()  + ' __ ' +
    //         position.timestamp.toString()
    //       );
    //       if(position != null){
    //         setState(() {
    //           _markers.add(
    //           Marker(
    //             markerId: MarkerId("MIMARCADOR"),
    //             position: LatLng(position.latitude,position.longitude ),
    //             icon: markerBitMap,
    //             )
    //           );
    //           try {
    //             // mapController.animateCamera(CameraUpdate.newCameraPosition(
    //             // CameraPosition(target: LatLng(position.latitude,position.longitude ), zoom: 16),
    //             // ));
    //             print("========== ${prefs.userFirebaseId}");
    //             taxis
    //             .doc("${prefs.userFirebaseId}")
    //             .set({
    //               'latitude':position.latitude.toString(),
    //               'longitude':position.longitude.toString(),
    //               'floor':position.floor.toString(),
    //               'accuracy':position.accuracy.toString(),
    //               'altitude':position.altitude.toString(),
    //               'heading':position.heading.toString(),
    //               'isMocked':position.isMocked .toString(),
    //               'speed':position.speed.toString(),
    //               'speedAccuracy':position.speedAccuracy.toString(),
    //               'timestamp':position.timestamp.toString(),
    //             })
    //             .then((value) => print("taxi Updated"))
    //             .catchError((error) => print("Failed to update taxi: $error"));
    //           } catch (e) {
    //             print("############ $e #############");
    //           }
    //         });


    //       }
    //   });


  }

  // Declarado fuera del metodo Build
  GoogleMapController mapController;

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


  BitmapDescriptor markerBitMap;
  cargarMarker()async{
    markerBitMap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
            devicePixelRatio: 2.5),'src/icons/carTop.png');
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
      if(this.widget.matricula!=null){
        try {
          print("==ENTRO  == ${this.widget.matricula} == $mapController == ${element.latitude} == ${element.longitude}");
          mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(element.latitude,element.longitude ), zoom: 16),
          ));
        } catch (e) {
        }
      }
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

  // Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.grey[50],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(this.widget.matricula != null ) Text("MATRICULA BUSCADA: ${this.widget.matricula}",
                style: TextStyle(fontSize: 24,color: Colors.blueGrey,fontWeight: FontWeight.w500),
              ),
              Expanded(
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
                      rootBundle.loadString('assets/mapStyle.txt').then((string) {
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
              // Text("  == Datos transferidos           = $i ="),
              // if(position?.latitude!=null)Text("  == latitude                = ${position.latitude} ="),
              // if(position?.longitude!=null)Text("  == longitude              = ${position.longitude} ="),
              // if(position?.floor!=null)Text("  == floor                      = ${position.floor} ="),
              // if(position?.accuracy!=null)Text("  == accuracy                = ${position.accuracy} ="),
              // if(position?.altitude!=null)Text("  == altitude                   = ${position.altitude} ="),
              // if(position?.heading!=null)Text("  == heading                   = ${position.heading} ="),
              // if(position?.isMocked!=null)Text("  == isMocked                = ${position.isMocked} ="),
              // if(position?.speed!=null)Text("  == speed                      = ${position.speed} "),
              // if(position?.speedAccuracy!=null)Text("  == speedAccuracy      = ${position.speedAccuracy} ="),
              // if(position?.timestamp!=null)Text("  == timestamp              = ${position.timestamp} ="),

            ],
          ),
        ),
      ),
    );
  }

  // markersFromList(){
  //   _markers={};

  //   taxiProvider.listaTaxis.forEach((element) {
  //     _markers.add(
  //       Marker(
  //         markerId: MarkerId(element.timestamp),
  //         position: LatLng(position.latitude,position.longitude ),
  //         icon: markerBitMap,
  //         )
  //       );
  //   });
  // }

  //////////////////////////////////////////////
  ///
  Set<Marker> _markers = {};

}