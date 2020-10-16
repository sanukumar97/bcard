import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class DiscoverFilter extends StatefulWidget {
  List<String> searchTags;
  Function(String) addSearchTag, removeSearchTag;

  DiscoverFilter(
    this.searchTags,
    this.addSearchTag,
    this.removeSearchTag,
  );
  @override
  _DiscoverFilterState createState() => _DiscoverFilterState();
}

class _DiscoverFilterState extends State<DiscoverFilter> {
  TextEditingController _controller = new TextEditingController();
  FocusNode _focusNode = new FocusNode();
  List<String> _recommendedTags = [
    "art",
    "enterpreneur",
    "startup",
    "development"
  ];

  @override
  Widget build(BuildContext context) {
    List<String> _recList =
        _recommendedTags.where((e) => !widget.searchTags.contains(e)).toList();
    return Container(
      color: color4,
      height: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(
                Icons.cancel,
                color: color1,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            title: Text(
              "Meet People",
              style: myTs(color: color1, size: 22, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Customizing your feed allow us to intelligently find people who are present in the same events based on your interest.",
              style: myTs(
                color: color1,
                size: 12,
              ),
            ),
          ),
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: TextFormField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: (s) {
                setState(() {});
              },
              onFieldSubmitted: (value) {
                if (_controller.value.text.isNotEmpty) {
                  widget.addSearchTag(value);
                  _controller.clear();
                  _focusNode.unfocus();
                  setState(() {});
                }
              },
              enabled: widget.searchTags.length < 10,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none),
                fillColor: color5,
                filled: true,
                suffixIcon: _controller.value.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.check,
                          color: color1,
                        ),
                        onPressed: () {
                          widget.addSearchTag(_controller.value.text);
                          _controller.clear();
                          _focusNode.unfocus();
                          setState(() {});
                        },
                      )
                    : null,
                hintText: "Enter Tags....",
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10, left: 10, top: 10),
            height: 60,
            alignment: Alignment.centerLeft,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.searchTags.length,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return Container(
                  height: 50,
                  padding: EdgeInsets.only(bottom: 2, left: 5, top: 2),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: color5,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "#" + widget.searchTags[i],
                        style: myTs(color: color1, size: 15),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        iconSize: 20,
                        onPressed: () {
                          widget.removeSearchTag(widget.searchTags[i]);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            title: Text(
              "Recommended",
              style: myTs(color: color1, size: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: 10, left: 15, top: 10),
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _recList.length,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () {
                    widget.addSearchTag(_recList[i]);
                    setState(() {});
                  },
                  child: Container(
                    height: 50,
                    padding:
                        EdgeInsets.only(bottom: 2, left: 10, top: 2, right: 10),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: color5,
                    ),
                    child: Text(
                      "#" + _recList[i],
                      style: myTs(color: color1, size: 15),
                    ),
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: color5,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Search",
                    style: TextStyle(
                      color: color1,
                      fontSize: 22,
                    ),
                  ),
                  Icon(
                    Icons.search,
                    color: color1,
                    size: 22,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
