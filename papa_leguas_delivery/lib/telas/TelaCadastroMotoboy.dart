import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:papa_leguas_delivery/model/Util.dart';
import 'package:papa_leguas_delivery/telas/TelaMotoboy.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TelaCadastroMotoboy extends StatefulWidget {
  /*String email;
  String senha;
  String nomeCompleto;
  String endereco;
  String bairro;
  int numero;
  String telefone;
  String cpf;
  String dataNascimento;
  String _cnh;
  String _dataExpedicao;
  String _modeloMoto;
  String _placa;*/

  Map<String, dynamic> _dados = {};

  TelaCadastroMotoboy(this._dados);
  //TelaCadastroMotoboy({Key key}) : super(key: key);

  @override
  _TelaCadastroMotoboyState createState() => _TelaCadastroMotoboyState();
}

class _TelaCadastroMotoboyState extends State<TelaCadastroMotoboy> {
  bool _cadastroConcluido = false;
  bool _isLoading = false;
  bool _imagemCNHenviada = false;
  String _tituloImagem = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _controllerCNH = TextEditingController();
  TextEditingController _controllerDataExpedicao = TextEditingController();
  TextEditingController _controllerModeloMoto = TextEditingController();
  TextEditingController _controllerPlaca = TextEditingController();

  FocusNode _focusNome = FocusNode();
  FocusNode _focusDataExpedicao = FocusNode();
  FocusNode _focusModeloMoto = FocusNode();
  FocusNode _focusPlaca = FocusNode();

  final _formKey = GlobalKey<FormState>();

  List<MaskTextInputFormatter> _formatters = [
    MaskTextInputFormatter(mask: "AAA-####"),
    MaskTextInputFormatter(mask: "##/##/####")
  ];

  /*FirebaseUser _user;

  void recuperarUsuario() async {
    this._user = await FirebaseAuth.instance.currentUser();
  }*/

  Future<void> _cadastrarMotoboy() async {
    Firestore db = Firestore.instance;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    widget._dados["cnh"] = _controllerCNH.text;
    widget._dados["data_expedicao"] = _controllerDataExpedicao.text;
    widget._dados["modelo_moto"] = _controllerModeloMoto.text;
    widget._dados["placa"] = _controllerPlaca.text;
    widget._dados["carteira"] = "PPLDMAH20";
    widget._dados["categoria"] = "Bronze";
    widget._dados["saldo"] = 0.00;

    db
        .collection("Motoboys")
        .document(user.email)
        .setData(widget._dados)
        .then((value) {
      //print("concluido?");
      setState(() {
        _cadastroConcluido = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    if (_cadastroConcluido == false) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      user.delete();
      FirebaseStorage.instance.ref().child(this._tituloImagem).delete();
    }
    super.dispose();
  }

  void _escolherImagem() async {
    // ignore: deprecated_member_use
    setState(() {
      this._imagemCNHenviada = true;
    });
    final File img = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _isLoading = true;
    });
    //Map<String, dynamic> dados = {};
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      this._tituloImagem = user.email.toString();
    });

    if (img != null) {
      StorageUploadTask task =
          FirebaseStorage.instance.ref().child(this._tituloImagem).putFile(img);

      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String urlImagem = await taskSnapshot.ref.getDownloadURL();
      widget._dados["url_Imagem"] = urlImagem;
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Foto salva com sucesso!",
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ));
    }
    //Firestore.instance.collection("linkImagens").add(dados);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Motoboy",
          style: TextStyle(color: Util.COR_DO_TEXTO),
        ),
        iconTheme: IconThemeData(color: Util.COR_DO_TEXTO),
        backgroundColor: Util.COR_DO_BOTAO,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          //height: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: GestureDetector(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  //LinearProgressIndicator(),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      "imagens/CadastroMotoboy.png",
                      width: 220,
                      height: 180,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      controller: _controllerCNH,
                      keyboardType: TextInputType.number,
                      focusNode: _focusNome,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                          labelText: "CNH:",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.yellow))),
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_focusDataExpedicao);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          //print("valorrr: " + value);
                          return "Campo obrigatório*";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      controller: _controllerDataExpedicao,
                      keyboardType: TextInputType.datetime,
                      focusNode: _focusDataExpedicao,
                      textInputAction: TextInputAction.go,
                      inputFormatters: [_formatters[1]],
                      decoration: InputDecoration(
                          labelText: "Data expedição:",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.yellow))),
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_focusModeloMoto);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          //print("valorrr: " + value);
                          return "Campo obrigatório*";
                        } else if (value.length < 10) {
                          //print("diaaa " + DateTime.now().year.toString());
                          return "Data inválida!";
                        } else {
                          List<String> data;
                          data = value.split('/');
                          int dia = int.parse(data[0]);
                          int mes = int.parse(data[1]);
                          int ano = int.parse(data[2]);

                          int diaAtual = DateTime.now().day;
                          int mesAtual = DateTime.now().month;
                          int anoAtual = DateTime.now().year;

                          int tempoDataExpedicao = anoAtual - ano;

                          if (dia < 0 ||
                              dia > 31 ||
                              mes < 0 ||
                              mes > 12 ||
                              ano < 1750 ||
                              ano > DateTime.now().year) {
                            return "Data inválida!";
                          } else {
                            if (mesAtual < mes) {
                              tempoDataExpedicao--;
                            } else {
                              if (diaAtual < dia) {
                                tempoDataExpedicao--;
                              }
                            }
                          }
                          if (tempoDataExpedicao < 0) {
                            return "Data inválida!";
                          }
                          //print("idade: " + idade.toString());
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      controller: _controllerModeloMoto,
                      keyboardType: TextInputType.text,
                      focusNode: _focusModeloMoto,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                          labelText: "Modelo da moto:",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.yellow))),
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_focusPlaca);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          //print("valorrr: " + value);
                          return "Campo obrigatório*";
                        }
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _controllerPlaca,
                    keyboardType: TextInputType.text,
                    focusNode: _focusPlaca,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [_formatters[0]],
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                        labelText: "Placa:",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.yellow))),
                    validator: (value) {
                      if (value.isEmpty) {
                        //print("valorrr: " + value);
                        return "Campo obrigatório*";
                      } else if (value.length < 8) {
                        return "Placa inválida!";
                      } else {
                        //print("valorrree: " + value);
                        return null;
                      }
                    },
                    onTap: () {
                      setState(() {
                        _controllerPlaca.text.toUpperCase();
                      });
                    },
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 20, top: 30),
                        child: Expanded(
                          child: Text(
                            "Foto CNH: ",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 20, top: 30),
                            child: ButtonTheme(
                              height: 50,
                              child: RaisedButton(
                                color: Color.fromRGBO(254, 186, 0, 1),
                                onPressed: this._imagemCNHenviada
                                    ? null
                                    : () {
                                        _escolherImagem();
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      },
                                child: Text(
                                  "Abrir câmera",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Util.COR_DO_BOTAO),
                                  )
                                : Center(),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              //mainAxisAlignment: MainAxisAlignment.center,
            ),
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          child: ButtonTheme(
            minWidth: deviceInfo.size.width,
            height: 50,
            child: RaisedButton(
              child: Text(
                "Enviar",
                style: TextStyle(fontSize: 22, color: Util.COR_DO_TEXTO),
              ),
              color: Util.COR_DO_BOTAO,
              textColor: Colors.black54,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  if (this._imagemCNHenviada == true) {
                    _cadastrarMotoboy();
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TelaMotoboy()));
                    FocusScope.of(context).requestFocus(FocusNode());
                  } else {
                    _scaffoldKey.currentState.removeCurrentSnackBar();
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                        "A foto da CNH deve ser enviada!",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      backgroundColor: Colors.red,
                    ));
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
