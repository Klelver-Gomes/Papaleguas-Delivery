import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:papa_leguas_delivery/model/Util.dart';

class TelaCadastroEntrega extends StatefulWidget {
  //TelaCadastroEntrega({Key key}) : super(key: key);

  var firebaseUser;

  TelaCadastroEntrega();

  @override
  _TelaCadastroEntregaState createState() => _TelaCadastroEntregaState();
}

class _TelaCadastroEntregaState extends State<TelaCadastroEntrega> {
  FocusNode _focusNomeCliente = FocusNode();
  FocusNode _focusEndereco = FocusNode();
  FocusNode _focusNumero = FocusNode();
  FocusNode _focusBairro = FocusNode();
  FocusNode _focusTelefone = FocusNode();
  FocusNode _focusDescricao = FocusNode();

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerNumero = TextEditingController();
  TextEditingController _controllerBairro = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerDescricao = TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  MaskTextInputFormatter _maskTelefone =
      MaskTextInputFormatter(mask: "(##)#####-####");

  void _cadastrarEntrega() async {
    Firestore db = Firestore.instance;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    Map<String, dynamic> dados = Map();

    dados = {
      "nome_cliente": _controllerNome.text,
      "rua": _controllerEndereco.text,
      "numero": _controllerNumero.text,
      "bairro": _controllerBairro.text,
      "telefone": _controllerTelefone.text,
      "descricao": _controllerDescricao.text,
      "status_entrega": "Em andamento",
      "email_do_solicitante": user.email
    };

    db.collection("Entregas_disponiveis").add(dados);

    _controllerNome.text = "";
    _controllerEndereco.text = "";
    _controllerNumero.text = "";
    _controllerBairro.text = "";
    _controllerTelefone.text = "";
    _controllerDescricao.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      /*appBar: AppBar(
        title: Text(
          "Cadastro de entrega",
          style: TextStyle(color: Util.COR_DO_TEXTO, fontSize: 20),
        ),
        backgroundColor: Util.COR_DO_BOTAO,
        iconTheme: IconThemeData(color: Util.COR_DO_TEXTO),
      ),*/
      body: Form(
        key: _formKey,
        child: GestureDetector(
            child: Container(
              //color: Colors.green,
              height: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        "imagens/CadastroEntrega.png",
                        width: 220,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40, bottom: 10),
                        child: TextFormField(
                          focusNode: _focusNomeCliente,
                          controller: _controllerNome,
                          textInputAction: TextInputAction.go,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: "Nome do cliente",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.yellow))),
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            if (value.isEmpty) {
                              //print("valorrr: " + value);
                              return "Campo obrigatório*";
                            } else {
                              //print("valorrree: " + value);
                              return null;
                            }
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(_focusEndereco);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          focusNode: _focusEndereco,
                          controller: _controllerEndereco,
                          textInputAction: TextInputAction.go,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: "Rua",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.yellow))),
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            if (value.isEmpty) {
                              //print("valorrr: " + value);
                              return "Campo obrigatório*";
                            } else {
                              //print("valorrree: " + value);
                              return null;
                            }
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(_focusNumero);
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                focusNode: _focusNumero,
                                controller: _controllerNumero,
                                textInputAction: TextInputAction.go,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: "Número",
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.yellow))),
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    //print("valorrr: " + value);
                                    return "Campo obrigatório*";
                                  } else {
                                    //print("valorrree: " + value);
                                    return null;
                                  }
                                },
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(_focusBairro);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10, left: 10),
                              child: TextFormField(
                                focusNode: _focusBairro,
                                controller: _controllerBairro,
                                textInputAction: TextInputAction.go,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: "Bairro",
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.yellow))),
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    //print("valorrr: " + value);
                                    return "Campo obrigatório*";
                                  } else {
                                    //print("valorrree: " + value);
                                    return null;
                                  }
                                },
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(_focusTelefone);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          focusNode: _focusTelefone,
                          controller: _controllerTelefone,
                          inputFormatters: [_maskTelefone],
                          textInputAction: TextInputAction.go,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              labelText: "Telefone",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.yellow))),
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            if (value.isEmpty) {
                              //print("valorrr: " + value);
                              return "Campo obrigatório*";
                            } else if (value.length < 14) {
                              return "Número inválido!";
                            } else {
                              //print("valorrree: " + value);
                              return null;
                            }
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_focusDescricao);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          focusNode: _focusDescricao,
                          controller: _controllerDescricao,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              labelText: "Descrição do produto",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.yellow))),
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: null,
                          validator: (value) {
                            if (value.isEmpty) {
                              //print("valorrr: " + value);
                              return "Campo obrigatório*";
                            } else {
                              //print("valorrree: " + value);
                              return null;
                            }
                          },
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 150,
                        height: 50,
                        child: RaisedButton(
                          child: Text(
                            "Cadastrar entrega",
                            style: TextStyle(
                                color: Util.COR_DO_TEXTO, fontSize: 20),
                          ),
                          color: Util.COR_DO_BOTAO,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _cadastrarEntrega();
                              _scaffoldKey.currentState.removeCurrentSnackBar();
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                  "Entrega cadastrada com sucesso!",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                                backgroundColor: Util.COR_DO_TEXTFIELD,
                              ));
                              FocusScope.of(context).requestFocus(FocusNode());
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () => FocusScope.of(context).requestFocus(FocusNode())),
      ),
    );
  }
}
