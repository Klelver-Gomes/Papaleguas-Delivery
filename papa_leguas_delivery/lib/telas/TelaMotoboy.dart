import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papa_leguas_delivery/model/Util.dart';
import 'package:papa_leguas_delivery/telas/TelaCarteira.dart';
import 'package:papa_leguas_delivery/telas/TelaConsultarEntregas.dart';
import 'package:papa_leguas_delivery/telas/TelaEntregasCanceladas.dart';
import 'package:papa_leguas_delivery/telas/TelaEntregasPendentes.dart';

import 'TelaConsultarEntregas.dart';
import 'TelaEntregasConcluidas.dart';

class TelaMotoboy extends StatefulWidget {
  TelaMotoboy({Key key}) : super(key: key);

  @override
  _TelaMotoboyState createState() => _TelaMotoboyState();
}

class _TelaMotoboyState extends State<TelaMotoboy> {
  String _nome = "";
  String _carteira = "";
  String _categoria = "";
  String _veiculo = "";
  String _placa = "";
  String urlImagem = "";
  String _email = "";
  bool isLoading = true;
  String usuarioLogado = "";
  int indiceAtual = 0;
  String tituloAppBar = "";
  double _tamanhoDosIcones = 25;

  @override
  void dispose() async {
    /*//! REMOVER APÓS CONCLUIR O RESTANTE.
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.delete();*/
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosMotoboy();
    getUser();
  }

  _recuperarDadosMotoboy() async {
    Firestore db = Firestore.instance;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    QuerySnapshot snapshot = await db.collection("Motoboys").getDocuments();

    for (DocumentSnapshot documentSnapshot in snapshot.documents) {
      if (user.email == documentSnapshot.data["email"]) {
        setState(() {
          this._nome = documentSnapshot.data["nome"];
          this._veiculo = documentSnapshot.data["modelo_moto"];
          this._placa = documentSnapshot.data["placa"];
          this._carteira = documentSnapshot.data["carteira"];
          this._categoria = documentSnapshot.data["categoria"];
          this.urlImagem = documentSnapshot.data["url_Imagem"];
          this._email = documentSnapshot.data["email"];
        });
        break;
      }
    }
  }

  void getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      usuarioLogado = user.email.toString();
    });
  }

  void irParaTelaCarteira() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TelaCarteira()));
  }

  void deslogarMotoboy() {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _telas = [
      TelaConsultarEntregas(usuarioLogado, "Motoboy"),
      TelaEntregasPendentes(),
      TelaEntregasCanceladas(
        modoApp: "Motoboy",
      ),
      TelaEntregasConcluidas()
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Motoboy",
          style: TextStyle(color: Util.COR_DO_TEXTO),
        ),
        backgroundColor: Util.COR_DO_BOTAO,
        iconTheme: IconThemeData(color: Util.COR_DO_TEXTO),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[Util.COR_DO_TEXTFIELD, Colors.blue])),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(this._nome,
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    Text(
                      this._carteira,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    Text(this._email,
                        style: TextStyle(fontSize: 15, color: Colors.white))
                  ],
                ),
              ),
            ),
            CustomListTile(Icons.person, "Perfil", irParaTelaCarteira),
            CustomListTile(Icons.exit_to_app, "Sair", deslogarMotoboy)
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: _telas[indiceAtual],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Util.COR_DE_FUNDO,
        type: BottomNavigationBarType.fixed,
        fixedColor: Util.COR_DO_BOTAO,
        iconSize: 20,
        currentIndex: indiceAtual,
        onTap: (int indice) {
          setState(() {
            indiceAtual = indice;
          });
        },
        items: [
          BottomNavigationBarItem(
              title: Text("Entregas\ndisponíveis", textAlign: TextAlign.center),
              icon: Icon(Icons.motorcycle, size: this._tamanhoDosIcones)),
          BottomNavigationBarItem(
              title: Text("Entregas\npendentes", textAlign: TextAlign.center),
              icon: Icon(Icons.notification_important,
                  size: this._tamanhoDosIcones)),
          BottomNavigationBarItem(
              title: Text("Entregas\ncanceladas", textAlign: TextAlign.center),
              icon: Icon(
                Icons.cancel,
                size: this._tamanhoDosIcones,
              )),
          BottomNavigationBarItem(
              title: Text("Entregas\nconcluídas", textAlign: TextAlign.center),
              icon: Icon(Icons.check_circle_outline,
                  size: this._tamanhoDosIcones))
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomListTile extends StatelessWidget {
  IconData _icone;
  String _texto;
  Function _onTap;

  CustomListTile(this._icone, this._texto, this._onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
        child: InkWell(
          splashColor: Util.COR_DO_BOTAO,
          onTap: this._onTap,
          child: Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      this._icone,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        this._texto,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_right,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
