import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:papa_leguas_delivery/model/Util.dart';
import 'package:papa_leguas_delivery/telas/TelaMapMotoboy.dart';

class TelaConsultarEntregas extends StatefulWidget {
  String emailSolicitante;
  String modoApp;

  TelaConsultarEntregas(this.emailSolicitante, this.modoApp);

  @override
  _TelaConsultarEntregasState createState() => _TelaConsultarEntregasState();
}

class _TelaConsultarEntregasState extends State<TelaConsultarEntregas> {
  bool _isLoading = false;
  List<DocumentSnapshot> docs = List();
  List<DocumentSnapshot> docsMotoboy = List();

  void _consultarEntregas() async {
    setState(() {
      this._isLoading = true;
    });
    var db = Firestore.instance;

    QuerySnapshot snapshot =
        await db.collection("Entregas_disponiveis").getDocuments();

    snapshot.documents.forEach((element) {
      if (element.data["email_do_solicitante"] == widget.emailSolicitante) {
        this.docs.add(element);
      }
      //print("elemento: " + element.data.toString());
      docsMotoboy.add(element);
    });

    setState(() {
      this._isLoading = false;
    });
    //print("finalizou");
    //return docs;
  }

  @override
  void dispose() {
    //print("dispose tela");
    super.dispose();
  }

  @override
  void initState() {
    //_consultarEntregas();
    //print("solicitante: " + widget.emailSolicitante);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("qual email: " + widget.emailSolicitante);
    return Scaffold(
      /*appBar: widget.modoApp == "Solicitante"
          ? AppBar(
              title: Text(
                "Consultar entregas",
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
              stream: widget.modoApp == "Solicitante"
                  ? Firestore.instance
                      .collection("Entregas_disponiveis")
                      .where("email_do_solicitante",
                          isEqualTo: widget.emailSolicitante)
                      .snapshots()
                  : Firestore.instance
                      .collection("Entregas_disponiveis")
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
                      String _solicitante = "Nenhuma entrega cadastrada!";
                      String _motoboy = "Nenhuma entrega disponível!";
                      return Center(
                          child: Text(
                        widget.modoApp == "Solicitante"
                            ? _solicitante
                            : _motoboy,
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
                                color: Util.COR_DE_FUNDO,
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
                                                  ),
                                                ],
                                              ),
                                              widget.modoApp == "Solicitante"
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 20),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Status da entrega: ",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              documents[index]
                                                                  .data[
                                                                      "status_entrega"]
                                                                  .toString(),
                                                              //textAlign: TextAlign.start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Row(),
                                            ]),
                                      ),
                                    ),
                                    Image.asset(
                                      "imagens/papa_leguas.png",
                                      height: 50,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                if (widget.modoApp == "Motoboy") {
                                  //print("num documento: " +
                                  //documents[index].documentID);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TelaMapMotoboy(
                                              documents[index],
                                              documents[index]
                                                  .documentID
                                                  .toString(),
                                              context,
                                              documents[index].data[
                                                  "email_do_solicitante"])));
                                }
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
    );
  }
}
