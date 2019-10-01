import 'package:flutter/material.dart';

import 'todo.dart';
import 'chat.dart';
import 'cards.dart';
import 'profile.dart';
import 'card_profile.dart';
import 'sharecard.dart';
import 'login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BCard',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: DefaultTabController(
        length: 5,
        child: HomePage()
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int  _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Todo(),
    ChatPage(),
    CardsPage(),
    ProfilePage(),
    ShareCardPage()
  ];

  void _onItemTapped(int index){
    setState((){
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BCard"
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(
                context: context,
                delegate: DataSearch()
              );
            },
            padding: EdgeInsets.all(10.0)
          )
        ],
      ),
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex)
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
              showSearch(
                context: context,
                delegate: DataSearch()
              );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text("Chat")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership),
            title: Text("Cards")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            title: Text("Share Card")
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String>{

  final members = [
    "Sanket Chaudhari",
    "Jahnavi Gupta",
    "Sanu Kumar",
    "Mark Zuckerberg",
    "Bill Gates",
    "Avicii",
    "Martin Garrix",
    "Tiesto",
    "The Chainsmokers",
    "Bebe Rexha",
    "James Gosling",
    "Larry Page",
    "Sergey Brin",
    "Lauv",
    "Marshmello",
    "Steve Jobs",
    "Linus Torvalds",
    "Tim Berners Lee"
  ];

  final recentSearches = [
    "Sanket Chaudhari",
    "Martin Garrix",
    "The Chainsmokers",
    "Mark Zuckerberg"
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    int i = recentSearches.indexOf(query);
    if(query.length != 0){
      if(i != -1){
        recentSearches.removeAt(i);
      }
      recentSearches.insert(0, query);
    }
    return Container(
      child: Center(
        child: Text("Search Result of $query")
      )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty ? recentSearches : members.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: (){
          query = suggestionList[index];
          query = suggestionList[index];
        },
        title: RichText(
          text: TextSpan(
            text: suggestionList[index].substring(0, query.length),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
            children: [
              TextSpan(
                text: suggestionList[index].substring(query.length),
                style: TextStyle(
                  color: Colors.grey
                )
              )
            ]
          )
        )
      ),
      itemCount: suggestionList.length,
    );
  }

}