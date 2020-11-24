class Motoboy {
  String _email;
  String _senha;
  String _nomeCompleto;
  String _endereco;
  String _bairro;
  int _numero;
  String _telefone;
  String _cpf;
  String _dataNascimento; //? verificar possibilidade de mudar para DateTime
  String _cnh;
  String _dataExpedicao;
  String _modeloMoto;
  String _placa;
  //? FOTO CNH;

  Motoboy(
      this._email,
      this._senha,
      this._nomeCompleto,
      this._endereco,
      this._bairro,
      this._numero,
      this._telefone,
      this._cpf,
      this._dataNascimento,
      this._cnh,
      this._dataExpedicao,
      this._modeloMoto,
      this._placa);
}
