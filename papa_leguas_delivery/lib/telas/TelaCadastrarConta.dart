import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:papa_leguas_delivery/model/Util.dart';
import 'package:papa_leguas_delivery/telas/TelaCadastroGeral.dart';

class TelaCadastrarConta extends StatefulWidget {
  TelaCadastrarConta({Key key}) : super(key: key);

  @override
  _TelaCadastrarContaState createState() => _TelaCadastrarContaState();
}

class _TelaCadastrarContaState extends State<TelaCadastrarConta> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerConfirmacaoSenha = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  FocusNode _focusEmail = FocusNode();
  FocusNode _focusSenha = FocusNode();
  FocusNode _focusConfirmaSenha = FocusNode();

  bool _isCarregando = false;
  bool _showPassword = false;
  bool _showPasswordConfirm = false;

  void cadastrarUsuario() async {
    setState(() {
      _isCarregando = true;
    });
    FirebaseUser user;

    String _email = _controllerEmail.text;
    String _senha = _controllerSenha.text;
    String _confirmacaoSenha = _controllerConfirmacaoSenha.text;

    if (_email != "" &&
        _senha != "" &&
        _confirmacaoSenha != "" &&
        _senha == _confirmacaoSenha) {
      user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _senha)
          .then((firebaseUser) {
        print("Cadastrado com sucesso!" + firebaseUser.user.email);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TelaCadastroGeral(email: _email, senha: _senha)));
        setState(() {
          _isCarregando = false;
        });
        //Navigator.pop(context);
      }).catchError((erro) {
        setState(() {
          _isCarregando = false;
        });
        String e = erro.toString();
        if (e.contains("ERROR_NETWORK_REQUEST_FAILED")) {
          //print("erro: entrou");
          _scaffoldKey.currentState.removeCurrentSnackBar();
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Verifique sua conexão com a internet!"),
            backgroundColor: Colors.red,
          ));
        } else if (e.contains("ERROR_EMAIL_ALREADY_IN_USE")) {
          _scaffoldKey.currentState.removeCurrentSnackBar();
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("E-mail já existe!"),
            backgroundColor: Colors.red,
          ));
        }
        //print("erro: " + erro.toString());
      });
    } else {
      setState(() {
        _isCarregando = false;
      });
      if (_senha != _confirmacaoSenha) {
        _scaffoldKey.currentState.removeCurrentSnackBar();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Senhas não coincidem!"),
          backgroundColor: Colors.red,
        ));
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        //margin: EdgeInsets.all(10),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Center(
            child: GestureDetector(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "imagens/cadastro.png",
                      width: 250,
                      height: 250,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 10),
                      child: TextFormField(
                        focusNode: _focusEmail,
                        textInputAction: TextInputAction.go,
                        controller: _controllerEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "Email:",
                            icon: Icon(Icons.email),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.yellow))),
                        validator: (value) {
                          if (value.isEmpty) {
                            //print("valorrr: " + value);
                            return "Campo obrigatório*";
                          } else if (!value.contains("@") ||
                              !value.contains(".com")) {
                            return "E-mail inválido*";
                          } else {
                            //print("valor: " + value);
                            return null;
                          }
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_focusSenha);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        focusNode: _focusSenha,
                        textInputAction: TextInputAction.go,
                        controller: _controllerSenha,
                        keyboardType: TextInputType.text,
                        obscureText: _showPassword == false ? true : false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.yellow)),
                            labelText: "Senha:",
                            icon: Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                              child: Icon(_showPassword == false
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onTap: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            )),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Campo obrigatório*";
                          } else if (value.length < 8) {
                            return "Senha deve conter pelo menos 8 caracteres*";
                          } else if (value.contains(" ")) {
                            return "Senha não pode conter espaços*";
                          } else {
                            //print("valor: " + value);
                            return null;
                          }
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_focusConfirmaSenha);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        focusNode: _focusConfirmaSenha,
                        controller: _controllerConfirmacaoSenha,
                        keyboardType: TextInputType.text,
                        obscureText:
                            _showPasswordConfirm == false ? true : false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.yellow)),
                            icon: Icon(Icons.lock),
                            labelText: "Confirme a senha:",
                            suffixIcon: GestureDetector(
                              child: Icon(_showPasswordConfirm == false
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onTap: () {
                                setState(() {
                                  _showPasswordConfirm = !_showPasswordConfirm;
                                });
                              },
                            )),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Campo obrigatório*";
                          } else if (value.length < 8) {
                            return "Senha deve conter pelo menos 8 caracteres*";
                          } else if (value.contains(" ")) {
                            return "Senha não pode conter espaços*";
                          } else {
                            //print("valor: " + value);
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: ButtonTheme(
                        minWidth: 20,
                        height: 45,
                        child: RaisedButton(
                          child: Text(
                            "Continuar ->",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Util.COR_DO_TEXTO),
                          ),
                          color: Util.COR_DO_BOTAO,
                          textColor: Colors.white,
                          onPressed: () async {
                            if (!_formKey.currentState.validate()) {
                              /*_scaffoldKey.currentState.removeCurrentSnackBar();
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Processando..."),
                              ));*/
                              /*_scaffoldKey.currentState.showSnackBar(
                                  SnackBar(content: Text("Processando")));*/
                              //print("Campo(s) não preenchidos");
                            } else {
                              cadastrarUsuario();
                            }
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: _isCarregando
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Util.COR_DO_BOTAO))
                          : Container(),
                    )
                  ],
                ),
              ),
              onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            ),
          ),
        ),
      ),
    );
  }
}
