import 'package:flutter/material.dart';

class Todo extends StatefulWidget {
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        TodoCard(),
      ]
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        TodoCard()
      ],
    );
  }
}

class TodoCard extends StatefulWidget {
  @override
  _TodoCardState createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {

  bool isDone = true;

  @override
  void initState() {
    isDone = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Sanket Chaudhari",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Text(
                        "DJ, Music Producer",
                        style: TextStyle(
                          color: Colors.grey
                        )
                      )
                    ],
                  ),
                  Flexible(
                    child: Center(),
                  ),
                  Container(
                    child: Checkbox(
                      value: isDone,
                      onChanged: (bool value){
                        setState((){
                          isDone = !isDone;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            Wrap(
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Appointment at 20:00 for an in-person interview in Koffee++, DA-IICT",
                style: TextStyle(
                  height: 1.5,
                )
              ),
            )
          ],
        ),
      )
    );
  }
}