import 'package:cloud_firestore/cloud_firestore.dart';

class Entregas {
  toMap(DocumentSnapshot snapshot) {
    Map<String, dynamic> dados;
    dados = {
      "nome_cliente": snapshot.data["nome_cliente"],
      "rua": snapshot.data["rua"],
      "numero": snapshot.data["numero"],
      "bairro": snapshot.data["bairro"],
      "telefone": snapshot.data["telefone"],
      "descricao": snapshot.data["descricao"],
    };
    return dados;
  }
}
