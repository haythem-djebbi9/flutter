import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JsonListView(),
    );
  }
}

class JsonListView extends StatefulWidget {
  @override
  _JsonListViewState createState() => _JsonListViewState();
}

class _JsonListViewState extends State<JsonListView> {
  List<dynamic> _data = [];
  List<String> _selectedClasses = [];

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    String jsonString = await rootBundle.loadString('json/db.json');
    setState(() {
      _data = json.decode(jsonString)['etudiants'];
    });
  }

  void _onClassSelected(String className) {
    setState(() {
      if (_selectedClasses.contains(className)) {
        _selectedClasses.remove(className);
      } else {
        if (_selectedClasses.length < 2) {
          _selectedClasses.add(className);
        }
      }
    });
  }

  bool _isStudentInSelectedClasses(dynamic student) {
    if (_selectedClasses.isEmpty) {
      return true;
    }
    return _selectedClasses.contains(student['classe']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste d\'étudiants'),
      ),
      body: _data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                CheckboxListTile(
                  title: Text('DSI22'),
                  value: _selectedClasses.contains('DSI22'),
                  onChanged: (value) {
                    _onClassSelected('DSI22');
                  },
                ),
                CheckboxListTile(
                  title: Text('DSI23'),
                  value: _selectedClasses.contains('DSI23'),
                  onChanged: (value) {
                    _onClassSelected('DSI23');
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (context, index) {
                      var student = _data[index];
                      if (_isStudentInSelectedClasses(student)) {
                        return Card(
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(15),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(student['image']),
                            ),
                            title: Text(
                                'Nom: ${student['nom']} ${student['prenom']}'),
                            subtitle: Text('Age: ${student['age']} ans'),
                            onTap: () {
                              // Action à effectuer lorsque l'utilisateur clique sur un élément de la liste
                            },
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
