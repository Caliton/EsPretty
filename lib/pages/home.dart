import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:espresso_app/class/invoice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List listInvoices = [];
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;
  var data = [
    {
      "title": "Titulo da Imagem",
      "content": "Descrição da imagem",
      "color": cores[new Random().nextInt(5)],
      "image": "https://picsum.photos/id/677/200/200"
    },
    {
      "title": "Titulo da Imagem",
      "content": "Descrição da imagem",
      "color": cores[new Random().nextInt(5)],
      "image": "https://picsum.photos/id/428/200/200"
    },
    {
      "title": "Titulo da Imagem",
      "content": "Descrição da imagem",
      "color": cores[new Random().nextInt(5)],
      "image": "https://picsum.photos/id/428/200/200"
    },
    {
      "title": "Titulo da Imagem",
      "content": "Descrição da imagem",
      "color": cores[new Random().nextInt(5)],
      "image": "https://picsum.photos/id/428/200/200"
    },
    {
      "title": "Titulo da Imagem",
      "content": "Descrição da imagem",
      "color": cores[new Random().nextInt(5)],
      "image": "https://picsum.photos/id/428/200/200"
    },
    {
      "title": "Titulo da Imagem",
      "content": "Descrição da imagem",
      "color": cores[new Random().nextInt(5)],
      "image": "https://picsum.photos/id/428/200/200"
    },
    {
      "title": "Titulo da Imagem",
      "content": "Descrição da imagem",
      "color": cores[new Random().nextInt(5)],
      "image": "https://picsum.photos/id/428/200/200"
    },
    {
      "title": "Titulo da Imagem",
      "content": "Descrição da imagem",
      "color": cores[new Random().nextInt(5)],
      "image": "https://picsum.photos/id/428/200/200"
    },
    {
      "title": "Titulo da Imagem",
      "content": "Descrição da imagem",
      "color": cores[new Random().nextInt(5)],
      "image": "https://picsum.photos/id/428/200/200"
    },
    {
      "title": "Titulo da Imagem",
      "content": "Descrição da imagem",
      "color": cores[new Random().nextInt(5)],
      "image": "https://picsum.photos/id/428/200/200"
    },
    {
      "title": "Titulo da Imagem",
      "content": "Descrição da imagem",
      "color": cores[new Random().nextInt(5)],
      "image": "https://picsum.photos/id/428/200/200"
    }
  ];

  _getImage () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ImagePickerExample()));
  }

  Future<Null> _listInvoice() async {
    final invoiceList = await Invoice().select().toList();
    listInvoices = [];
    for(int i = 0; i < invoiceList.length; i++) {
      invoiceList[i].toMap();
      this.listInvoices.addAll(invoiceList);
      print(invoiceList[i].id);
      print(invoiceList.toList());
    }
    print('Eita porrao: ');
    print(this.listInvoices[0].toMap());
  }
  @override
  Widget build(BuildContext context) {
    _listInvoice();
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: <Widget>[
                      ButtonBar(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.update),
              onPressed: _listInvoice,
              tooltip: 'Shoot picture',
            ),
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: _getImage,
              tooltip: 'Shoot picture',
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
                  offset:/*false ? Offset(-50.0, 0.0) : */Offset(-40.0, 25.0),
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext content, int index) {
                return Container(
                    decoration: BoxDecoration(color: Colors.white),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: AwesomeListItem(
                        id: listInvoices[index].id,
                        title: listInvoices[index].description,
                        content: listInvoices[index].status,
                        color: cores[new Random().nextInt(5)],
                        image: listInvoices[index].path
                    )
                );
              },
              childCount: listInvoices.length,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.greenAccent,
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
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
        ListView(
      children: <Widget>[
        ButtonBar(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () async => await _pickImageFromCamera(),
              tooltip: 'Shoot picture',
            ),
            IconButton(
              icon: Icon(Icons.photo),
              onPressed: () async => await _pickImageFromGallery(),
              tooltip: 'Pick from gallery',
            ),
          ],
        ),
        this._imageFile == null ? Placeholder() : Image.file(this._imageFile),
        TextField(
          
        )
      ],
      ),
    );
  }

  Future<Null> _pickImageFromGallery() async {
    final File imageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() => this._imageFile = imageFile);
  }

  Future<Null> _pickImageFromCamera() async {
    final invoice = Invoice();
    invoice.description = "Nota Fiscal 1";
    invoice.status = 'R\$ 50,00';
    final File imageFile =
        await ImagePicker.pickImage(source: ImageSource.camera);
        print('Caraiadade Foto');
        print(this._imageFile);

    setState(() {
      this._imageFile = imageFile;
      invoice.path = this._imageFile.path;
      print('Olha a fottoooo aiiii gente!!!! ');
      print(this._imageFile);
      print('Vish olha a notinha ai gente!!!!');
      print(invoice);
      return this._imageFile;
    });
    invoice.path = this._imageFile.path;
    await invoice.save();
  }

  Widget fieldZnt(
      {String fieldName = 'Campo: ',
      double widthCustom,
      double textSize = 20,
      IconData icon,
      TextInputType inputType,
      Function funcao,
      List<TextInputFormatter> inputFormatters}) {
    return Container(
      width: widthCustom,
      child: TextFormField(
        inputFormatters: inputFormatters,
        onChanged: funcao,
        keyboardType: inputType,
        validator: (value) {
          if (value.isEmpty) {
            return 'Preenche os Campos!';
          }
          return null;
        },
        textCapitalization: TextCapitalization.words,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: textSize),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white38,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          prefixIcon: Icon(
            icon,
            size: 30,
          ),
          hoverColor: Colors.brown,
          hintText: 'Titulo',
          labelText: fieldName,
        ),
        onSaved: (String value) {
          print('PORRADA');
          debugPrint(value);
        },
      ),
    );
  }
}