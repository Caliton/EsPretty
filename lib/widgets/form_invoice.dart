import 'dart:io';
import 'package:espresso_app/class/invoice.dart';
import 'package:espresso_app/widgets/camera_invoice.dart';
import 'package:flutter/material.dart';


class InvoiceForms extends StatefulWidget {
  const InvoiceForms({Key key}) : super(key: key);

  @override
  _InvoiceForms createState() => _InvoiceForms();
}

class _InvoiceForms extends State<InvoiceForms> {
  final _formKey = GlobalKey<FormState>();
  final _invoice = Invoice();
  File _imageFile;
  String _discorveryText;

  final TextEditingController txtModel = TextEditingController();

  _dashboard() async {
    final data = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CameraApp()));
    print(data);
    _imageFile = File(data[0]);
    _discorveryText = data[1];
  }

  @override
  Widget build(BuildContext context) {
    txtModel.text = _discorveryText;
    return Container(
      child: Wrap(
        children: <Widget>[
          this._imageFile == null
              ? Card(
                  color: Colors.green[200],
                  margin: EdgeInsets.all(20.0),
                  elevation: 0,
                  child: Container(
                    height: 100.0,
                    child: InkWell(
                      splashColor: Colors.cyan,
                      onTap: () async => await _dashboard(),
                      child: Center(
                        child: Image.asset("assets/photo-camera.png"),
                      ),
                    ),
                  ),
                )
              : Card(
                  color: Colors.green[200],
                  margin: EdgeInsets.all(20.0),
                  elevation: 0,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: 200,
                    child: InkWell(
                      onTap: () async => await _dashboard(),
                      child: Center(
                        child: Image.file(
                          this._imageFile,
                          fit: BoxFit.fill,
                          height: 200,
                          width: 250,
                        ),
                      ),
                    ),
                  ),
                ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
            child: Builder(
              builder: (context) => Form(
                key: _formKey,
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: <Widget>[
                    fieldZnt(
                      fieldName: 'Descrição',
                      textSize: 15,
                      icon: Icons.local_play,
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Preencha ai fera!';
                        }
                        _invoice.description = value.toString();
                        return null;
                      },
                    ),
                    fieldZnt(
                      fieldName: 'O que pode estar escrito?',
                      textSize: 15,
                      controller: txtModel,
                      maxLines: null,
                      icon: Icons.remove_red_eye,
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Preencha ai fera!';
                        }
                        if (this._discorveryText != null) {
                          _invoice.status = this._discorveryText;
                        } else {
                          _invoice.status = value.toString();
                        }
                        return null;
                      },
                    ),
                    Container(
                      child: RaisedButton(
                        color: Color(0xFF1DCC8C),
                        textColor: Colors.white,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _invoice.path = this._imageFile.path;
                            await _invoice.save();
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Salvar'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget fieldZnt(
      {String fieldName = 'Campo: ',
      double widthCustom,
      double textSize = 15,
      int maxLines,
      IconData icon,
      String initialValue,
      TextEditingController controller,
      TextInputType inputType,
      Function funcao,
      Function validator}) {
    return Container(
      width: widthCustom,
      child: TextFormField(
        onChanged: funcao,
        maxLines: maxLines,
        controller: controller,
        initialValue: initialValue,
        keyboardType: inputType,
        validator: validator,
        textCapitalization: TextCapitalization.words,
        style: TextStyle(fontSize: textSize),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFF1F1F1),
          // border: OutlineInputBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(30))),
          prefixIcon: Icon(
            icon,
            size: 30,
          ),
          labelText: fieldName,
        ),
        onSaved: (String value) {
          debugPrint(value);
        },
      ),
    );
  }
}
