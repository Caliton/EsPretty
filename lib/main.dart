import 'package:espresso_app/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:espresso_app/config/config-database.dart';


String _modelString;
String get modelString => _modelString;

set modelString(String modelStrings) {
  _modelString = modelStrings;
}

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  final String sqfEntityModelString = 'banco atualizado';
  // final bool isInitialized = true;
  // Atualizar o banco só vim aki e descomentar e comentar o de cima....
  // final String sqfEntityModelString = MyDbModel().createModel();

  final bool isInitialized = await MyDbModel().initializeDB();
  if (isInitialized == true) {
    print("Banco de Dados Inicializado com Sucesso!");
    runApp(MyApp(sqfEntityModelString));
  } else {
    print('Algum problema ao iniciar o banco');
  }
}
class MyApp extends StatelessWidget {
  MyApp(String setmodelString) {
    modelString = setmodelString;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EsPretty',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Color(0xFF1DCC8C)
      ),
      home: SplashScreen()
    );
  }
}

class CopiarModeloGerado extends StatelessWidget {
  final TextEditingController txtModel =
      TextEditingController(text: modelString);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SqfEntity Model Creator"),
        leading: Icon(Icons.assignment),
      ),
      body: _buildHomePage(context),
    );
  }

    Container _buildHomePage(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      // hack textfield height
      padding: EdgeInsets.only(bottom: 40.0),
      child: TextField(
        controller: txtModel,
        maxLines: 99,
      ),
    );
  }
}