import 'package:bcard/utilities/Classes/NotificationClasses/profileRequestNotificationClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/encodersAndDecoders.dart';
import 'package:bcard/utilities/Constants/logoBox.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileRequestTile extends StatefulWidget {
  final ProfileRequestNotification request;
  final Function(Profile) _showNotificationProfile;
  final Function(ProfileRequestNotification) handleError;
  ProfileRequestTile(
      this.request, this._showNotificationProfile, this.handleError);
  @override
  _ProfileRequestTileState createState() => _ProfileRequestTileState();
}

class _ProfileRequestTileState extends State<ProfileRequestTile> {
  Profile _senderprofile;
  bool _loaded = false, _loading = false;

  void _getDetails() async {
    _senderprofile =
        await FirebaseFunctions.getProfile(widget.request.senderProfileId);

    _loaded = true;
    if (this.mounted) setState(() {});
  }

  void _acceptProfileRequest() async {
    setState(() {
      _loading = true;
    });
    bool error = await FirebaseFunctions.acceptRequest(widget.request);
    if (error) {
      widget.handleError(widget.request);
    } else {
      if (this.mounted)
        setState(() {
          _loading = false;
        });
    }
  }

  void _rejectProfileRequest() async {
    setState(() {
      _loading = true;
    });
    bool error = await FirebaseFunctions.rejectRequest(widget.request);
    if (error) {
      widget.handleError(widget.request);
    } else {
      if (this.mounted)
        setState(() {
          _loading = false;
        });
    }
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
              if (_senderprofile != null) {
                widget._showNotificationProfile(_senderprofile);
              }
            }
          : null,
      child: Container(
        height: 100,
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
                                text: "Sent you ",
                                style: myTs(
                                  color: color5,
                                  size: 16,
                                ),
                              ),
                              TextSpan(
                                text: (widget.request.recieverProfileId ==
                                            AppConfig.me.businessDocId
                                        ? "Business"
                                        : "Personal") +
                                    " Request",
                                style: myTs(
                                  color: color4,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: widget.request.status ==
                                  RequestStatus.requested
                              ? <Widget>[
                                  Spacer(),
                                  GestureDetector(
                                    onTap: _rejectProfileRequest,
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.red
                                            .withOpacity(_loading ? 0.3 : 1),
                                      ),
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: color5,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  GestureDetector(
                                    onTap: _acceptProfileRequest,
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: color4
                                            .withOpacity(_loading ? 0.3 : 1),
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: color5,
                                      ),
                                    ),
                                  ),
                                ]
                              : widget.request.status == RequestStatus.accepted
                                  ? <Widget>[
                                      Text(
                                        "Accepted",
                                        style: myTs(
                                          color: color4,
                                          size: 16,
                                        ),
                                      ),
                                    ]
                                  : <Widget>[
                                      Text(
                                        "Rejected",
                                        style: myTs(
                                          color: Colors.red,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            timeString(
                              TimeOfDay.fromDateTime(widget.request.date),
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
