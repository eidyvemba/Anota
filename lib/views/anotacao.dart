import 'package:flutter/material.dart';
import 'package:anota/inherited_widgets/anotacao_inherited_widgets.dart';
import 'package:anota/db/anotacao_db.dart';

enum AnotacaoModo {
  Editar,
  Nova,
  Apagar
}

class Anotacao extends StatefulWidget{
  final AnotacaoModo anotacaoModo;
  final Map<String, dynamic> anotacao;
  Anotacao(this.anotacaoModo, this.anotacao);

  @override
  AnotacaoState createState(){ return new AnotacaoState(); }

}

class AnotacaoState extends State<Anotacao> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _textoController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  
  List<Map<String, String>> get _anotacoes => AnotacaoInheritedWidget.of(context).anotacoes;


  @override
  void didChangeDependencies(){
    if (widget.anotacaoModo == AnotacaoModo.Editar){
      _tituloController.text = widget.anotacao['titulo'];
      _textoController.text = widget.anotacao['texto'];
      _dataController.text = widget.anotacao['data_criacao'];
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.anotacaoModo ==  AnotacaoModo.Nova ? 'Nova' : 'Editar'

        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(
                hintText: 'Titulo',
              ),
            ),
            Container(height: 8,),
            TextField(
              controller: _textoController,
              decoration: InputDecoration(
                hintText: 'Texto',
              ),
            ),
            Container (height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: <Widget>[
               _AnotacaoButton('Guardar', Colors.purple, (){
                 final titulo = _tituloController.text;
                 final texto = _textoController.text;
                 if (widget?.anotacaoModo == AnotacaoModo.Nova){
                    AnotacaoDB.insereAnotacao({
                      'titulo': titulo,
                      'texto': texto,
                      'data_criacao': DateTime.now(),
                      'data_edicao': DateTime.now(),
                      'status': 1
                    });
                   /*_anotacoes.add({
                     'titulo': titulo,
                     'texto': texto,
                     'data': 'Segunda-Feira 14:49'
                   });*/
                 }else if (widget?.anotacaoModo == AnotacaoModo.Editar){
                   AnotacaoDB.updateAnotacao({
                     'id': widget.anotacao['id'],
                     'titulo': _tituloController,
                     'texto': _textoController
                   });
                 }
                 Navigator.pop(context);
               }),
               Container (height: 16,),
               _AnotacaoButton('Cancelar', Colors.grey, (){
                 Navigator.pop(context);
               }),
               Container (height: 16,),
               widget.anotacaoModo == AnotacaoModo.Editar ?
                Padding(
                   padding: const EdgeInsets.only(left: 2.0),
                   child: _AnotacaoButton('Apagar', Colors.red, () async{
                     //_anotacoes.removeAt(widget.index);
                     await AnotacaoDB.apagarAnotacao(widget.anotacao['id']);
                     Navigator.pop(context);
                   })
                 ) : Container()
             ],
            )
          ],
        )
      ),
    );
  }
}

class _AnotacaoButton extends StatelessWidget {
  final String _texto;
  final Color _cor;
  final Function _onPressed;

  _AnotacaoButton(this._texto, this._cor, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _onPressed,
      child: Text(
        _texto,
        style: TextStyle(color: Colors.white),
      ),
      height: 40,
      minWidth: 80,
      color: _cor,
    );
  }
}
