import 'package:flutter/material.dart';

class BoxZnt extends StatefulWidget {
  final Text title;
  final Icon icon;
  final body;

  const BoxZnt({Key key, this.title, this.icon, this.body}) : super(key: key);

  @override
  _BoxZntState createState() => _BoxZntState();
}

class _BoxZntState extends State<BoxZnt> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 110, horizontal: 25),
        child: Material(
          elevation: 1,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(8),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
              appBar: AppBar(
                leading: widget.icon,
                elevation: 0,
                title: widget.title,
                backgroundColor: Theme.of(context).accentColor,
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context, setState((){}));
                    },
                  )
                ],
              ),
              body: widget.body),
        ));
  }
}
