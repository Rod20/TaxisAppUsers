import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:servisurusers/core/models/taxi_model.dart';
import 'package:servisurusers/core/providers/taxi_provider.dart';

class ApiFirebase {


  Future<User> signInWithGoogle() async {
    print('========================');
    // Trigger the authentication flow
    GoogleSignInAccount googleUser ;
    try {
      googleUser = await GoogleSignIn().signIn();
    } catch (e) {
      print('=========== $e ==');
    }

    // Obtain the auth details from the request
    GoogleSignInAuthentication googleAuth;
    try {
      googleAuth = await googleUser.authentication;
    } catch (e) {
      print('=========== $e ==');
    }
    // Create a new credential

    GoogleAuthCredential credential ;

    try {
      credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
    } catch (e) {
      print('=========== $e ==');
    }

    // Once signed in, return the UserCredential
    var firebaseUser = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    return firebaseUser;
  }

  taxisConsult(TaxiProvider taxiProvider){
    List<TaxiModel> listaTaxis = [];
    FirebaseFirestore.instance
        .collection('taxis')
        .snapshots().listen((querySnapshot) {
      print("""
      ================================================================
      """);
      querySnapshot.docs.forEach((doc) {
        print("""
      ##########
      """);

        TaxiModel taxiModel = TaxiModel.fromJson(doc.data());

        print(doc.data());
        listaTaxis.add(taxiModel);
      });
      taxiProvider.listaTaxis = listaTaxis;
      // return listaOrderFinalModel;
    }).onError((c){
      print("ERROR $c");
      // return listaOrderFinalModel;
    });
  }

  taxisConsultEnrollment(TaxiProvider taxiProvider,String matricula){
    List<TaxiModel> listaTaxis = [];
    FirebaseFirestore.instance
        .collection('taxis').where('matricula',isEqualTo: matricula)
        .snapshots().listen((querySnapshot) {
      print("""
      ================================================================
      """);
      querySnapshot.docs.forEach((doc) {
        print("""
      ##########
      """);

        TaxiModel taxiModel = TaxiModel.fromJson(doc.data());

        print(doc.data());
        listaTaxis.add(taxiModel);
      });
      taxiProvider.listaTaxis = listaTaxis;
      // return listaOrderFinalModel;
    }).onError((c){
      print("ERROR $c");
      // return listaOrderFinalModel;
    });
  }
}