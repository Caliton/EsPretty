import 'package:espresso_app/widgets/form_invoice.dart';
import 'package:espresso_app/widgets/item_invoice.dart';
import 'dart:math';
import 'package:espresso_app/class/invoice.dart';
import 'package:espresso_app/components/box_widget.dart';
import 'package:flutter/material.dart';


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
    Future<List>.sync(_listInvoice).then((List list) {
      setState(() {
        listInvoices = list;
      });
    });
  }

  Future<List> _listInvoice() async {
    List list = [];
    final invoiceList = await Invoice().select().toList();
    for (int i = 0; i < invoiceList.length; i++) {
      list.add(invoiceList[i].toMap());
    }
    return list;
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
    Future<List>.sync(_listInvoice).then((List list) {
      listInvoices = list;
    });
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: <Widget>[
              ButtonBar(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: _deleteInvoice,
                    tooltip: 'Deletar todos',
                  ),
                  IconButton(
                    icon: Icon(Icons.add_photo_alternate),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return BoxZnt(
                                title: Text('Registrar Nota'),
                                icon: Icon(Icons.local_atm),
                                body: SingleChildScrollView(
                                    child: InvoiceForms()));
                          }).then((val) async {
                        listInvoices = await _listInvoice();
                        setState(() {});
                      });
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
                      "Cáliton Marcos",
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
                          letterSpacing: 1.0,
                          ),
                    ),
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(30))),
                  child: Image.network("https://picsum.photos/800/400?random") != null 
                  ? Image.network("https://picsum.photos/800/400?random",fit: BoxFit.cover)
                  : AssetImage('assets/bottom.jpg')),),
          ),
          listInvoices.length > 3
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext content, int index) {
                      return Container(
                          decoration: BoxDecoration(color: Colors.white),
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: ItemInvoice(
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
                                  title: 'Ops!',
                                  message:
                                      "Ainda não temos nada registrado :)"),
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
                                      child: ItemInvoice(
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