import 'dart:async';
import 'package:bcard/screens/DiscoverTab/discoverFilter.dart';
import 'package:bcard/screens/DiscoverTab/liveFilter.dart';
import 'package:bcard/screens/DiscoverTab/profileOptions.dart';
import 'package:bcard/screens/ProfileTab/settings.dart';
import 'package:bcard/utilities/Classes/liveEventClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/threeDots.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bcard/screens/CardDesigns/verticalCardDesign.dart';
import 'package:bcard/screens/CardDesigns/horizantalCardDesign.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bcard/screens/DiscoverTab/profileDetails.dart';

class DiscoverPage extends StatefulWidget {
  bool goBack() {
    return __discoverPageState.goBack();
  }

  void reload() {
    __discoverPageState._reload();
  }

  _DiscoverPageState __discoverPageState = new _DiscoverPageState();
  @override
  _DiscoverPageState createState() => __discoverPageState;
}

class _DiscoverPageState extends State<DiscoverPage> {
  int _currentIndex = 0;
  List<String> _liveSearchTags = List.from(AppConfig.liveTagList);
  String _myLiveTag = AppConfig.myLiveTag;
  bool _amILive = AppConfig.amILive;
  LatLng _currentLocation;
  LiveEvent _myLiveEvent;
  List<LiveEvent> _liveEvents = [];
  bool _showLiveProfile = false, _loadingLiveProfile = false;
  Profile _currentLiveProfileShown;
  List<Profile> _liveProfiles = [];

  List<String> _searchTags = List.from(AppConfig.discoverTagList);
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Profile> _currentProfiles = [];
  bool _loading = false;
  bool _filterOpen;
  bool _showProfile = false;
  Profile _currentProfileShown;

  bool goBack() {
    if (_currentIndex == 0) {
      if (_showProfile) {
        setState(() {
          _showProfile = false;
          _currentProfileShown = null;
        });
        return false;
      } else {
        return true;
      }
    } else {
      if (_showLiveProfile) {
        setState(() {
          _showLiveProfile = false;
          _currentLiveProfileShown = null;
        });
        return false;
      } else {
        return true;
      }
    }
  }

  void _reload() {
    setState(() {});
  }

  void _addSearchTag(String s) {
    setState(() {
      _searchTags.add(s);
    });
  }

  void _addLiveSearchTag(String s) {
    setState(() {
      _liveSearchTags.add(s);
    });
  }

  void _removeSearchTag(String s) {
    setState(() {
      _searchTags.remove(s);
    });
  }

  void _removeLiveSearchTag(String s) {
    setState(() {
      _liveSearchTags.remove(s);
    });
  }

  void setAmILive(bool val) {
    _amILive = val;
    AppConfig.amILive = val;
  }

  void _setLiveTag(String tag) {
    _myLiveTag = tag;
    AppConfig.myLiveTag = tag;
  }

  void _setCurrentLocation(LatLng latLng) {
    _currentLocation = latLng;
  }

  void showDiscoverFilterSheet() async {
    List<String> _currList = new List.from(_searchTags);
    /* var cont = _scaffoldKey.currentState.showBottomSheet(
      (context) => DiscoverFilter(_searchTags, _addSearchTag, _removeSearchTag),
    ); */
    setState(() {
      _filterOpen = true;
    });
    await showModalBottomSheet(
      context: context,
      builder: (context) =>
          DiscoverFilter(_searchTags, _addSearchTag, _removeSearchTag),
      isScrollControlled: true,
    );
    //await cont.closed;
    setState(() {
      _filterOpen = false;
    });
    if (!listEqual(_currList, _searchTags)) {
      AppConfig.saveDiscoverTagList(_searchTags);
      _searchProfiles();
    }
  }

  void showLiveFilterSheet() async {
    List<String> _currList = new List.from(_liveSearchTags);
    bool _currentLiveStatus = (_amILive == true);
    setState(() {
      _filterOpen = true;
    });
    await showModalBottomSheet(
      context: context,
      builder: (context) => LiveFilter(
          _liveSearchTags,
          _amILive,
          _myLiveTag,
          _addLiveSearchTag,
          _removeLiveSearchTag,
          _setLiveTag,
          _setCurrentLocation,
          setAmILive),
      isScrollControlled: true,
    );
    setState(() {
      _filterOpen = false;
    });
    if (_amILive && _myLiveTag.isEmpty) {
      _amILive = false;
    }

    if (_currentLiveStatus != _amILive) {
      if (_amILive && _myLiveTag.isNotEmpty) {
        _myLiveEvent = new LiveEvent(
            AppConfig.currentProfile.id, _myLiveTag, _currentLocation);
        _myLiveEvent.ref = await FirebaseFunctions.setLiveEvent(_myLiveEvent);
      } else if (_myLiveEvent != null) {
        setState(() {
          _liveEvents
              .removeWhere((le) => le.profileId == _myLiveEvent.profileId);
        });
        _myLiveEvent.ref.delete();
        _myLiveEvent = null;
      }
    }
    if (!listEqual(_currList, _liveSearchTags)) {
      AppConfig.saveLiveTagList(_liveSearchTags);
      _searchLiveProfiles();
    } else if (_myLiveEvent != null) {
      setState(() {
        _liveEvents.add(_myLiveEvent);
      });
    }
  }

  Future<void> _searchProfiles() async {
    _currentProfiles.clear();
    setState(() {
      _loading = true;
    });
    List<String> _tags = new List<String>.from(_searchTags);
    if (_tags.isEmpty) {
      _tags.add("admin");
    }
    if (_tags.isNotEmpty) {
      for (int i = 0; i < 4; i++) {
        List<DocumentSnapshot> docs =
            await FirebaseFunctions.discoverProfiles(_tags, i);
        if (docs.length > 0) {
          docs.forEach((e) {
            if (!AppConfig.me.cardLibraries[3].profileIds.contains(e["id"]) &&
                !_currentProfiles.any((prf) => prf.id == e['id'].toString()))
              _currentProfiles.add(new Profile.fromJson(e.data));
          });
          setState(() {
            _loading = false;
          });
        }
      }
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _searchLiveProfiles() async {
    List<String> tags = new List.from(_liveSearchTags);
    setState(() {
      _liveEvents.clear();
    });
    if (_amILive &&
        (_myLiveTag?.isNotEmpty ?? false) &&
        _myLiveEvent == null &&
        !tags.contains(_myLiveTag)) {
      tags.add(_myLiveTag);
    } else if (_myLiveEvent != null) {
      _liveEvents.add(_myLiveEvent);
    }

    if (tags.isNotEmpty) {
      List<DocumentSnapshot> list = await FirebaseFunctions.getLiveEvents(tags);
      setState(() {
        list.forEach((doc) {
          _liveEvents.add(new LiveEvent.fromJson(doc));
        });
      });
    }
  }

  void _showProfileDetails(Profile profile) {
    setState(() {
      _currentProfileShown = profile;
      _showProfile = true;
    });
  }

  void _showLiveProfileDetails(String profileId) async {
    int index = _liveProfiles.indexWhere((lp) => lp.id == profileId);
    if (index >= 0) {
      setState(() {
        _currentLiveProfileShown = _liveProfiles[index];
        _showLiveProfile = true;
      });
    } else {
      setState(() {
        _loadingLiveProfile = true;
      });
      _currentLiveProfileShown = await FirebaseFunctions.getProfile(profileId);
      setState(() {
        _loadingLiveProfile = false;
        _showLiveProfile = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _filterOpen = false;
    _searchProfiles();
    if (_liveSearchTags.isNotEmpty ||
        (_myLiveTag != null && _myLiveTag.isNotEmpty)) _searchLiveProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: color2,
      drawer: SettingsDrawer(),
      extendBodyBehindAppBar: _filterOpen,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: (_currentIndex == 0 && _showProfile) ||
                (_currentIndex == 1 && _showLiveProfile)
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: color5,
                ),
                onPressed: goBack,
              )
            : GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState.openDrawer();
                },
                child: Container(
                  padding: EdgeInsets.all(10.5),
                  child: SvgPicture.asset(
                    "assets/images/Logo.svg",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
        backgroundColor: color1,
        elevation: 0.0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Container(
                  height: 35,
                  width: 35,
                  child: SvgPicture.asset(
                    "assets/icons/chat.svg",
                    fit: BoxFit.contain,
                  ),
                ),
                onPressed: () {
                  openChat();
                },
              ),
              newMessage
                  ? Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: color4,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    margin: EdgeInsets.symmetric(horizontal: 1, vertical: 2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: color1,
                    ),
                    child: Text(
                      "Meet People",
                      style: myTs(
                        color: _currentIndex == 0 ? color4 : color5,
                        size: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    margin: EdgeInsets.symmetric(horizontal: 1, vertical: 2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: color1,
                    ),
                    child: Text(
                      "Live Event",
                      style: myTs(
                        color: _currentIndex == 1 ? color4 : color5,
                        size: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [_discoverBody, _liveBody],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _liveBody {
    var size = MediaQuery.of(context).size;
    if (_showLiveProfile) {
      if (_loadingLiveProfile)
        return Center(
          child: CircularProgressIndicator(),
        );
      else
        return DiscoverProfileCardDetails(_currentLiveProfileShown);
    }
    return RefreshIndicator(
      onRefresh: () async {},
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.5, horizontal: 15),
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width: 10),
                itemCount: _liveSearchTags.length +
                    (_liveSearchTags.length < 10 ? 1 : 0),
                itemBuilder: (context, index) {
                  int i = _liveSearchTags.length < 10 ? index - 1 : index;
                  if (i == -1) {
                    return GestureDetector(
                      onTap: showLiveFilterSheet,
                      child: Container(
                        width: size.width * 0.12,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: color4,
                        ),
                        child: Icon(
                          Icons.add,
                          size: 22,
                          color: color1,
                        ),
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: color3,
                        ),
                        child: Text(
                          "#" + _liveSearchTags[i],
                          style: myTs(color: color5, size: 13),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Stack(
              children: [
                LiveMap(_liveEvents, _showLiveProfileDetails),
                Positioned(
                  top: 3,
                  left: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey.withOpacity(0.8),
                    ),
                    child: Text("Active Profile: ${_liveEvents.length}"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get _discoverBody {
    var size = MediaQuery.of(context).size;
    if (!_showProfile) {
      return RefreshIndicator(
        onRefresh: () async {
          _currentProfiles.clear();
          await AppConfig.synchroniseChangesFromServer();
          _searchProfiles();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12.5, horizontal: 15),
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                  itemCount:
                      _searchTags.length + (_searchTags.length < 10 ? 1 : 0),
                  itemBuilder: (context, index) {
                    int i = _searchTags.length < 10 ? index - 1 : index;
                    if (i == -1) {
                      return GestureDetector(
                        onTap: showDiscoverFilterSheet,
                        child: Container(
                          width: size.width * 0.12,
                          //padding: EdgeInsets.all(5),
                          //margin: EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: color4,
                          ),
                          child: Icon(
                            Icons.add,
                            size: 22,
                            color: color1,
                          ),
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: color3,
                          ),
                          child: Text(
                            "#" + _searchTags[i],
                            style: myTs(color: color5, size: 13),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              _loading
                  ? Center(
                      child: Text(
                        "Loading....",
                        style: myTs(color: color5, size: 18),
                      ),
                    )
                  : _currentProfiles.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _currentProfiles.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10),
                          itemBuilder: (context, i) => GestureDetector(
                            onTap: () {
                              _showProfileDetails(_currentProfiles[i]);
                              AppConfig.me.cardLibraries[0]
                                  .addProfile(_currentProfiles[i].id);
                              FirebaseFunctions.visitProfile(
                                  _currentProfiles[i].id);
                            },
                            child: DiscoverProfileCard(_currentProfiles[i]),
                          ),
                        )
                      : Center(
                          child: Text(
                            "No Profiles Found!!!",
                            style: myTs(color: color5, size: 18),
                          ),
                        ),
            ],
          ),
        ),
      );
    } else {
      return DiscoverProfileCardDetails(_currentProfileShown);
    }
  }
}

class DiscoverProfileCard extends StatelessWidget {
  final Profile _profile;
  DiscoverProfileCard(this._profile);

  Widget _card(Size size) {
    if (_profile.cardStructure == CardStructure.horizantal)
      return HorizantalCard(_profile, false, () {}, (s) {},
          isMine: false, cardWidth: size.width - 20);
    else
      return VerticalCard(_profile, false, () {}, (s) {},
          isMine: false, cardHeight: (size.width - 20) * 11 / 7);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _card(size),
          SizedBox(height: 5),
          Container(
            height: 20,
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _profile.tags.length,
                    separatorBuilder: (context, index) => SizedBox(width: 10),
                    itemBuilder: (context, i) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        //margin: EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: color3,
                        ),
                        child: Text(
                          "#" + _profile.tags[i],
                          style: myTs(color: color5, size: 13),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          DiscoverProfileSearchOptions(_profile),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: color3,
                    ),
                    child: threedots(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
