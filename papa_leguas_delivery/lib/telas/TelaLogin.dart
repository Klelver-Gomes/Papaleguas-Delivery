import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:papa_leguas_delivery/model/Util.dart';
import 'package:papa_leguas_delivery/telas/TelaCadastrarConta.dart';
import 'package:papa_leguas_delivery/telas/TelaMotoboy.dart';
import 'package:papa_leguas_delivery/telas/TelaSolicitante.dart';

class TelaLogin extends StatefulWidget {
  TelaLogin({Key key}) : super(key: key);

  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  bool _showPassword = false;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _modoApp = false;

  FocusNode _focusEmail = FocusNode();
  FocusNode _focusSenha = FocusNode();

  void signIn(String email, String senha) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    //FirebaseUser usuarioAtual = await auth.currentUser();
    auth.signOut();
    setState(() {
      _isLoading = true;
    });
    await auth
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((firebaseUser) async {
      Firestore db = Firestore.instance;

      QuerySnapshot querySnapshot =
          await db.collection("Solicitantes").getDocuments();

      for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
        var dados = documentSnapshot.data;
        //print("dados login: " + dados['email'].toString());
        if (dados['email'] == email) {
          setState(() {
            _isLoading = false;
          });
          setState(() {
            _modoApp = true;
          });
          break;
        }
      }
      //print("dados modo app: " + _modoApp.toString());
      if (_modoApp) {
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TelaSolicitante()));
      } else {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TelaMotoboy()));
      }
    }).catchError((erro) {
      setState(() {
        _isLoading = false;
      });
      //print("errou: " + erro.toString());
      String e = erro.toString();
      if (e.contains("ERROR_NETWORK_REQUEST_FAILED")) {
        _scaffoldKey.currentState.removeCurrentSnackBar();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Verifique sua conexão com a internet!"),
          backgroundColor: Colors.red,
        ));
      } else if (e.contains("ERROR_USER_NOT_FOUND")) {
        _scaffoldKey.currentState.removeCurrentSnackBar();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Usuário não cadastrado!"),
          backgroundColor: Colors.red,
        ));
      } else if (e.contains("ERROR_USER_DISABLED")) {
        _scaffoldKey.currentState.removeCurrentSnackBar();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
              "Ocorreu um erro!\nPor favor entre em contato com o administrador."),
          backgroundColor: Colors.red,
        ));
      } else if (e.contains("ERROR_WRONG_PASSWORD")) {
        _scaffoldKey.currentState.removeCurrentSnackBar();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Senha incorreta!"),
          backgroundColor: Colors.red,
        ));
      }
      //print("erro" + erro.toString());
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    this._modoApp = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Center(
              child: GestureDetector(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "imagens/login.png",
                        height: 205,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: TextFormField(
                          focusNode: _focusEmail,
                          textInputAction: TextInputAction.go,
                          controller: _controllerEmail,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              icon: Icon(Icons.email),
                              labelText: "E-mail:",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.yellow))),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Campo obrigatório*";
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
                        padding: const EdgeInsets.only(top: 10),
                        child: TextFormField(
                          focusNode: _focusSenha,
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
                          minWidth: 100,
                          height: 50,
                          child: RaisedButton(
                            child: Text(
                              "Entrar",
                              style: TextStyle(
                                  fontSize: 23, color: Util.COR_DO_TEXTO),
                            ),
                            color: Util.COR_DO_BOTAO,
                            onPressed: () {
                              if (!_formKey.currentState.validate()) {
                                /*Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text("Processando")));*/
                              } else {
                                signIn(_controllerEmail.text,
                                    _controllerSenha.text);
                              }
                              FocusScope.of(context).requestFocus(FocusNode());
                              //Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text("Não é cadastrado?"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            //* InkWell -> torna o texto "linkável".
                            child: InkWell(
                              child: Text(
                                "Cadastre-se!",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TelaCadastrarConta()));
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 25, bottom: 10),
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Util.COR_DO_BOTAO))
                                : Container(),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              ),
            )),
      ),
    );
  }
}
