import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class MyTextFieldDialog extends StatefulWidget {
  final Function(String, Color) _onEditCompleted;
  final String _initialValue, _hintText;
  final int _maxLength;
  Color color;

  MyTextFieldDialog(this._onEditCompleted, this._initialValue, this._hintText,
      this._maxLength,
      {this.color});

  @override
  _MyTextFieldDialogState createState() => _MyTextFieldDialogState();
}

class _MyTextFieldDialogState extends State<MyTextFieldDialog> {
  TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(text: widget._initialValue);
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: color1,
      content: TextFormField(
        controller: _controller,
        autofocus: true,
        maxLength: widget._maxLength,
        maxLengthEnforced: true,
        style: myTs(color: color5, size: 15),
        decoration: InputDecoration(
          counterText: "",
          hintText: widget._hintText,
          hintStyle: myTs(color: color5.withOpacity(0.5), size: 15),
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: myTs(color: color5, size: 15, fontWeight: FontWeight.bold),
          ),
        ),
        FlatButton(
          onPressed: () {
            showDialog(
              context: context,
              child: AlertDialog(
                title: const Text('Pick a color!'),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: widget.color,
                    onColorChanged: (Color c) {
                      setState(() {
                        widget.color = c;
                      });
                    },
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
          child: Text(
            "Change color",
            style: myTs(color: color5, size: 15, fontWeight: FontWeight.bold),
          ),
        ),
        FlatButton(
          onPressed: _controller.value.text.isEmpty
              ? null
              : () {
                  String s = _controller.value.text;
                  if (s.isNotEmpty) {
                    widget._onEditCompleted(s, widget.color);
                    Navigator.pop(context);
                  }
                },
          child: Text(
            "Save",
            style: myTs(color: color5, size: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
