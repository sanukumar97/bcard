import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialMediaChangeDialog extends StatefulWidget {
  List<String> data;
  Function(List<String>) save;
  bool editable;
  Function(String) action;
  String Function(String) validator;
  List<String> iconPaths;
  int maxLength;
  List<String> hintTexts;
  TextInputType keyboardType;

  SocialMediaChangeDialog(
      {@required this.data,
      this.editable = true,
      this.action,
      @required this.save,
      @required this.validator,
      @required this.iconPaths,
      @required this.maxLength,
      @required this.hintTexts,
      @required this.keyboardType,
      bool isSocialMedia});

  @override
  _SocialMediaChangeDialogState createState() =>
      _SocialMediaChangeDialogState();
}

class _SocialMediaChangeDialogState extends State<SocialMediaChangeDialog> {
  List<TextEditingController> _controllers;
  List<FocusNode> _nodes;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.editable) {
      _controllers = new List.generate(
        widget.data.length,
        (i) => TextEditingController(text: widget.data[i]),
      );
      _nodes = new List.generate(
        widget.data.length,
        (i) => FocusNode(),
      );
      while (_controllers.length < 5) {
        _controllers.add(TextEditingController(text: null));
        _nodes.add(FocusNode());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      contentPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: color1,
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: myTs(color: color5, size: 18),
          ),
        ),
        widget.editable
            ? FlatButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    List<String> _data = new List<String>.generate(
                        _controllers.length, (i) => _controllers[i].value.text);
                    widget.save(_data);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Save",
                  style: myTs(color: color5, size: 18),
                ),
              )
            : SizedBox(),
      ],
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:
                  widget.editable ? _controllers.length : widget.data.length,
              itemBuilder: (context, i) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: color1,
                          ),
                          child: widget.editable
                              ? TextFormField(
                                  controller: _controllers[i],
                                  focusNode: _nodes[i],
                                  onChanged: (s) {
                                    setState(() {});
                                  },
                                  validator: widget.validator,
                                  maxLength: widget.maxLength,
                                  maxLengthEnforced: true,
                                  keyboardType: widget.keyboardType,
                                  style: myTs(color: color5, size: 18),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    counterText: "",
                                    hintText: widget.hintTexts[i],
                                    hintStyle: myTs(
                                        color: color5.withOpacity(0.5),
                                        size: 15),
                                    border: InputBorder.none,
                                  ),
                                )
                              : Text(
                                  widget.data[i] != null &&
                                          widget.data[i].isNotEmpty
                                      ? widget.data[i]
                                      : "Not Provided",
                                  style: myTs(
                                      color: color5.withOpacity(
                                          widget.data[i] != null &&
                                                  widget.data[i].isNotEmpty
                                              ? 1
                                              : 0.4),
                                      size: 18),
                                ),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: widget.editable
                            ? () {
                                setState(() {
                                  _nodes[i].requestFocus();
                                });
                              }
                            : () {
                                widget.action(widget.data[i]);
                              },
                        child: SvgPicture.asset(
                          widget.iconPaths[i],
                          height: 50,
                          width: 50,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
