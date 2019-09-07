import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String numberColumn = "numberColumn";
final String imageColumn = "imageColumn";

class Contact_helper {
  static final Contact_helper _instance = Contact_helper.internal();
  factory Contact_helper() => _instance;
  Contact_helper.internal();


  Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contactsNew.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
          await db.execute(
              "CREATE TABLE  $contactTable($idColumn INTERGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $numberColumn TEXT, $imageColumn TEXT)");
        });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;

  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;

    List<Map> maps = await dbContact.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, numberColumn, imageColumn],
        where: "$idColumn  = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else
      return null;
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact
        .delete(contactTable, where: "$idColumn = ? ", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db;
    return await dbContact.update(contactTable, contact.toMap(),
        where: "$idColumn = ? ", whereArgs: [contact.id]);
  }

  Future<List> getAllContacts() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContactc = List();

    for (Map m in listMap) {
      listContactc.add(Contact.fromMap(m));
    }
    return listContactc;
  }

  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }
}



class Contact {
  int id;
  String name;
  String email;
  String phoneNumber;
  String image;

  Contact();

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phoneNumber = map[numberColumn];
    image = map[imageColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      numberColumn: phoneNumber,
      imageColumn: image
    };

    if (id != null) {
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    return ("Contact <->\n id: $id\n name: $name\n email: $email\n number: $phoneNumber\n image: $image\n");
  }
}
