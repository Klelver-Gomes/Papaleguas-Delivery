import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papa_leguas_delivery/model/Util.dart';
import 'package:papa_leguas_delivery/telas/TelaAvaliarMotoboy.dart';
import 'package:papa_leguas_delivery/telas/TelaCadastroEntrega.dart';
import 'package:papa_leguas_delivery/telas/TelaConsultarEntregas.dart';
import 'package:papa_leguas_delivery/telas/TelaEntregasCanceladas.dart';

import 'TelaConsultarEntregas.dart';

class TelaSolicitante extends StatefulWidget {
  TelaSolicitante({Key key}) : super(key: key);

  @override
  _TelaSolicitanteState createState() => _TelaSolicitanteState();
}

class _TelaSolicitanteState extends State<TelaSolicitante> {
  int indiceAtual = 0;
  String usuarioLogado = "";
  double _tamanhoDosIcones = 25;
  String _nome = "";
  String _email = "";

  @override
  void initState() {
    this.getUser();
    _recuperarDadosSolicitante();
    super.initState();
  }

  @override
  void dispose() async {
    //! REMOVER APÓS CONCLUIR O RESTANTE.
    /*FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.delete();*/
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    super.dispose();
  }

  Future<FirebaseUser> getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      this.usuarioLogado = user.email.toString();
    });
  }

  void _deslogarSolicitante() {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  _recuperarDadosSolicitante() async {
    Firestore db = Firestore.instance;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    QuerySnapshot snapshot = await db.collection("Solicitantes").getDocuments();

    for (DocumentSnapshot documentSnapshot in snapshot.documents) {
      if (user.email == documentSnapshot.data["email"]) {
        setState(() {
          this._nome = documentSnapshot.data["nome"];
          this._email = user.email;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _telas = [
      TelaCadastroEntrega(),
      TelaConsultarEntregas(usuarioLogado, "Solicitante"),
      TelaAvaliarMotoboy(),
      TelaEntregasCanceladas(modoApp: "Solicitante"),
      null // ERA A TELA SALDO - VERIFICAR DEPOIS
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Solicitante",
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
                    Text(
                      this._nome,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    Text(
                      this._email,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            CustomListTile(Icons.person, "Perfil", null),
            CustomListTile(Icons.exit_to_app, "Sair", _deslogarSolicitante),
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
              title: Text(
                "Cadastrar\nentrega",
                textAlign: TextAlign.center,
              ),
              icon: Icon(Icons.add_box, size: this._tamanhoDosIcones)),
          BottomNavigationBarItem(
              title: Text(
                "Consultar\nentregas",
                textAlign: TextAlign.center,
              ),
              icon: Icon(Icons.search, size: this._tamanhoDosIcones)),
          BottomNavigationBarItem(
              title: Text(
                "Avaliar\nmotoboy",
                textAlign: TextAlign.center,
              ),
              icon: Icon(Icons.star_half, size: this._tamanhoDosIcones)),
          BottomNavigationBarItem(
              title: Text(
                "Entregas\ncanceladas",
                textAlign: TextAlign.center,
              ),
              icon: Icon(Icons.cancel, size: this._tamanhoDosIcones))
        ],
      ),
    );
  }
}

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
