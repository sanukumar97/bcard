import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  final todoItem;

  TodoItem(this.todoItem);
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Center(
          child: Checkbox(
            value: false,
            onChanged: (value){},
          )
        ),
        Flexible(
          child: Text(
            this.todoItem
          ),
        )
      ],
    );
  }
}