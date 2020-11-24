import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:papa_leguas_delivery/model/Util.dart';

class TelaEntregasConcluidas extends StatefulWidget {
  //TelaEntregasConcluidas({Key key}) : super(key: key);
  DocumentSnapshot documentSnapshot;
  TelaEntregasConcluidas({this.documentSnapshot});

  @override
  _TelaEntregasConcluidasState createState() => _TelaEntregasConcluidasState();
}

class _TelaEntregasConcluidasState extends State<TelaEntregasConcluidas> {
  getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      this.userEmail = user.email;
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  String userEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text("Entregas concluídas",
            style: TextStyle(color: Util.COR_DO_TEXTO)),
        backgroundColor: Util.COR_DO_BOTAO,
        iconTheme: IconThemeData(color: Util.COR_DO_TEXTO),
      ),*/
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("Entregas_concluidas")
                  .where("email_motoboy", isEqualTo: this.userEmail)
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(
                        child: Text(
                      "Nenhuma entrega disponível",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ));
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Util.COR_DO_TEXTFIELD)),
                    );
                  default:
                    List<DocumentSnapshot> documents = snapshot.data.documents;
                    if (documents.isEmpty) {
                      return Center(
                          child: Text(
                        "Nenhuma entrega concluída!",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ));
                    } else {
                      return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: GestureDetector(
                              child: Container(
                                width: double.infinity,
                                color: Color.fromRGBO(217, 217, 217, 1),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Nome do cliente: ",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      documents[index]
                                                          .data["nome_cliente"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      //textAlign: TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Rua: ",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      documents[index]
                                                          .data["rua"]
                                                          .toString(),
                                                      //textAlign: TextAlign.start,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Bairro: ",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      documents[index]
                                                          .data["bairro"]
                                                          .toString(),
                                                      //textAlign: TextAlign.start,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Número: ",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      documents[index]
                                                          .data["numero"]
                                                          .toString(),
                                                      //textAlign: TextAlign.start,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Telefone: ",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      documents[index]
                                                          .data["telefone"]
                                                          .toString(),
                                                      //textAlign: TextAlign.start,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Descrição: ",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      documents[index]
                                                          .data["descricao"]
                                                          .toString(),
                                                      //textAlign: TextAlign.start,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
