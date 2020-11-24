import 'package:flutter/material.dart';
import 'package:papa_leguas_delivery/model/Util.dart';

class TelaTransferencia extends StatefulWidget {
  TelaTransferencia({Key key}) : super(key: key);

  @override
  _TelaTransferenciaState createState() => _TelaTransferenciaState();
}

class _TelaTransferenciaState extends State<TelaTransferencia> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transferência"),
      ),
      body: GestureDetector(
        child: SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 10, left: 5, right: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Column(
                    children: [
                      Image.asset("imagens/Papaleguas.png"),
                      Container(
                        color: Util.COR_DO_TEXTFIELD,
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: Text(
                              "Quanto deseja transferir?",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "R\$ ",
                        style: TextStyle(fontSize: 25),
                      ),
                      Expanded(
                        child: TextFormField(
                            controller: _controller,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "0,00",
                              hintStyle: TextStyle(fontSize: 20),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.yellow)),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: ButtonTheme(
                    height: 50,
                    child: RaisedButton(
                      color: Util.COR_DO_BOTAO,
                      onPressed: () {},
                      child: Text(
                        "Continuar ->",
                        style: TextStyle(fontSize: 20, color: Util.COR_DO_TEXTO),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
      ),
    );
  }
}
