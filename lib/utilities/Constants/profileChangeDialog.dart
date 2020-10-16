import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileChangeDialog extends StatefulWidget {
  List<String> data;
  bool editable;
  Function(String) action;
  Function(List<String>) save;
  String Function(String) validator;
  String iconPath;
  Widget icon;
  int maxSize, maxLength;
  int editIndex;
  String hintText;
  TextInputType keyboardType;
  String noDataPresent;

  ProfileChangeDialog({
    @required this.data,
    this.editable = true,
    this.action,
    @required this.save,
    @required this.validator,
    @required this.iconPath,
    this.icon,
    @required this.maxSize,
    @required this.maxLength,
    this.editIndex,
    @required this.hintText,
    @required this.keyboardType,
    @required this.noDataPresent,
  });

  @override
  _ProfileChangeDialogState createState() => _ProfileChangeDialogState();
}

class _ProfileChangeDialogState extends State<ProfileChangeDialog> {
  List<TextEditingController> _controllers;
  List<FocusNode> _nodes;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.editable) {
      _controllers = new List.generate(widget.data.length,
          (i) => TextEditingController(text: widget.data[i]));
      _nodes =
          new List<FocusNode>.generate(widget.data.length, (i) => FocusNode());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      contentPadding: EdgeInsets.only(top: 15, left: 15, right: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: color1.withOpacity(1),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            widget.editable ? "Cancel" : "Done",
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
            child: widget.editable == false && widget.data.isEmpty
                ? Text(
                    widget.noDataPresent,
                    style: myTs(color: color5.withOpacity(0.5), size: 14),
                  )
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.editable
                        ? _controllers.length
                        : widget.data.length,
                    itemBuilder: (context, i) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
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
                                        onTap: () {
                                          setState(() {
                                            _nodes[i].requestFocus();
                                          });
                                        },
                                        onChanged: (s) {
                                          setState(() {});
                                        },
                                        validator: widget.validator,
                                        maxLines: 1,
                                        maxLength: widget.maxLength,
                                        maxLengthEnforced: true,
                                        keyboardType: widget.keyboardType,
                                        style: myTs(color: color5, size: 18),
                                        decoration: InputDecoration(
                                          counterText: "",
                                          hintText: widget.hintText,
                                          hintStyle: myTs(
                                              color: color5.withOpacity(0.5),
                                              size: 15),
                                          border: InputBorder.none,
                                        ),
                                      )
                                    : Text(
                                        widget.data[i],
                                        style: myTs(color: color5, size: 18),
                                      ),
                              ),
                            ),
                            SizedBox(width: 10),
                            widget.editable == false
                                ? GestureDetector(
                                    onTap: () {
                                      widget.action(widget.data[i]);
                                    },
                                    child: widget.icon ??
                                        SvgPicture.asset(
                                          widget.iconPath,
                                          height: 50,
                                          width: 50,
                                        ),
                                  )
                                : _nodes[i].hasFocus
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _controllers.removeAt(i);
                                            _nodes.removeAt(i);
                                          });
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          child: Icon(
                                            Icons.close,
                                            color: color5,
                                            size: 25,
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _nodes[i].requestFocus();
                                          });
                                        },
                                        child: widget.icon ??
                                            SvgPicture.asset(
                                              widget.iconPath,
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
          widget.editable == false
              ? SizedBox()
              : _controllers.length >= widget.maxSize
                  ? SizedBox()
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          _controllers.add(new TextEditingController(text: ""));
                          _nodes.add(FocusNode());
                          _nodes.last.requestFocus();
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: color5,
                              size: 30,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: color1,
                              ),
                              child: Text(
                                widget.hintText,
                                style: myTs(color: color5, size: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}
