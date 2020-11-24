import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:papa_leguas_delivery/model/Util.dart';

class TelaConcluirEntrega extends StatefulWidget {
  @override
  _TelaConcluirEntregaState createState() => _TelaConcluirEntregaState();

  Map<String, dynamic> dadosEntrega;
  String documentId;

  TelaConcluirEntrega({this.dadosEntrega, this.documentId});
}

class _TelaConcluirEntregaState extends State<TelaConcluirEntrega> {
  String _radioProblemasComEntrega;
  String _descricaoProblema;
  TextEditingController _controller = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(
          "Concluir entrega",
          style: TextStyle(color: Util.COR_DO_TEXTO),
        ),
        backgroundColor: Util.COR_DO_BOTAO,
        iconTheme: IconThemeData(color: Util.COR_DO_TEXTO),
      ),
      body: Form(
        key: _formKey,
        child: GestureDetector(
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Text(
                      "Houve problemas com a entrega?",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text("Sim"),
                          leading: Radio(
                              activeColor: Util.COR_DO_BOTAO,
                              value: "Sim",
                              groupValue: this._radioProblemasComEntrega,
                              onChanged: (value) {
                                setState(() {
                                  this._radioProblemasComEntrega = value;
                                });
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              }),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text("Não"),
                          leading: Radio(
                              activeColor: Util.COR_DO_BOTAO,
                              value: "Não",
                              groupValue: this._radioProblemasComEntrega,
                              onChanged: (value) {
                                setState(() {
                                  this._radioProblemasComEntrega = value;
                                });
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              }),
                        ),
                      ),
                    ],
                  ),
                  this._radioProblemasComEntrega == "Sim"
                      ? TextFormField(
                          controller: _controller,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: null,
                          decoration: InputDecoration(
                              labelText: "Descreva o problema:",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.yellow))),
                          validator: (value) {
                            if (value.isEmpty) {
                              //print("valorrr: " + value);
                              return "Campo obrigatório*";
                            } else {
                              return null;
                            }
                          },
                          onEditingComplete: () {
                            setState(() {
                              this._descricaoProblema = this._controller.text;
                            });
                          },
                        )
                      : Row(),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: ButtonTheme(
                      height: 50,
                      child: RaisedButton(
                        child: Text(
                          "Concluir",
                          style:
                              TextStyle(color: Util.COR_DO_TEXTO, fontSize: 20),
                        ),
                        color: Util.COR_DO_BOTAO,
                        onPressed: () {
                          Firestore db = Firestore.instance;
                          if (this._formKey.currentState.validate()) {
                            //print("Sim");
                            if (_radioProblemasComEntrega == "Sim") {
                              if (_controller.text != "") {
                                widget.dadosEntrega["descricao_problema"] =
                                    _controller.text;
                              }
                              widget.dadosEntrega["data_entrega"] =
                                  DateTime.now().toString();

                              db
                                  .collection("Entregas_pendentes")
                                  .document(widget.documentId)
                                  .delete();

                              db
                                  .collection("Entregas_concluidas")
                                  .add(widget.dadosEntrega);
                              Navigator.pop(context);
                            } else if (_radioProblemasComEntrega == "Não") {
                              //print("Não");
                              widget.dadosEntrega["data_entrega"] =
                                  DateTime.now().toString();
                              db
                                  .collection("Entregas_pendentes")
                                  .document(widget.documentId)
                                  .delete();

                              db
                                  .collection("Entregas_concluidas")
                                  .add(widget.dadosEntrega);
                              Navigator.pop(context);
                            } else {
                              _scaffoldkey.currentState.removeCurrentSnackBar();
                              _scaffoldkey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                  "Selecione Sim ou Não!",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ));
                            }
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        ),
      ),
    );
  }
}
