import 'package:bcard/utilities/Classes/NotificationClasses/profileVisitedNotificationClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/encodersAndDecoders.dart';
import 'package:bcard/utilities/Constants/logoBox.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileVisitedTile extends StatefulWidget {
  final ProfileVisitedNotification visited;
  final Function(Profile) _showNotificationProfile;
  ProfileVisitedTile(this.visited, this._showNotificationProfile);
  @override
  _ProfileVisitedTileState createState() => _ProfileVisitedTileState();
}

class _ProfileVisitedTileState extends State<ProfileVisitedTile> {
  Profile _senderprofile;
  bool _loaded = false;

  void _getDetails() async {
    _senderprofile =
        await FirebaseFunctions.getProfile(widget.visited.senderProfileId);
    _loaded = true;
    if (this.mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getDetails();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: _loaded
          ? () {
              widget._showNotificationProfile(_senderprofile);
            }
          : null,
      child: Container(
        height: 90,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: _loaded
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color5.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: logoBox(
                        false,
                        _senderprofile?.logoUrl,
                        _senderprofile?.profileType,
                        size.width * 0.23,
                        size.width * 0.23),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: _senderprofile?.name ?? "Name",
                                style: myTs(
                                  color: color5,
                                  size: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    " (${_senderprofile?.occupation ?? "Occupation"})",
                                style: myTs(
                                  color: color5,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "Visited",
                                style: myTs(
                                  color: color4,
                                  size: 16,
                                ),
                              ),
                              TextSpan(
                                text: " your " +
                                    (widget.visited.recieverProfileId ==
                                            AppConfig.me.businessDocId
                                        ? "Business"
                                        : "Personal") +
                                    " card",
                                style: myTs(
                                  color: color5,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            timeString(
                              TimeOfDay.fromDateTime(widget.visited.date),
                            ),
                            style: myTs(
                              color: color5.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Shimmer.fromColors(
                child: Container(
                  decoration: BoxDecoration(
                    color: color5,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 204,
                  width: double.maxFinite,
                ),
                baseColor: color5.withOpacity(0.6),
                highlightColor: color5.withOpacity(0.2),
              ),
      ),
    );
  }
}
