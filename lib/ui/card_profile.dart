import 'package:flutter/material.dart';
import 'package:bcard/ui/todo_item.dart';

class CardProfilePage extends StatefulWidget {
  @override
  _CardProfilePageState createState() => _CardProfilePageState();
}

class _CardProfilePageState extends State<CardProfilePage> {
  List<String> todoList = [
    "Appointment at 20:00 for an in-person interview in Koffee++, DA-IICT",
    "Studio Session"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
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
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Card(
                        color: Colors.blueGrey[100],
                        child: Container(
                          width: 100,
                          height: 100,
                          child: Center(
                            child: Text("Photo"),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
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
                ),
              ],
            ),
          ),
          Divider(),
          Row(
            children: <Widget>[
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.my_location),
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.mail),
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.chat_bubble),
                  onPressed: () {},
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
                hintText: 'Add a new Todo',
                contentPadding: EdgeInsets.all(3.0),
              ),
            ),
          ),
          Wrap(
              children: todoList
                  .map(
                    (item) => TodoItem(item),
                  )
                  .toList())
        ],
      ),
    );
  }
}
