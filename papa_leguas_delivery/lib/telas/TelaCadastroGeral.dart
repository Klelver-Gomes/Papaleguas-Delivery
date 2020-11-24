import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:papa_leguas_delivery/model/Util.dart';
import 'package:papa_leguas_delivery/telas/TelaCadastroMotoboy.dart';
import 'package:papa_leguas_delivery/telas/TelaSolicitante.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TelaCadastroGeral extends StatefulWidget {
  TelaCadastroGeral({Key key, @required this.email, @required this.senha})
      : super(key: key);

  String email;
  String senha;

  @override
  _TelaCadastroGeralState createState() => _TelaCadastroGeralState();
}

class _TelaCadastroGeralState extends State<TelaCadastroGeral> {
  double _paddingCamposLeft = 0;
  double _paddingCamposRigth = 0;
  String _radioMotoboyOuSolicitante;
  bool _checkBoxTermos = false;
  bool _cadastroConcluido;
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _dados = {};

  FocusNode _focusNome = FocusNode();
  FocusNode _focusEndereco = FocusNode();
  FocusNode _focusBairro = FocusNode();
  FocusNode _focusNumero = FocusNode();
  FocusNode _focusTelefone = FocusNode();
  FocusNode _focusCpf = FocusNode();
  FocusNode _focusData = FocusNode();

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerRua = TextEditingController();
  TextEditingController _controllerBairro = TextEditingController();
  TextEditingController _controllerNumero = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerCPF = TextEditingController();
  TextEditingController _controllerData = TextEditingController();

  List<MaskTextInputFormatter> formatters = [
    MaskTextInputFormatter(mask: "(##)#####-####"),
    MaskTextInputFormatter(mask: "###.###.###-##"),
    MaskTextInputFormatter(mask: "##/##/####")
  ];

  @override
  void initState() {
    setState(() {
      _cadastroConcluido = false;
    });
    super.initState();
  }

  @override
  void dispose() async {
    //print("encerrou");
    if (_cadastroConcluido == false) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      user.delete();
    }
    super.dispose();
  }

  void _cadastrarSolicitante() async {
    Firestore db = Firestore.instance;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    db
        .collection("Solicitantes")
        .document(user.email)
        .setData(_dados)
        .then((value) {
      setState(() {
        _cadastroConcluido = true;
      });
    });
  }

  void _inserirDados() {
    _dados = {
      "email": widget.email,
      "senha": widget.senha,
      "nome": _controllerNome.text,
      "rua": _controllerRua.text,
      "bairro": _controllerBairro.text,
      "numero": _controllerNumero.text,
      "telefone": _controllerTelefone.text,
      "cpf": _controllerCPF.text,
      "data_nascimento": _controllerData.text,
      "termos_e_condicoes_lidos": true
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: GestureDetector(
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Image.asset(
                    "imagens/cadastro.png",
                    width: 250,
                    height: 250,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: _paddingCamposLeft, right: _paddingCamposRigth),
                    child: TextFormField(
                      controller: _controllerNome,
                      focusNode: _focusNome,
                      textInputAction: TextInputAction.go,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Nome completo",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.yellow))),
                      //* Começa com primeira letra maiúscula
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
                    padding: EdgeInsets.only(
                        left: _paddingCamposLeft,
                        right: _paddingCamposRigth,
                        top: 10),
                    child: TextFormField(
                      focusNode: _focusEndereco,
                      controller: _controllerRua,
                      textInputAction: TextInputAction.go,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Rua",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.yellow))),
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
                        FocusScope.of(context).requestFocus(_focusBairro);
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: _paddingCamposLeft, right: 5, top: 10),
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
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: _paddingCamposLeft,
                              right: _paddingCamposRigth,
                              top: 10),
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
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: _paddingCamposLeft,
                        right: _paddingCamposRigth,
                        top: 10),
                    child: TextFormField(
                      focusNode: _focusTelefone,
                      controller: _controllerTelefone,
                      textInputAction: TextInputAction.go,
                      inputFormatters: [formatters[0]],
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Telefone",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.yellow)),
                      ),
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
                        FocusScope.of(context).requestFocus(_focusCpf);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: _paddingCamposLeft,
                        right: _paddingCamposRigth,
                        top: 10),
                    child: TextFormField(
                      focusNode: _focusCpf,
                      controller: _controllerCPF,
                      textInputAction: TextInputAction.go,
                      inputFormatters: [formatters[1]],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "CPF",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.yellow))),
                      validator: (value) {
                        if (value.isEmpty) {
                          //print("valorrr: " + value);
                          return "Campo obrigatório*";
                        } else if (value.length < 14) {
                          return "CPF inválido!";
                        } else {
                          //print("valorrree: " + value);
                          return null;
                        }
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_focusData);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: _paddingCamposLeft,
                        right: _paddingCamposRigth,
                        top: 10),
                    child: TextFormField(
                      focusNode: _focusData,
                      controller: _controllerData,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [formatters[2]],
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                          labelText: "Data de nascimento",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.yellow)),
                          hintText: "dd/mm/aaaa"),
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

                          int idade = anoAtual - ano;

                          if (dia < 0 ||
                              dia > 31 ||
                              mes < 0 ||
                              mes > 12 ||
                              ano < 1750 ||
                              ano > DateTime.now().year) {
                            return "Data inválida!";
                          } else {
                            if (mesAtual < mes) {
                              idade--;
                            } else {
                              if (diaAtual < dia) {
                                idade--;
                              }
                            }
                            if (idade < 18) {
                              //print("minhaIdade: " + idade.toString());
                              return "Menor de 18 anos não pode realizar cadastro no app!";
                            }
                          }
                        }
                      },
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text("Solicitante"),
                          leading: Radio(
                            activeColor: Util.COR_DO_BOTAO,
                            value: "Solicitante",
                            groupValue: _radioMotoboyOuSolicitante,
                            onChanged: (String escolha) {
                              setState(() {
                                _radioMotoboyOuSolicitante = escolha;
                              });
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text("Motoboy"),
                          leading: Radio(
                            activeColor: Util.COR_DO_BOTAO,
                            value: "Motoboy",
                            groupValue: _radioMotoboyOuSolicitante,
                            onChanged: (String escolha) {
                              setState(() {
                                _radioMotoboyOuSolicitante = escolha;
                              });
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: CheckboxListTile(
                      checkColor: Colors.white,
                      activeColor: Util.COR_DO_BOTAO,
                      value: _checkBoxTermos,
                      onChanged: (bool value) {
                        setState(() {
                          _checkBoxTermos = value;
                        });
                        print("termos: " + _checkBoxTermos.toString());
                      },
                      title: Text("Aceito os termos e condições"),
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 150,
                    height: 50,
                    child: RaisedButton(
                      color: Util.COR_DO_BOTAO,
                      child: Text(
                        "Enviar",
                        style:
                            TextStyle(fontSize: 20, color: Util.COR_DO_TEXTO),
                      ),
                      onPressed: () {
                        _inserirDados();
                        if (_formKey.currentState.validate()) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (_radioMotoboyOuSolicitante == "Motoboy") {
                            _dados["motoboy"] = true;
                            //print("motoboy");
                            if (_checkBoxTermos == true) {
                              //dados['modo'] = 'motoboy';
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TelaCadastroMotoboy(_dados)));
                            } else {
                              _scaffoldkey.currentState.removeCurrentSnackBar();
                              _scaffoldkey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                  "É necessário aceitar os termos e condições!",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ));
                            }
                          } else if (_radioMotoboyOuSolicitante ==
                              "Solicitante") {
                            _dados["solicitante"] = true;
                            //print("Solicitante");
                            if (_checkBoxTermos == true) {
                              this._cadastrarSolicitante();
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TelaSolicitante()));
                            } else {
                              _scaffoldkey.currentState.removeCurrentSnackBar();
                              _scaffoldkey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                  "É necessário aceitar os termos e condições!",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ));
                            }
                          } else {
                            _scaffoldkey.currentState.removeCurrentSnackBar();
                            _scaffoldkey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                "Selecione Motoboy ou Solicitante!",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ));
                          }
                        }
                      },
                    ),
                  )
                ]),
                //mainAxisAlignment: MainAxisAlignment.center,
              ),
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            ),
          )),
    );
  }
}
