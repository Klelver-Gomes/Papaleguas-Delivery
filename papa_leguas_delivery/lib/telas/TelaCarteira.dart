import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:papa_leguas_delivery/model/Util.dart';
import 'package:papa_leguas_delivery/telas/TelaTransferencia.dart';

class TelaCarteira extends StatefulWidget {
  TelaCarteira({Key key}) : super(key: key);

  @override
  _TelaCarteiraState createState() => _TelaCarteiraState();
}

class _TelaCarteiraState extends State<TelaCarteira> {
  String _carteira = "";
  String _nome = "";
  String _veiculo = "";
  String _saldo = "";
  String _categoria = "";

  void _recuperarDados() async {
    Firestore db = Firestore.instance;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot query = await db
        .collection("Motoboys")
        .where("email", isEqualTo: user.email)
        .getDocuments();

    List<DocumentSnapshot> snapshot = query.documents;

    setState(() {
      this._carteira = snapshot[0]["carteira"];
      this._nome = snapshot[0]["nome"];
      this._veiculo = snapshot[0]["modelo_moto"];
      this._saldo = snapshot[0]["saldo"].toString();
      this._categoria = snapshot[0]["categoria"];
    });

    print("email do motoboy: " + snapshot[0]["carteira"]);
  }

  @override
  void initState() {
    _recuperarDados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carteira", style: TextStyle(color: Util.COR_DO_TEXTO)),
        backgroundColor: Util.COR_DO_BOTAO,
        iconTheme: IconThemeData(color: Util.COR_DO_TEXTO),
      ),
      body: Container(
        //margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Image.asset(
                "imagens/Papaleguas.png",
                height: 200,
              ),
            ),
            Container(
              width: double.infinity,
              color: Util.COR_DO_BOTAO,
              child: Column(
                children: [
                  Text(
                    "Carteira: $_carteira",
                    style: TextStyle(fontSize: 22, color: Util.COR_DO_TEXTO),
                  ),
                  Text("Nome: $_nome",
                      style: TextStyle(fontSize: 18, color: Util.COR_DO_TEXTO)),
                  Text("Veículo: $_veiculo",
                      style: TextStyle(fontSize: 18, color: Util.COR_DO_TEXTO)),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                    height: 60,
                    color: Util.COR_DO_BOTAO,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("  Saldo: $_saldo     ",
                            style: TextStyle(
                                fontSize: 20, color: Util.COR_DO_TEXTO))
                      ],
                    )),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    height: 60,
                    color: Color.fromRGBO(230, 137, 112, 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("  Categoria: $_categoria    ",
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                  ),
                )),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Container(
                width: double.infinity,
                color: Util.COR_DO_TEXTFIELD,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RatingBar(
                      unratedColor: Util.COR_DO_TEXTO,
                      glowColor: Util.COR_DO_ICONE,
                      itemSize: 40,
                      initialRating: 3.5,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true, //* permite selecionar meia estrela
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      ignoreGestures: true,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Util.COR_DO_ICONE,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    Text(
                      "Avaliação média",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        //color: Util.corDoTextField,
        child: GestureDetector(
          child: Container(
            color: Util.COR_DO_TEXTFIELD,
            width: double.infinity,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Transferência",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => TelaTransferencia())),
        ),
      ),
    );
  }
}
