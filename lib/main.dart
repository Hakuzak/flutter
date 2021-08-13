// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(
          primaryColor: Colors.greenAccent,
        ),
        initialRoute: '/generator',
        routes: {
          '/generator': (context) => RandomWords(),
          '/favorite': (context) => Favorite(),
          '/addFavorite': (context) => FormFavorite(),
        });
  }
}

class Favorite extends StatelessWidget {
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    final tiles = _RandomWordsState._saved.map(
          (String word) {
        return ListTile(
          title: Text(
            word,
            style: _biggerFont,
          ),
        );
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favoris'),
      ),
      body: ListView(children: divided),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  static List<String> _saved = <String>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  final items = List<String>.generate(100, (i) => "Item $i");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(title: const Text('Startup Name Generator'), actions: []),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          return _buildRow(items[index]);
        }
    );
  }

  Widget _buildRow(String word) {
    final alreadySaved = _saved.contains(word);
    return ListTile(
        title: Text(
          word,
          style: _biggerFont,
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(word);
            } else {
              _saved.add(word);
            }
          });
        });
  }
}

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                )),
            ListTile(
              leading: Icon(Icons.input),
              title: Text('Generator'),
              onTap: () => {Navigator.pushNamed(context, '/generator')},
            ),
            ListTile(
              leading: Icon(Icons.input),
              title: Text('Favoris'),
              onTap: () => {Navigator.pushNamed(context, '/favorite')},
            ),
            ListTile(
              leading: Icon(Icons.input),
              title: Text('Form'),
              onTap: () => {Navigator.pushNamed(context, '/addFavorite')},
            ),
          ],
        ));
  }
}

class FormFavorite extends StatefulWidget {
  const FormFavorite({Key? key}) : super(key: key);

  @override
  _FormFavoriteState createState() => _FormFavoriteState();
}

class _FormFavoriteState extends State<FormFavorite> {
  final _formKey = GlobalKey<FormState>();
  var _saved = _RandomWordsState._saved;
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(title: const Text('Startup Name Generator'), actions: []),
      body: _myForm(),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Widget _myForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: myController,
            decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter a name'
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              if (_saved.contains(value)) {
                return 'Already in favorite';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                _saved.add(myController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ajouté')),
                );
              }
            },
            child: const Text('Submit'),
          ),
          // Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }
}
