import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class TelaMapMotoboy extends StatefulWidget {
  @override
  _TelaMapMotoboyState createState() => _TelaMapMotoboyState();

  DocumentSnapshot documents;
  String idDocumento;
  BuildContext context;
  String emailDoSolicitante;

  TelaMapMotoboy(
      this.documents, this.idDocumento, this.context, this.emailDoSolicitante);
}

class _TelaMapMotoboyState extends State<TelaMapMotoboy> {
  Completer<GoogleMapController> _controller = Completer();

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  CameraPosition _posicaoCamera =
      CameraPosition(target: LatLng(-6.8877196, -38.5646918));

  _adicionarListenerLocalizacao() {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 19);
      _movimentarCamera(_posicaoCamera);
    });
  }

  _recuperarUltimaLocalizacaoConhecida() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      if (position != null) {
        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 19);
      }
      _movimentarCamera(_posicaoCamera);
    });
  }

  _movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
    super.initState();
    _recuperarUltimaLocalizacaoConhecida();
    _adicionarListenerLocalizacao();
    //print("dados entrega: " + widget.documents.data["Nome cliente"]);
  }

  aceitarEntrega() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    Map<String, dynamic> _docs = {
      "nome_cliente": widget.documents.data["nome_cliente"],
      "rua": widget.documents.data["rua"],
      "bairro": widget.documents.data["bairro"],
      "numero": widget.documents.data["numero"],
      "telefone": widget.documents.data["telefone"],
      "descricao": widget.documents.data["descricao"],
      "email_motoboy": _user.email
    };
    return _docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 35),
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _posicaoCamera,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
            Positioned(
              bottom: 10,
              right: 70,
              child: ButtonTheme(
                height: 40,
                minWidth: 120,
                child: RaisedButton(
                  child: Text(
                    "Aceitar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Colors.green,
                  onPressed: () async {
                    //Navigator.pop(widget.context);
                    Firestore db = Firestore.instance;

                    var docs = await this.aceitarEntrega();
                    docs["email_do_solicitante"] = widget.emailDoSolicitante;

                    db.collection("Entregas_pendentes").add(docs);
                    db
                        .collection("Entregas_disponiveis")
                        .document(widget.idDocumento)
                        .delete();
                    //print("dados moto: " + widget.documents.data["Nome cliente"]);
                    Navigator.pop(context);
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TelaEntregasPendentes()));*/
                    //print("dados moto: ");
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 70,
              child: ButtonTheme(
                height: 40,
                minWidth: 120,
                child: RaisedButton(
                  color: Colors.red,
                  onPressed: () {},
                  child: Text(
                    "Recusar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
