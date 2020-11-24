import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:papa_leguas_delivery/model/Util.dart';
import 'package:papa_leguas_delivery/telas/TelaCadastrarConta.dart';

import 'TelaLogin.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  changeStatusbar() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Util.COR_DO_BOTAO));
  }

  @override
  void initState() {
    super.initState();
    changeStatusbar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      //padding: EdgeInsets.only(top: 50),
      color: Util.COR_DE_FUNDO,
      width: double.infinity,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Image.asset(
                      "imagens/logo.png",
                      width: 250,
                      height: 250,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: RaisedButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => TelaLogin())),
                      child: Text(
                        "Login",
                        style:
                            TextStyle(fontSize: 22, color: Util.COR_DO_TEXTO),
                      ),
                      color: Util.COR_DO_BOTAO,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                    child: RaisedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TelaCadastrarConta())),
                      child: Text(
                        "Seja um Papalégua!",
                        style:
                            TextStyle(fontSize: 22, color: Util.COR_DO_TEXTO),
                      ),
                      color: Util.COR_DO_BOTAO,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
