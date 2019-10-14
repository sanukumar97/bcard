import 'package:flutter/material.dart';

import 'todo.dart';
import 'chat.dart';
import 'cards.dart';
import 'profile.dart';
import 'card_profile.dart';
import 'sharecard.dart';
import 'login_screen.dart';

class CardProfilePage extends StatefulWidget {

  static List<Widget> _widgetOptions = <Widget>[
    Todo(),
    ChatPage(),
    CardsPage(),
    ProfilePage(),
    ShareCardPage()
  ];

  @override
  _CardProfilePageState createState() => _CardProfilePageState();
}

class _CardProfilePageState extends State<CardProfilePage> {
  final _formKey = GlobalKey<FormState>();
  int  _selectedIndex = 0;

  void _onItemTapped(int index){
    setState((){
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
        child: CardProfilePage._widgetOptions.elementAt(_selectedIndex)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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

class CardProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(2.0),
      children: <Widget>[
        Container(
          height: 200.0,
          child: Card(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text(
                      "Sanket Chaudhari",
                      style: TextStyle(
                        fontSize: 20.0,
                      )
                    )
                  )
                ),
                Expanded(
                  child: Center(
                    child: Card(
                      color: Colors.blueGrey[100],
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Center(
                          child: Text("Photo")
                        )
                      )
                    ),
                  ),
                )
              ],
            ),
          )
        ),

        Container(
          padding: EdgeInsets.all(3.0),
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                child: Chip(
                  label: Text("music producer"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                child: Chip(
                  label: Text("artist"),
                ),
              )
            ],
          )
        ),
        Divider(),
        Row(
          children: <Widget>[
            Expanded(
              child: IconButton(
                icon: Icon(Icons.my_location),
                onPressed: (){},
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.mail),
                onPressed: (){},
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.share),
                onPressed: (){},
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.chat_bubble),
                onPressed: (){},
              ),
            )
          ],
        ),
        Divider(),
        Container(
          margin: EdgeInsets.all(10.0),
          child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '+ Todo',
                contentPadding: EdgeInsets.all(3.0)
              ),
          )
        ),
        Wrap(
          children: <Widget>[
            Row(
              children: <Widget>[
                Center(
                  child: Checkbox(
                    value: false,
                    onChanged: (value){},
                  )
                ),
                Flexible(
                  child: Text(
                    "Appointment at 20:00 for an in-person interview in Koffee++, DA-IICT"
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Center(
                  child: Checkbox(
                    value: false,
                    onChanged: (value){},
                  )
                ),
                Flexible(
                  child: Text(
                    "Studio Session"
                  ),
                )
              ],
            )
          ],
        )
      ]
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