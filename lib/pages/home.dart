import 'dart:io';
import 'package:path/path.dart' show join;
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:espresso_app/class/invoice.dart';
import 'package:espresso_app/components/box-znt-widget.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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

  @override
  initState() {
    super.initState();
    Future<List>.sync(_listInvoice).then((List asdf) {
      setState(() {
        listInvoices = asdf;
      });
    });
  }

  Future<List> _listInvoice() async {
    List eitaPorra = [];
    final invoiceList = await Invoice().select().toList();
    for (int i = 0; i < invoiceList.length; i++) {
      eitaPorra.add(invoiceList[i].toMap());
    }
    print('Modelo: ');
    print(eitaPorra);
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
                      "Full Stack Developer",
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
                                          title: listInvoices[index]["status"],
                                          content: listInvoices[index]
                                              ["description"],
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
                  'R\$ ' + widget.title,
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
                          ),
                          child: Image.file(File(widget.image)),
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
                          Image.file(File(objeto.image)),
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

  _dashboard() async {
    print('Buhhh');
    final image = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CameraApp()));
    print('PUTA KI PARIUUUU NENEMMM');
    _imageFile = File(image);
    print(_imageFile);
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

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
                      inputType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Preencha ai fera!';
                        }
                        _invoice.status = value.toString();
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

  Future _pickImageFromCamera() async {
    // await ImagePicker.pickImage(source: ImageSource.camera);
    final imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = imageFile;
    });
  }
}

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  List<CameraDescription> cameras;
  // Future _vish(imagePath) async {
  //   final FirebaseVisionImage visionImage =
  //       FirebaseVisionImage.fromFile(File(imagePath));
  //   final VisionText visionText =
  //       await textRecognizer.detectInImage(visionImage);
  //   return visionText;
  // }

  CameraController controller;

  Future<List<CameraDescription>> _listCamera() async {
    final camera = await availableCameras();
    return camera;
  }

  @override
  initState() {
    super.initState();
    Future.sync(_listCamera).then((List<CameraDescription> camera) {
      setState(() {
        cameras = camera;

        controller = CameraController(cameras[0], ResolutionPreset.medium);
        controller.initialize().then((_) {
          if (!mounted) {
            return;
          }
        });
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Fotinha'),
      ),
      body: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            final path = join(
              (await getApplicationDocumentsDirectory()).path,
              'photo-${DateTime.now()}.png',
            );
            await controller.takePicture(path);

            final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
            final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(File(path));
            final VisionText visionText = await textRecognizer.detectInImage(visionImage);

            print('AAAAAAAAAAAAAAAAAAAAAAAROOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ');
            String text = visionText.text;
            print('Text: ');
            print(text);
            
            for (TextBlock block in visionText.blocks) {
              final Rectangle<int> boundingBox = block.boundingBox;
              final List<Point<int>> cornerPoints = block.cornerPoints;
              final String text = block.text;
              final List<RecognizedLanguage> languages =
                  block.recognizedLanguages;

              print('Text: ');
              print(text);
              print('Rectangle: ');
              print(boundingBox);
              print('CornerPoints: ');
              print(cornerPoints);
              print('Languages: ');
              print(languages);

              print('Vô: ');
              for (TextLine line in block.lines) {
                print('Pai: ');
                print(line);
                for (TextElement element in line.elements) {
                  print('Filho: ');                  // Same getters as TextBlock
                  print(element);
                }
              }
            }

            Navigator.pop(context, path);
          } catch (e) {
            print(
                "================================================================================================");
            print(e);
          }
        },
      ),
    );
  }
}
