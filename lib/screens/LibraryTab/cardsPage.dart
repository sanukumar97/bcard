import 'package:bcard/screens/LibraryTab/addProfileToLibrary.dart';
import 'package:bcard/screens/NotificationTab/notificationPage.dart';
import 'package:bcard/screens/ProfileTab/settings.dart';
import 'package:bcard/utilities/Classes/NotificationClasses/notificationClass.dart';
import 'package:bcard/utilities/Classes/libraryClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/createCategoryDialog.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:flutter/material.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bcard/screens/DiscoverTab/profileDetails.dart';
import 'package:bcard/screens/LibraryTab/filterBottomSheet.dart';
import 'package:bcard/screens/LibraryTab/libraryFolder.dart';
import 'package:bcard/screens/LibraryTab/libraryProfile.dart';

class CardPage extends StatefulWidget {
  void reload() {
    _cardPageState._reload();
  }

  void openProfile(String profileId) {
    _cardPageState._openProfile(profileId);
  }

  final String initialProfileId;

  CardPage({this.initialProfileId});

  final _CardPageState _cardPageState = new _CardPageState();
  @override
  _CardPageState createState() => _cardPageState;

  bool goBack() {
    return _cardPageState.goBack();
  }
}

class _CardPageState extends State<CardPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _controller = new TextEditingController();
  FocusNode _focusNode = new FocusNode();
  bool _showMyLibraries = false, _showMyCustomLibraries = false;
  Map<String, List<Profile>> _libraries = {};
  Library _currentLibrary;
  List<Profile> _currentProfiles = [], _currentQueryProfiles = [];
  Map<String, DateTime> _profileAddedTime = {};
  List<Library> _customLibraries = [], _customQueryLibraries = [];
  Set<String> _selectedLibraries = new Set<String>(),
      _selectedProfiles = new Set<String>();
  bool _loading = false;
  bool _showProfile = false;
  Profile _currentShownProfile;

  bool goBack() {
    if (_showProfile) {
      setState(() {
        _showProfile = false;
        _currentShownProfile = null;
      });
      return false;
    } else if (_showMyCustomLibraries) {
      setState(() {
        _showMyCustomLibraries = false;
        _query("");
        _controller.clear();
        _focusNode.unfocus();
      });
      return false;
    } else {
      return true;
    }
  }

  void _reload() {
    setState(() {});
  }

  void _getProfiles(Library library) async {
    if (_libraries.containsKey(library.name)) {
      setState(() {
        _currentLibrary = library;
        _currentProfiles = new List.from(_libraries[library.name]);
        _currentQueryProfiles = _currentProfiles;
      });
    } else {
      setState(() {
        _loading = true;
      });
      _currentProfiles = [];
      List<String> _tempList = [];
      for (int i = 0; i < library.profileIds.length; i++) {
        String id = library.profileIds[i];
        _profileAddedTime.addAll({id: library.additionTime[i]});
        _tempList.add(id);
        if (_tempList.length == 10) {
          _currentProfiles
              .addAll(await FirebaseFunctions.getProfiles(_tempList));
          setState(() {});
          _tempList.clear();
        }
      }
      if (_tempList.isNotEmpty) {
        _currentProfiles.addAll(await FirebaseFunctions.getProfiles(_tempList));
      }
      _currentProfiles.sort((p1, p2) {
        int i1 = library.profileIds.indexWhere((p) => p == p1.id),
            i2 = library.profileIds.indexWhere((p) => p == p2.id);
        if (i1 >= 0 && i2 >= 0) {
          print(
              "${p1.companyName}  ${library.additionTime[i1]}  ${p2.companyName}  ${library.additionTime[i2]}");
          return -1 *
              library.additionTime[i1].compareTo(library.additionTime[i2]);
        } else
          return 0;
      });
      setState(() {
        _loading = false;
        _currentQueryProfiles = _currentProfiles;
      });
      //_libraries.addAll({library.name: _currentProfiles});
      _libraries[library.name] = _currentProfiles;
    }
  }

  void _showFilter() async {
    void _libraryTypeChoosen(LibraryType libraryType) {
      _controller.clear();
      if (libraryType == LibraryType.other) {
        setState(() {
          _showMyLibraries = true;
          _showMyCustomLibraries = false;
          _customQueryLibraries = new List.from(_customLibraries);
        });
      } else {
        _showMyLibraries = false;
        _showMyCustomLibraries = false;
        _currentLibrary = AppConfig.me.cardLibraries
            .firstWhere((lib) => lib.libraryType == libraryType);
        _getProfiles(_currentLibrary);
      }
    }

    if (!FocusScope.of(context).hasPrimaryFocus &&
        FocusScope.of(context).focusedChild != null) {
      print("Has Focus");
      FocusManager.instance.primaryFocus.unfocus();
    }
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => LibraryFilterBottomSheet(
          _showMyLibraries ? LibraryType.other : _currentLibrary.libraryType,
          _libraryTypeChoosen),
    );
    if (!FocusScope.of(context).hasPrimaryFocus)
      FocusScope.of(context).unfocus();
  }

  void refresh() {
    _query("");
    _controller.clear();
    _focusNode.unfocus();
    if (_showMyLibraries && !_showMyCustomLibraries) {
      setState(() {
        _customLibraries = AppConfig.me.cardLibraries
            .where((lib) => lib.libraryType == LibraryType.other)
            .toList();
        _customQueryLibraries = _customLibraries;
      });
    } else {
      _libraries.remove(_currentLibrary.name);
      _getProfiles(_currentLibrary);
    }
  }

  void _query(String query) {
    if (_showMyLibraries && !_showMyCustomLibraries) {
      _customQueryLibraries = _customLibraries
          .where((lib) => lib.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      _currentQueryProfiles = _currentProfiles.where(
        (pf) {
          return (pf.companyName ?? "")
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (pf.occupation ?? "").toLowerCase().contains(query.toLowerCase());
        },
      ).toList();
    }
    setState(() {});
  }

  void _deleteLibraries() async {
    setState(() {
      _customLibraries
          .removeWhere((lib) => _selectedLibraries.contains(lib.name));
      _customQueryLibraries
          .removeWhere((lib) => _selectedLibraries.contains(lib.name));
    });
    await AppConfig.deleteLibraries(_selectedLibraries.toList());
    _selectedLibraries.clear();
  }

  void _deleteProfiles() async {
    setState(() {
      _currentProfiles.removeWhere((prf) => _selectedProfiles.contains(prf.id));
      _currentQueryProfiles
          .removeWhere((prf) => _selectedProfiles.contains(prf.id));
    });
    await AppConfig.deleteProfilesFromLibrary(
        _selectedProfiles.toList(), _currentLibrary);
    _selectedProfiles.clear();
  }

  void _onTap(String profileId) {
    if (_selectedProfiles.isNotEmpty) {
      setState(() {
        if (_selectedProfiles.contains(profileId))
          _selectedProfiles.remove(profileId);
        else
          _selectedProfiles.add(profileId);
      });
    } else {
      setState(() {
        _showProfile = true;
        _currentShownProfile =
            _currentQueryProfiles.firstWhere((prf) => prf.id == profileId);
      });
    }
  }

  void _onLongPress(String profileId) {
    if (_selectedProfiles.isEmpty)
      setState(() {
        _selectedProfiles.add(profileId);
      });
  }

  void _openProfile(String profileId) async {
    Profile profile;
    _libraries.forEach((key, profiles) {
      int index = profiles.indexWhere((pf) => pf.id == profileId);
      if (index >= 0 && profiles[index].id == profileId) {
        profile = profiles[index];
      }
    });
    if (profile == null) {
      profile = await FirebaseFunctions.getProfile(profileId);
    }
    if (profile != null) {
      AppConfig.me.cardLibraries[0].addProfile(profileId);
      if (_libraries.containsKey(AppConfig.me.cardLibraries[0].name) &&
          !_libraries[AppConfig.me.cardLibraries[0].name]
              .any((pf) => pf.id == profile.id)) {
        _profileAddedTime.addAll({profile.id: DateTime.now()});
        _libraries[AppConfig.me.cardLibraries[0].name].add(profile);
      }
      setState(() {
        _showProfile = true;
        _currentShownProfile = profile;
      });
    }
  }

  void _addProfileToLibrary() {
    void _profileAdded(Profile profile) {
      if (!_currentQueryProfiles.any((pf) => pf.id == profile.id)) {
        setState(() {
          _currentQueryProfiles.add(profile);
        });
      }
    }

    void _profileRemoved(Profile profile) {
      int index = _currentQueryProfiles.indexWhere((pf) => pf.id == profile.id);
      if (index >= 0) {
        setState(() {
          _currentQueryProfiles.removeAt(index);
        });
      }
    }

    Library _recentLibrary = AppConfig.me.cardLibraries
        .firstWhere((lib) => lib.libraryType == LibraryType.recent);
    List<Profile> _recentLibraryProfiles =
        _libraries[_recentLibrary.name] ?? [];
    if (!FocusScope.of(context).hasPrimaryFocus &&
        FocusScope.of(context).focusedChild != null) {
      print("Has Focus");
      FocusManager.instance.primaryFocus.unfocus();
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AddProfileToLibraryBottomSheet(
        _recentLibraryProfiles,
        _currentLibrary,
        _profileAdded,
        _profileRemoved,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _currentLibrary = AppConfig.me.cardLibraries
        .firstWhere((lib) => lib.libraryType == LibraryType.recent);
    _customLibraries = AppConfig.me.cardLibraries
        .where((lib) => lib.libraryType == LibraryType.other)
        .toList();
    _customQueryLibraries = new List.from(_customLibraries);
    _getProfiles(_currentLibrary);
    if (widget.initialProfileId != null) {
      _openProfile(widget.initialProfileId);
    }
  }

  int get _totalConnections {
    Set<String> _ids = new Set<String>();
    AppConfig.me.cardLibraries.forEach((lib) {
      _ids.addAll(lib.profileIds);
    });
    return _ids.length;
  }

  void _showNotificationBottomSheet() {
    void _newNotification() {}
    void _addReminder(String reminderId) {}

    if (!FocusScope.of(context).hasPrimaryFocus &&
        FocusScope.of(context).focusedChild != null) {
      print("Has Focus");
      FocusManager.instance.primaryFocus.unfocus();
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: color2,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: color2,
          borderRadius: BorderRadius.circular(20),
        ),
        child:
            NotificationPage(_newNotification, _addReminder, (Profile profile) {
          _openProfile(profile.id);
        }),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
    AppConfig.newNotification.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!FocusScope.of(context).hasPrimaryFocus)
          FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: color2,
          drawer: SettingsDrawer(),
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: _showMyCustomLibraries || _showProfile
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: color5,
                    ),
                    onPressed: goBack,
                  )
                : GestureDetector(
                    onTap: () {
                      if (!FocusScope.of(context).hasPrimaryFocus &&
                          FocusScope.of(context).focusedChild != null) {
                        print("Has Focus");
                        FocusManager.instance.primaryFocus.unfocus();
                      }
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
            centerTitle: true,
            title: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: _query,
                style: myTs(color: color5.withOpacity(0.6), size: 15),
                maxLines: 1,
                minLines: 1,
                decoration: InputDecoration(
                  prefixIconConstraints: BoxConstraints(
                    maxHeight: 25,
                    maxWidth: 45,
                  ),
                  prefixIcon: Container(
                    margin: EdgeInsets.only(left: 5, right: 10),
                    child: Opacity(
                      opacity: 0.6,
                      child: SvgPicture.asset(
                        "assets/icons/search.svg",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  fillColor: Colors.transparent,
                  filled: true,
                  isDense: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none),
                  hintText: "Search by Releated keywords",
                  hintStyle: myTs(color: Colors.grey, size: 11.5),
                  suffixIcon: _controller.value.text.isEmpty
                      ? null
                      : IconButton(
                          icon: Icon(
                            Icons.close,
                            color: color5,
                          ),
                          iconSize: 20,
                          onPressed: () {
                            _controller.clear();
                            _query("");
                          },
                        ),
                ),
              ),
            ),
            actions: _selectedLibraries.isNotEmpty
                ? <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      onPressed: _deleteLibraries,
                    ),
                  ]
                : _selectedProfiles.isNotEmpty
                    ? <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: _deleteProfiles,
                        ),
                      ]
                    : <Widget>[
                        /* Stack(
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
                      ), */
                        //TODO added above comment for v2.0

                        //TODO Below icon is added for v2.0
                        ValueListenableBuilder<
                            Map<String, List<AppNotification>>>(
                          valueListenable: AppConfig.notifications,
                          builder: (context, notifications, child) {
                            return IconButton(
                              icon: Stack(
                                children: [
                                  ValueListenableBuilder<bool>(
                                    valueListenable: AppConfig.newNotification,
                                    builder: (context, newNotification, child) {
                                      if (newNotification)
                                        return SvgPicture.asset(
                                          "assets/icons/notification1_with_dot.svg",
                                          height: 20,
                                          width: 20,
                                        );
                                      else
                                        return SvgPicture.asset(
                                          "assets/icons/notification1.svg",
                                          height: 20,
                                          width: 20,
                                        );
                                    },
                                  ),
                                  /* AppConfig.newNotification
                                    ? Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          height: 8,
                                          width: 8,
                                          decoration: BoxDecoration(
                                            color: color4,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      )
                                    : SizedBox(), */
                                ],
                              ),
                              onPressed: () {
                                _showNotificationBottomSheet();
                              },
                            );
                          },
                        ),
                      ],
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 7,
              ),
              _showProfile
                  ? SizedBox()
                  : Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: color4,
                            ),
                            child: Text(
                              "Hi! You have a total of $_totalConnections connections.",
                              style: myTs(
                                color: color1,
                              ),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: SvgPicture.asset(
                              "assets/icons/filter.svg",
                              fit: BoxFit.contain,
                              height: 15,
                              width: 15,
                            ),
                            onPressed: _showFilter,
                            constraints: BoxConstraints(),
                            padding: EdgeInsets.zero,
                            splashRadius: 25,
                          )
                        ],
                      ),
                    ),
              Expanded(
                child: _body,
              ),
            ],
          ),
          floatingActionButton: !_showProfile &&
                  _showMyLibraries &&
                  !_showMyCustomLibraries
              ? RaisedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => CreateCategoryDialog(
                        (String name) async {
                          Library library = await AppConfig.addLibrary(name);
                          setState(() {
                            _customLibraries.add(library);
                            _customQueryLibraries.add(library);
                          });
                        },
                      ),
                    );
                  },
                  //mini: true,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/add.svg",
                        height: 30,
                        width: 30,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Add Folder",
                        style: myTs(color: color4),
                      ),
                    ],
                  ),
                  color: color3,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                )
              : _currentLibrary.libraryType == LibraryType.other
                  ? RaisedButton(
                      onPressed: _addProfileToLibrary,
                      //mini: true,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/add.svg",
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Add Profile",
                            style: myTs(color: color4),
                          ),
                        ],
                      ),
                      color: color3,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    )
                  : null),
    );
  }

  Widget get _body {
    if (_loading)
      return Center(
        child: Text(
          "Loading....",
          style: myTs(color: color5, size: 20),
        ),
      );
    if (_showProfile) return DiscoverProfileCardDetails(_currentShownProfile);
    if (_showMyLibraries && !_showMyCustomLibraries) {
      if (_customQueryLibraries.isEmpty)
        return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 20),
          child: Text(
            "No Custom Folders found!!",
            textAlign: TextAlign.center,
            style: myTs(color: color5, size: 20),
          ),
        );
      else
        return RefreshIndicator(
          onRefresh: () async {
            refresh();
          },
          child: _yearTiles(),
        );
    } else {
      if (_currentQueryProfiles.isEmpty)
        return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 20),
          child: Text(
            "No Profiles Added!!",
            style: myTs(color: color5, size: 20),
          ),
        );
      else
        return RefreshIndicator(
          onRefresh: () async {
            refresh();
          },
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: _currentQueryProfiles.length,
            itemBuilder: (context, i) {
              bool _selected =
                  _selectedProfiles.contains(_currentQueryProfiles[i].id);
              return GestureDetector(
                onTap: () {
                  _onTap(_currentQueryProfiles[i].id);
                },
                onLongPress: () {
                  _onLongPress(_currentQueryProfiles[i].id);
                },
                child: Container(
                  foregroundDecoration: BoxDecoration(
                    color: _selected
                        ? color4.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: LibraryProfile(
                      _currentQueryProfiles[i],
                      _profileAddedTime[_currentQueryProfiles[i].id] ??
                          DateTime.now()),
                ),
              );
            },
          ),
        );
    }
  }

  Widget _yearTiles() {
    double aspectRatio = 0.5 / 0.45;
    Set<int> yearSet = new Set<int>();
    _customQueryLibraries.forEach((lib) {
      yearSet.add(lib.dateCreated.year);
    });
    List<int> years = yearSet.toList();
    years.sort((i1, i2) {
      return -1 * i1.compareTo(i2);
    });
    return ListView.builder(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: years.length,
      itemBuilder: (context, i) {
        var libraryList = _customQueryLibraries
            .where((lib) => lib.dateCreated.year == years[i])
            .toList();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                years[i].toString(),
                style:
                    myTs(color: color5, size: 17, fontWeight: FontWeight.bold),
              ),
            ),
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: aspectRatio,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(
                libraryList.length,
                (j) => GestureDetector(
                  onLongPress: () {
                    if (_selectedLibraries.isEmpty) {
                      setState(() {
                        _selectedLibraries.add(libraryList[j].name);
                      });
                    }
                  },
                  onTap: () {
                    if (_selectedLibraries.isEmpty) {
                      _showMyCustomLibraries = true;
                      _currentLibrary = libraryList[j];
                      _getProfiles(libraryList[j]);
                    } else {
                      setState(() {
                        if (_selectedLibraries.contains(libraryList[j].name))
                          _selectedLibraries.remove(libraryList[j].name);
                        else
                          _selectedLibraries.add(libraryList[j].name);
                      });
                    }
                  },
                  child: LibraryFolder(libraryList[j], j,
                      _selectedLibraries.contains(libraryList[j].name)),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
