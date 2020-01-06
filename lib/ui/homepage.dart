import 'package:bcard/presentation/custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:bcard/ui/todo.dart';
import 'package:bcard/ui/chat.dart';
import 'package:bcard/ui/cards.dart';
import 'package:bcard/ui/card_profile.dart';
import 'package:bcard/ui/profile.dart';
import 'package:bcard/ui/sharecard.dart';

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int  _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    CardsPage(),
    Todo(),
    CardProfilePage(),
    ShareCardPage(),
    ChatPage()
  ];

  void _onItemTapped(int index){
    setState((){
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "BCard",
            style: TextStyle(
              color: Colors.black
            )
          ),
          leading: IconButton(
            icon: Icon(Icons.person),
            onPressed: (){
              Navigator.of(context).push(_createRoute());
            },
            color: Colors.black
          ),
          backgroundColor: const Color(0xffffffff),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                showSearch(
                  context: context,
                  delegate: DataSearch()
                );
              },
              color: Colors.black,
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
                icon: ImageIcon(AssetImage('assets/icons/feeds.png')),
              title: Text("Feeds")
            ),
            BottomNavigationBarItem(
              icon: Icon(CustomIcons.group_65_2),
              title: Text("To-Do"),
            ),
            BottomNavigationBarItem(
              icon: Icon(CustomIcons.card_collection),
              title: Text("  Cards")
            ),
            BottomNavigationBarItem(
              icon: Icon(CustomIcons.group_140),
              title: Text("Share Card")
            ), BottomNavigationBarItem(
                icon: Icon(CustomIcons.group_651),
                title: Text("Notifications")
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueGrey,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped
        ),
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