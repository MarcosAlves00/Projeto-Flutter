// Flutter code sample for BottomNavigationBar

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

Future<Financas> fetchFinancas() async{

 final response =
      await http.get('https://api.hgbrasil.com/finance?key=c43e72b7');

      if (response.statuscode == 200) {
        
           return Financas.fromJson(json.decode(response.body));

      } else {

        throw Exception('Failed to load post');
      }
}

class Financas {
  
  final String by;
  final Boolean validKey ;
  final Double executionTime;
  final Boolean fromCache;

  Financas({this.by, this.validKey, this.executionTime, this.fromCache});

  factory Financas.fromJson(Map<String, dynamic> json){
  
     return Financas(
       by: json['by'],
       validKey: json['valid_key'],
       executionTime: json['execution_time'],
       fromCache: json['from_cache'],
     );
  }  
}
void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Finanças ';
  MyApp({key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class _MyAppState extends State<MyApp>{
  Future<Financas> financas;

  @override
  void initState(){
    super.initState();
    financas = fetchFinancas();
  }

  @override
  widget build(BuildContext context){
   
    return MaterialApp(
      title: 'Finanças',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Finanças'),
        ),
        body: Center(
          child: FutureBuilder<Financas>(
            future: Financas,
            builder: (context, snapshot){
              if(snapshot.hasData){
                return Text(snapshot.data.title);
              }
              else if Text(snapshot.hasError){
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Conversor',
      style: optionStyle,
    ),
    Text(
      'Index 1: Ibovespa',
      style: optionStyle,
    ),
    Text(
      'Index 2: Moedas',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            title: Text('Conversor'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            title: Text('Ibovespa'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.featured_play_list),
            title: Text('Moedas'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}