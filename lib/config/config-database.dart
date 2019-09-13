import 'package:sqfentity/sqfentity.dart';
import 'package:espresso_app/models/invoice.dart';

class MyDbModel extends SqfEntityModel {
  MyDbModel() {
    databaseName = "dbespretty.db";
    databaseTables = [
      InvoiceTable.getInstance
    ];

    sequences = [SequenceIdentity()];
    bundledDatabasePath = null;
    customImports = "import 'MyDbModel.dart';";
  }
}

class SequenceIdentity extends SqfEntitySequence {
  SequenceIdentity() {
    sequenceName = "identity";
    minValue = 0;
    maxValue = 10000;
    incrementBy = 1;
    startWith = 5;
    super.init();
  }
}