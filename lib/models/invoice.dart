import 'package:sqfentity/sqfentity.dart';

class InvoiceTable extends SqfEntityTable {
InvoiceTable() {
// declare properties of EntityTable
tableName = "invoice";
modelName = 'Invoice'; // If the modelName (class name) is null then EntityBase uses TableName instead of modelName
primaryKeyName = "id";
useSoftDeleting = false;

// declare fields
fields = [
  SqfEntityField("description", DbType.text),
  SqfEntityField("path", DbType.text),
  SqfEntityField("status", DbType.text)
];

super.init();
}
static SqfEntityTable _instance;
  static SqfEntityTable get getInstance {
    if (_instance == null) {
      _instance = InvoiceTable();
    }
    return _instance;
  }
}