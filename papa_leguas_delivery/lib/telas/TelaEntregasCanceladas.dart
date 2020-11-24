import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:papa_leguas_delivery/model/Entregas.dart';
import 'package:papa_leguas_delivery/model/Util.dart';

class TelaEntregasCanceladas extends StatefulWidget {
  String modoApp;
  String emailSolicitante;
  TelaEntregasCanceladas({this.modoApp, this.emailSolicitante});

  @override
  _TelaEntregasCanceladasState createState() => _TelaEntregasCanceladasState();
}

class _TelaEntregasCanceladasState extends State<TelaEntregasCanceladas> {
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
      /*appBar: widget.modoApp == "Solicitante"
          ? AppBar(
              title: Text(
                "Entregas canceladas",
                style: TextStyle(color: Util.COR_DO_TEXTO),
              ),
              backgroundColor: Util.COR_DO_BOTAO,
              iconTheme: IconThemeData(color: Util.COR_DO_TEXTO),
            )
          : null,*/
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: widget.modoApp == "Motoboy"
                  ? Firestore.instance
                      .collection("Entregas_canceladas")
                      .where("email_motoboy", isEqualTo: this.userEmail)
                      .snapshots()
                  : Firestore.instance
                      .collection("Entregas_canceladas")
                      .where("email_solicitante",
                          isEqualTo: widget.emailSolicitante)
                      .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(
                        child: Text(
                      "Nenhuma entrega cancelada",
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
                        "Nenhuma entrega cancelada!",
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
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15, right: 10),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Motivo do\ncancelamento: ",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        documents[index]
                                                            .data[
                                                                "motivo_cancelamento"]
                                                            .toString(),
                                                        //textAlign: TextAlign.start,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: widget.modoApp == "Solicitante"
                                  ? () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  "Enviar para as disponíveis?"),
                                              actions: [
                                                FlatButton(
                                                  child: Text("Sim",
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  onPressed: () async {
                                                    FirebaseUser user =
                                                        await FirebaseAuth
                                                            .instance
                                                            .currentUser();
                                                    Entregas entregas =
                                                        Entregas();
                                                    Map<String, dynamic> ent =
                                                        entregas.toMap(
                                                            documents[index]);

                                                    ent["email_do_solicitante"] =
                                                        user.email;
                                                    ent["status_entrega"] =
                                                        "Em andamento";

                                                    Firestore db =
                                                        Firestore.instance;
                                                    db
                                                        .collection(
                                                            "Entregas_disponiveis")
                                                        .add(ent);

                                                    db
                                                        .collection(
                                                            "Entregas_canceladas")
                                                        .document(
                                                            documents[index]
                                                                .documentID)
                                                        .delete();

                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                FlatButton(
                                                    child: Text(
                                                      "Não",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.pop(context))
                                              ],
                                            );
                                          });
                                    }
                                  : null,
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
