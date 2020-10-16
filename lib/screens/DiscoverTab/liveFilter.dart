import 'dart:async';
import 'package:bcard/utilities/Classes/liveEventClass.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:bcard/utilities/location.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';


class LiveFilter extends StatefulWidget {
  List<String> searchTags;
  Function(String) addSearchTag, removeSearchTag, setMyLiveTag;
  Function(LatLng) setCurrentLocation;
  bool amILive;
  String myLiveTag;
  Function(bool) setAmILive;

  LiveFilter(
    this.searchTags,
    this.amILive,
    this.myLiveTag,
    this.addSearchTag,
    this.removeSearchTag,
    this.setMyLiveTag,
    this.setCurrentLocation,
    this.setAmILive,
  );
  @override
  _LiveFilterState createState() => _LiveFilterState();
}

class _LiveFilterState extends State<LiveFilter> {
  TextEditingController _controller = new TextEditingController(), _controller2;
  FocusNode _focusNode = new FocusNode(), _focusNode2 = new FocusNode();
  LatLng _currentLoc;
  bool _amILive;

  void _setAmIAlive(bool val) async {
    if (val) {
      _currentLoc = await AppLocation.currentLocation;
      if (_currentLoc != null) {
        widget.setCurrentLocation(_currentLoc);
        widget.setAmILive(val);
        setState(() {
          _amILive = val;
        });
      } else {
        appToast("Failed to get your current Location", context);
      }
    } else {
      widget.setCurrentLocation(null);
      widget.setAmILive(val);
      setState(() {
        _amILive = val;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _amILive = widget.amILive;
    _controller2 = new TextEditingController(text: widget.myLiveTag);
  }

  @override
  Widget build(BuildContext context) {
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
              "Live Event",
              style: myTs(color: color1, size: 22, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Add event name as #tag keyword, so that your profile will be visible on the live event map of others profile for better reach.",
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
              enabled: widget.searchTags.length < 9,
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
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    "Represent your live location in an event:",
                    style: myTs(
                        color: color1, size: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Switch(
                  value: _amILive,
                  onChanged: (val) {
                    _setAmIAlive(val);
                  },
                  activeColor: color3,
                  inactiveThumbColor: Colors.grey,
                  activeTrackColor: color5,
                  inactiveTrackColor: color5,
                ),
              ],
            ),
            subtitle: Text(
              "Customizing your #tag keywords allow us to intelligently find people based on your intrest.",
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
              controller: _controller2,
              focusNode: _focusNode2,
              onChanged: (s) {
                setState(() {});
              },
              onFieldSubmitted: (value) {
                if (_controller.value.text.isNotEmpty) {
                  widget.setMyLiveTag(_controller2.value.text);
                  _controller2.clear();
                  _focusNode2.unfocus();
                  setState(() {});
                }
              },
              enabled: _amILive,
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
                focusedErrorBorder: InputBorder.none,
                fillColor: color5,
                filled: true,
                suffixIcon: _controller.value.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.check,
                          color: color1,
                        ),
                        onPressed: () {
                          widget.setMyLiveTag(_controller2.value.text);
                          _controller.clear();
                          _focusNode.unfocus();
                          setState(() {});
                        },
                      )
                    : null,
                hintText: "Enter Event Name",
                hintStyle: myTs(
                  color: _amILive ? color1 : Colors.grey.withOpacity(0.5),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_amILive && _controller2.value.text.isEmpty) {
                appToast("Add a name to your live event", context);
              } else {
                widget.setMyLiveTag(_controller2.value.text);
                Navigator.pop(context);
              }
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
                    "Done",
                    style: TextStyle(
                      color: color1,
                      fontSize: 22,
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

class LiveMap extends StatefulWidget {
  List<LiveEvent> liveEvents;
  Function(String) _showLiveProfileDetails;
  LiveMap(this.liveEvents, this._showLiveProfileDetails);
  @override
  _LiveMapState createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
  Completer<GoogleMapController> _controller =
      new Completer<GoogleMapController>();
  CameraPosition _initialPosition;
  bool _loaded = false;
  Set<Marker> _markers = new Set<Marker>();

  void _getInitialPosition() async {
    LatLng _currentLoc =
        await AppLocation.currentLocation ?? LatLng(28.6448, 77.216721);
    _initialPosition = new CameraPosition(target: (_currentLoc), zoom: 4);
    setState(() {
      _loaded = true;
    });
  }

  void _onTapEvent(LiveEvent event) {
    widget._showLiveProfileDetails(event.profileId);
  }

  void _setMarkers() {
    widget.liveEvents.forEach((le) {
      bool _isMine = [AppConfig.me.businessDocId, AppConfig.me.personalDocId]
          .contains(le.profileId);
      _markers.add(
        new Marker(
          markerId: MarkerId(
            le.profileId,
          ),
          position: le.location,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              _isMine ? BitmapDescriptor.hueAzure : BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: le.liveTag,
            onTap: () {
              _onTapEvent(le);
            },
          ),
        ),
      );
    });
    setState(() {});
  }

  @override
  void didUpdateWidget(LiveMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setMarkers();
  }

  @override
  void initState() {
    super.initState();
    _getInitialPosition();
    _setMarkers();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.6,
      width: size.width,
      child: _loaded
          ? GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                new Factory<OneSequenceGestureRecognizer>(
                  () => new EagerGestureRecognizer(),
                ),
              ].toSet(),
            )
          : Shimmer.fromColors(
              child: Container(
                decoration: BoxDecoration(
                  color: color5,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: size.width * 0.7,
                width: size.width * 0.7,
              ),
              baseColor: color5.withOpacity(0.6),
              highlightColor: color5.withOpacity(0.2),
            ),
    );
  }
}
