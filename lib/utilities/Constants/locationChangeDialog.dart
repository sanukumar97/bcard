import 'package:bcard/utilities/Classes/locationClass.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationChangeDialog extends StatefulWidget {
  List<Location> data;
  bool editable;
  Function(Location) action;
  Function(List<Location>) save;
  String Function(String) validator;
  String iconPath;
  Widget icon;
  int maxSize, maxLength;
  int editIndex;
  String hintText;
  TextInputType keyboardType;
  String noDataPresent;

  LocationChangeDialog({
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
  _LocationChangeDialogState createState() => _LocationChangeDialogState();
}

class _LocationChangeDialogState extends State<LocationChangeDialog> {
  List<TextEditingController> _controllers;
  List<LatLng> _coordinates;
  List<FocusNode> _nodes;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.editable) {
      _controllers = new List<TextEditingController>.generate(
          widget.data.length,
          (i) => TextEditingController(text: widget.data[i].address));
      _coordinates = new List<LatLng>.generate(
          widget.data.length, (i) => widget.data[i].coordinates);
      _nodes =
          new List<FocusNode>.generate(widget.data.length, (i) => FocusNode());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      contentPadding: EdgeInsets.only(top: 25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: color1.withOpacity(1),
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
                    List<Location> _data = new List<Location>.generate(
                      _controllers.length,
                      (i) =>
                          Location(_coordinates[i], _controllers[i].value.text),
                    );
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
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                                        maxLines: 3,
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
                                    : Container(
                                        child: Text(
                                          widget.data[i].address,
                                          style: myTs(color: color5, size: 18),
                                        ),
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
                      onTap: () async {
                        LatLng _currLoc = await AppLocation.currentLocation;
                        setState(() {
                          _controllers.add(new TextEditingController(text: ""));
                          _coordinates.add(_currLoc);
                          _nodes.add(FocusNode());
                          _nodes.last.requestFocus();
                        });
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: color5,
                              size: 30,
                            ),
                            Container(
                              height: 40,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(10),
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
