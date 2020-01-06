import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Todo extends StatefulWidget {
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
          child: Column(children: <Widget>[
            Row(children: <Widget>[CurrentTodoCard()]),
            Row(children: <Widget>[AllTodoCards()]),
          ]))
    ]);
  }
}

/*class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: <Widget>[TodoCard()],
    );
  }
}*/

class CurrentTodoCard extends StatefulWidget {
  @override
  _CurrentTodoCardState createState() => _CurrentTodoCardState();
}

class _CurrentTodoCardState extends State<CurrentTodoCard> {
  bool isDone = true;

  @override
  void initState() {
    isDone = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Card(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: getCurrentTodo(),
      )),
      Divider(),
    ]);
  }

  Column getCurrentTodo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Sanket Chaudhari",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  Text("DJ, Music Producer",
                      style: TextStyle(color: Colors.grey))
                ],
              ),
              Flexible(
                child: Center(),
              ),
              Container(
                child: Checkbox(
                  value: isDone,
                  onChanged: (bool value) {
                    setState(() {
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
              )),
        )
      ],
    );
  }
}

class AllTodoCards extends StatefulWidget {
  @override
  _AllTodoCardState createState() => _AllTodoCardState();
}

class _AllTodoCardState extends State<AllTodoCards> {
  bool isDone = true;
  bool isDone2 = true;

  //TODO: Two horizontal list view inside a page view
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      child: PageView.builder(itemBuilder: (context, index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Date $index"),
                Expanded(child: ListView.builder(
                  itemBuilder: (context, position) {
                    return getTodo1();
                  },
                  scrollDirection: Axis.horizontal,
                ))
              ],
            ),
            Row(
              children: <Widget>[
                Text("Date $index"),
                Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, position2) {
                        return getTodo2();
                      },
                      scrollDirection: Axis.horizontal,
                    ))
              ],
            )
          ],
        );
      }),
    ));
  }

  Column getTodo1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Sanket Chaudhari",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  Text("DJ, Music Producer",
                      style: TextStyle(color: Colors.grey))
                ],
              ),
              Flexible(
                child: Center(),
              ),
              Container(
                child: Checkbox(
                  value: isDone,
                  onChanged: (bool value) {
                    setState(() {
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
              )),
        )
      ],
    );
  }

  Column getTodo2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Sanket Chaudhari",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  Text("DJ, Music Producer",
                      style: TextStyle(color: Colors.grey))
                ],
              ),
              Flexible(
                child: Center(),
              ),
              Container(
                child: Checkbox(
                  value: isDone2,
                  onChanged: (bool value) {
                    setState(() {
                      isDone2 = !isDone2;
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
              )),
        )
      ],
    );
  }
}
