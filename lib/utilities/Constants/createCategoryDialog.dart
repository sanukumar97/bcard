import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';

class CreateCategoryDialog extends StatefulWidget {
  final Function(String) addCategory;
  CreateCategoryDialog(this.addCategory);
  @override
  _CreateCategoryDialogState createState() => _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends State<CreateCategoryDialog> {
  TextEditingController _controller = new TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: color1,
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          onChanged: (s) {
            setState(() {});
          },
          validator: (s) {
            if (AppConfig.me.cardLibraries.any((lib) => lib.name == s))
              return "There is already a folder named \'$s\'";
            else
              return null;
          },
          maxLength: 10,
          maxLengthEnforced: true,
          style: myTs(color: color5, size: 15),
          decoration: InputDecoration(
            counterText: "",
            hintText: "Enter name of category",
            hintStyle: myTs(color: color5.withOpacity(0.5), size: 15),
          ),
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
          onPressed: _controller.value.text.isEmpty
              ? null
              : () {
                  if (_formKey.currentState.validate()) {
                    widget.addCategory(_controller.value.text);
                    Navigator.pop(context);
                  }
                },
          child: Text(
            "Save",
            style: myTs(
                color: _controller.value.text.isEmpty
                    ? color5.withOpacity(0.5)
                    : color5,
                size: 15,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
