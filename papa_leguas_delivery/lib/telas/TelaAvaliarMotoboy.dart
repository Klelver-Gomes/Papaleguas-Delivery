import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:papa_leguas_delivery/model/Util.dart';

class TelaAvaliarMotoboy extends StatefulWidget {
  TelaAvaliarMotoboy({Key key}) : super(key: key);

  @override
  _TelaAvaliarMotoboyState createState() => _TelaAvaliarMotoboyState();
}

class _TelaAvaliarMotoboyState extends State<TelaAvaliarMotoboy> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    return Scaffold(
      /*appBar: AppBar(
          title: Text("Avaliar motoboy",
              style: TextStyle(color: Util.COR_DO_TEXTO)),
          backgroundColor: Util.COR_DO_BOTAO,
          iconTheme: IconThemeData(color: Util.COR_DO_TEXTO)),*/
      body: Form(
        child: Container(
          //color: Colors.grey,
          height: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: GestureDetector(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Image.asset("imagens/Papaleguas.png"),
                  ),
                  Container(
                    width: double.infinity,
                    color: Util.COR_DO_BOTAO,
                    child: Column(
                      children: [
                        Text("Carteira: PPLDMA",
                            style: TextStyle(
                                fontSize: 25, color: Util.COR_DO_TEXTO)),
                        Text(
                          "Nome: Hugo Abrantes",
                          textAlign: TextAlign.justify,
                          style: TextStyle(color: Util.COR_DO_TEXTO),
                        ),
                        Text("Veículo: Honda Fan, NQB-2074",
                            style: TextStyle(
                                fontSize: 15, color: Util.COR_DO_TEXTO),
                            textAlign: TextAlign.justify)
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      color: Util.COR_DO_BOTAO,
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              "Avalie o motoboy:",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Util.COR_DO_TEXTO,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          RatingBar(
                            unratedColor: Util.COR_DO_TEXTO,
                            glowColor: Util.COR_DO_ICONE,
                            itemSize: 40,
                            initialRating: 3.5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating:
                                true, //* permite selecionar meia estrela
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            //ignoreGestures: true,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Util.COR_DO_ICONE,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: TextFormField(
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Justifique sua avaliação",
                          border: OutlineInputBorder(borderSide: BorderSide())),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: ButtonTheme(
                      child: RaisedButton(
                        child: Text("Confirmar avaliação",
                            style: TextStyle(
                                color: Util.COR_DO_TEXTO, fontSize: 20)),
                        color: Util.COR_DO_BOTAO,
                        onPressed: () {},
                      ),
                      height: 50,
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        ),
      ),
    );
  }
}
