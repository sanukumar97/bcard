import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ConversationCard(),
        ConversationCard(),
        ConversationCard(),
        ConversationCard(),
        ConversationCard(),
        ConversationCard(),
        ConversationCard(),
        ConversationCard()
      ],
    );
  }
}

class ConversationCard extends StatefulWidget {
  @override
  _ConversationCardState createState() => _ConversationCardState();
}

class _ConversationCardState extends State<ConversationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.0),
      child: Row(
        children: <Widget>[
          Card(
            child: Container(
              width: 100,
              height: 100,
              child: Center(
                child: Text(
                  "Trust Fund"
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Sanket Chaudhari",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  "Producer, Developer"
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}