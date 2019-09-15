import 'dart:io';
import 'package:flutter/material.dart';

class ItemInvoice extends StatefulWidget {
  int id;
  String title;
  String content;
  Color color;
  String image;

  ItemInvoice({this.title, this.content, this.color, this.image, this.id});

  @override
  _ItemInvoiceState createState() => new _ItemInvoiceState();
}

class _ItemInvoiceState extends State<ItemInvoice> {
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
                        tag: 'view-invoice-${widget.id}',
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
                  tag: 'view-invoice-{objeto.id}',
                  child: Container(
                    child: ClipRect(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 350.0,
                            width: 350.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 10.0,
                                  color: Colors.white,
                                  style: BorderStyle.solid),
                            ),
                            child: Image.file(File(objeto.image)),
                          ),
                          Padding(padding: EdgeInsets.only(top: 40.0)),
                          Text(
                            objeto.title,
                            style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 35.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )),
            ))));
  }
}
