// ignore: file_names
import 'package:flutter/material.dart';
import 'package:testnote/db.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _notelist = [];

  bool _loading = true;

  Future<void> _refreshdata() async {
    final datas = await SQLHelper.getItems();
    setState(() {
      _notelist = datas;
      _loading = false;
    });
  }

  @override
  void initState() {
    
    super.initState();
    _refreshdata();
    print("list of ${_notelist.length}");
  }

  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();

  Future<void> _addItem() async {
    print(_title.text.toString());
    print(_description.text.toString());
    await SQLHelper.createItem(
        _title.text.toString(), _description.text.toString());
    _refreshdata();
    print("list of ${_notelist.length}");
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.Updataitem(id, _title.text, _description.text);
    _refreshdata();
  }

  Future<void> deleteItem(id) async {
    await SQLHelper.deleteItem(id);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
        // ignore: prefer_const_constructors
        .showSnackBar(SnackBar(content: Text("this item successfully delete")));
    _refreshdata();
  }

  void Showform(int? id) {
//     sqfliteFfiInit();

//  databaseFactory = databaseFactoryFfi;

    if (id != null) {
      final existNoteList =
          _notelist.firstWhere((element) => element['id'] == id);
      _title.text = existNoteList['title'];
      _description.text = existNoteList['description'];
    }

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => ConstrainedBox(
          // ignore: prefer_const_constructors
          constraints: BoxConstraints(maxHeight: 500,minHeight: 400,),
          child: Container(
                // height: 500,
                // ignore: prefer_const_constructors
                decoration: BoxDecoration(
                  
                ),
                padding:
                    EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
                child: Column(
                  children: [
                    TextField(
                      controller: _title,
                      decoration: InputDecoration(hintText: 'title'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _description,
                      decoration: InputDecoration(hintText: 'description'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (id == null) {
                            await _addItem();
                          }
                          if (id != null) {
                            await _updateItem(id);
                          }
                          _title.text = "";
                          _description.text = "";
        
                          Navigator.of(context).pop();
                        },
                        child: Text(id == null ? "create new" : "update"))
                  ],
                ),
              ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Note App",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: _notelist.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.deepPurple,
              child: ListTile(
                title: Text(
                  _notelist[index]['title'],
                  style: TextStyle(color: Color.fromARGB(255, 173, 217, 255)),
                ),
                subtitle: Text(_notelist[index]['description'],
                    style:
                        TextStyle(color: Color.fromARGB(255, 173, 217, 255))),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Showform(_notelist[index]['id']);
                            print(_notelist[index]['id']);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.green,
                          )),
                      IconButton(
                          onPressed: () {
                            print(_notelist[index]['id']);
                            deleteItem(_notelist[index]['id']);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ))
                    ],
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Showform(null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
