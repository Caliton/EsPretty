import 'dart:io';
import 'dart:math';
import 'package:espresso_app/class/invoice.dart';
import 'package:espresso_app/components/box-znt-widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

var cores = [
  Color(0xFFFD5C6F), // #FD5C6F
  Color(0xFFFF8F71), // #FF8F71
  Color(0xFFFFBE73), // #FFBE73
  Color(0xFFF9EE80), // #F9EE80
  Color(0xFF2EDDDA) // #2EDDDA
];

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List listInvoices;
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;

  // _getImage() {
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => ImagePickerExample()));
  // }

  @override
  initState() {
    super.initState();
    Future<List>.sync(_listInvoice).then((List asdf) {
      setState(() {
        print("MAMAMAMAMAMMAMAMAMAMA");
        print(asdf);
        listInvoices = asdf;
        print(listInvoices);
      });
    });
  }

  Future<List> _listInvoice() async {
    List eitaPorra = [];
    final invoiceList = await Invoice().select().toList();
    for (int i = 0; i < invoiceList.length; i++) {
      eitaPorra.add(invoiceList[i].toMap());
    }
    return eitaPorra;
  }

  Future<Null> _deleteInvoice() async {
    await Invoice().select().delete();
    listInvoices = [];
    setState(() {
      _listInvoice();
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<List>.sync(_listInvoice).then((List asdf) {
      print(asdf);
      listInvoices = asdf;
      print(listInvoices);
    });
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: <Widget>[
              ButtonBar(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.update),
                    onPressed: () {
                      setState(() {
                        _listInvoice();
                      });
                    },
                    tooltip: 'Atualizar Lista',
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: _deleteInvoice,
                    tooltip: 'Deletar todos',
                  ),
                  IconButton(
                    icon: Icon(Icons.add_photo_alternate),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => BoxZnt(
                              title: Text('Registrar Nota'),
                              icon: Icon(Icons.local_atm),
                              body: SingleChildScrollView(
                                  child: ImagePickerExample())));
                    },
                    tooltip: 'Captura uma foto',
                  ),
                ],
              ),
            ],
            automaticallyImplyLeading: false,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30))),
            pinned: this._pinned,
            snap: this._snap,
            floating: this._floating,
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
                title: Transform.translate(
                  offset: /*false ? Offset(-50.0, 0.0) : */ Offset(-40.0, 25.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/perfil1.png"),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      "Caliton Marcos",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          letterSpacing: 2.0,
                          shadows: [
                            Shadow(
                                blurRadius: 20.0,
                                color: Colors.black,
                                offset: Offset(0.0, 0.0)),
                          ]),
                    ),
                    subtitle: Text(
                      "Developer Full Stack",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                          letterSpacing: 1.0),
                    ),
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(30))),
                  child: Image.network("https://picsum.photos/800/400?random",
                      fit: BoxFit.cover),
                )),
          ),
          listInvoices.length > 3
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext content, int index) {
                      return Container(
                          decoration: BoxDecoration(color: Colors.white),
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: AwesomeListItem(
                              id: listInvoices[index]["id"],
                              title: listInvoices[index]["description"],
                              content: listInvoices[index]["status"],
                              color: cores[new Random().nextInt(5)],
                              image: listInvoices[index]["path"]));
                    },
                    childCount: listInvoices.length,
                  ),
                )
              : SliverFillRemaining(
                  child: Container(
                      child: listInvoices.length == 0
                          ? Center(
                              // margin: EdgeInsets.symmetric(horizontal: 20),
                              child: emptyState(
                                  title: 'Oppss!',
                                  message:
                                      "Não temos nenhuma nota registrada :)"),
                            )
                          : Center(
                              child: ListView.builder(
                                itemCount: listInvoices.length,
                                itemBuilder: (BuildContext content, int index) {
                                  return Container(
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      margin: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      child: AwesomeListItem(
                                          id: listInvoices[index]["id"],
                                          title: listInvoices[index]
                                              ["description"],
                                          content: listInvoices[index]
                                              ["status"],
                                          color: cores[new Random().nextInt(5)],
                                          image: listInvoices[index]["path"]));
                                },
                              ),
                            )),
                ),
        ],
      ),
      backgroundColor: Colors.greenAccent,
    );
  }

  Widget emptyState({
    title: '',
    message: '',
  }) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 16,
      color: Theme.of(context).cardColor.withOpacity(.95),
      shadowColor: Theme.of(context).accentColor.withOpacity(.5),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.headline),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(message),
            )
          ],
        ),
      ),
    );
  }
}

class AwesomeListItem extends StatefulWidget {
  int id;
  String title;
  String content;
  Color color;
  String image;

  AwesomeListItem({this.title, this.content, this.color, this.image, this.id});

  @override
  _AwesomeListItemState createState() => new _AwesomeListItemState();
}

class _AwesomeListItemState extends State<AwesomeListItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(width: 10.0, height: 150.0, color: widget.color),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    widget.content,
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 150.0,
          width: 150.0,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Transform.translate(
                offset: Offset(50.0, 0.0),
                child: Container(
                  height: 100.0,
                  width: 100.0,
                  color: widget.color,
                ),
              ),
              Transform.translate(
                  offset: Offset(10.0, 20.0),
                  child: Card(
                    elevation: 20.0,
                    child: GestureDetector(
                      child: Hero(
                        tag: 'meu-saco-${widget.id}',
                        child: Container(
                          height: 120.0,
                          width: 120.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 10.0,
                                  color: Colors.white,
                                  style: BorderStyle.solid),
                              image: DecorationImage(
                                image: AssetImage(widget.image),
                              )),
                        ),
                      ),
                      onTap: () => _showSecondPage(context, widget),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  void _showSecondPage(BuildContext context, var objeto) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => Scaffold(
                body: Center(
              child: Hero(
                  tag: 'meu-saco-{objeto.id}',
                  child: Container(
                    child: ClipRect(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(objeto.image),
                          Text(objeto.title)
                        ],
                      ),
                    ),
                  )),
            ))));
  }
}

class ImagePickerExample extends StatefulWidget {
  const ImagePickerExample({Key key}) : super(key: key);

  @override
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  final _formKey = GlobalKey<FormState>();
  final _invoice = Invoice();
  File _imageFile;

  @override
  Widget build(BuildContext context) {
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
                      onTap: () async => await _pickImageFromCamera(),
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
                      onTap: () async => await _pickImageFromCamera(),
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
                      fieldName: 'Value',
                      textSize: 15,
                      icon: Icons.attach_money,
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Preencha ai fera!';
                        }
                        _invoice.status = value.toString();
                        return null;
                      },
                    ),
                    Container (
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
      IconData icon,
      TextInputType inputType,
      Function funcao,
      Function validator}) {
    return Container(
      width: widthCustom,
      child: TextFormField(
        onChanged: funcao,
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

  Future<Null> _pickImageFromCamera() async {
    final File imageFile =
        await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      this._imageFile = imageFile;
      return this._imageFile;
    });
  }
}
