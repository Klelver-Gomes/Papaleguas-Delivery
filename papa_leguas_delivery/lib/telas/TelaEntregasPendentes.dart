import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:papa_leguas_delivery/model/Entregas.dart';
import 'package:papa_leguas_delivery/model/Util.dart';
import 'package:papa_leguas_delivery/telas/TelaConcluirEntrega.dart';
import 'package:papa_leguas_delivery/telas/TelaEntregasCanceladas.dart';

class TelaEntregasPendentes extends StatefulWidget {
  TelaEntregasPendentes({Key key}) : super(key: key);

  @override
  _TelaEntregasPendentesState createState() => _TelaEntregasPendentesState();
}

class _TelaEntregasPendentesState extends State<TelaEntregasPendentes> {
  TextEditingController _controllerMotivo = TextEditingController();
  String emailSolicitante = "";

  getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      this.userEmail = user.email;
    });
  }

  encerrarEntrega(DocumentSnapshot documents) async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    //print("documentos: " + documents.data["nome_cliente"]);
    Map<String, dynamic> _docs = {
      "nome_cliente": documents.data["nome_cliente"],
      "rua": documents.data["rua"],
      "bairro": documents.data["bairro"],
      "numero": documents.data["numero"],
      "telefone": documents.data["telefone"],
      "descricao": documents.data["descricao"],
      "status_entrega": "Concluída",
      "email_motoboy": _user.email
    };
    return _docs;
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  String userEmail;
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  DocumentSnapshot documentSnapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      /*appBar:  AppBar(
        title: Text(
          "Entregas pendentes",
          style: TextStyle(color: Util.COR_DO_TEXTO),
        ),
        backgroundColor: Util.COR_DO_BOTAO,
        iconTheme: IconThemeData(color: Util.COR_DO_TEXTO),
      ),*/
      body: Form(
        key: _formKey,
        child: Container(
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("Entregas_pendentes")
                    .where("email_motoboy", isEqualTo: this.userEmail)
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Center(
                          child: Text(
                        "Nenhuma entrega pendente",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ));
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Util.COR_DO_TEXTFIELD)),
                      );
                    default:
                      List<DocumentSnapshot> documents =
                          snapshot.data.documents;
                      /*if (widget.modoApp == "Solicitante") {
                                        documents = this.docs;
                                        print("solicitante");
                                      } else {
                                        documents = snapshot.data.documents;
                                        print("motoboy");
                                      }*/
                      //List<DocumentSnapshot> documents = snapshot.data.documents;
                      //print("dadosx");
                      if (documents.isEmpty) {
                        return Center(
                            child: Text(
                          "Nenhuma entrega pendente!",
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
                                                            .data[
                                                                "nome_cliente"]
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
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
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("O que deseja fazer?"),
                                          actions: [
                                            FlatButton(
                                              child: Text(
                                                "Encerrar entrega",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              onPressed: () async {
                                                //Firestore db = Firestore.instance;

                                                /*var docs = await encerrarEntrega(
                                                    documents[index]);
                                                db
                                                    .collection(
                                                        "Entregas_concluidas")
                                                    .add(docs);*/

                                                Entregas entregas = Entregas();
                                                FirebaseUser _user =
                                                    await FirebaseAuth.instance
                                                        .currentUser();
                                                Map<String, dynamic> ent =
                                                    entregas.toMap(
                                                        documents[index]);

                                                ent["status_entrega"] =
                                                    "Concluída";
                                                ent["email_motoboy"] =
                                                    _user.email;

                                                /*db
                                                    .collection(
                                                        "Entregas_pendentes")
                                                    .document(documents[index]
                                                        .documentID)
                                                    .delete();*/

                                                //print("documentos: " +
                                                //documents[index].documentID);
                                                Navigator.pop(context);

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            TelaConcluirEntrega(
                                                              dadosEntrega: ent,
                                                              documentId:
                                                                  documents[
                                                                          index]
                                                                      .documentID,
                                                            )));
                                                //Navigator.pop(context);
                                              },
                                            ),
                                            FlatButton(
                                                child: Text("Cancelar entrega",
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              "Descreva o motivo:"),
                                                          content:
                                                              TextFormField(
                                                            textCapitalization:
                                                                TextCapitalization
                                                                    .sentences,
                                                            controller:
                                                                _controllerMotivo,
                                                            maxLines: null,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .newline,
                                                            decoration:
                                                                InputDecoration(
                                                                    hintText:
                                                                        "Motivo"),
                                                            keyboardType:
                                                                TextInputType
                                                                    .multiline,
                                                            validator: (value) {
                                                              if (value
                                                                  .isEmpty) {
                                                                return "Campo obrigatório*";
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                          ),
                                                          actions: [
                                                            FlatButton(
                                                              child: Text(
                                                                  "Enviar"),
                                                              onPressed:
                                                                  () async {
                                                                Entregas
                                                                    entregas =
                                                                    Entregas();
                                                                FirebaseUser
                                                                    _user =
                                                                    await FirebaseAuth
                                                                        .instance
                                                                        .currentUser();
                                                                Map<String,
                                                                        dynamic>
                                                                    ent =
                                                                    entregas.toMap(
                                                                        documents[
                                                                            index]);

                                                                ent["status_entrega"] =
                                                                    "Cancelada";
                                                                ent["email_motoboy"] =
                                                                    _user.email;
                                                                ent["motivo_cancelamento"] =
                                                                    _controllerMotivo
                                                                        .text;
                                                                ent["email_solicitante"] =
                                                                    documents[index]
                                                                            .data[
                                                                        "email_do_solicitante"];

                                                                Firestore db =
                                                                    Firestore
                                                                        .instance;
                                                                db
                                                                    .collection(
                                                                        "Entregas_canceladas")
                                                                    .add(ent);

                                                                db
                                                                    .collection(
                                                                        "Entregas_pendentes")
                                                                    .document(documents[
                                                                            index]
                                                                        .documentID)
                                                                    .delete();

                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            TelaEntregasCanceladas(
                                                                              modoApp: "Motoboy",
                                                                              emailSolicitante: documents[index].data["email_do_solicitante"],
                                                                            )));
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                            FlatButton(
                                                              child: Text(
                                                                  "Cancelar"),
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                            )
                                                          ],
                                                        );
                                                      });
                                                  //Navigator.pop(context);
                                                })
                                          ],
                                        );
                                      });
                                },
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
      ),
    );
  }
}
