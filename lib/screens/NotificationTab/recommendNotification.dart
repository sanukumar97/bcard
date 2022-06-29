import 'package:bcard/utilities/Classes/NotificationClasses/recommendNotificationClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/encodersAndDecoders.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:bcard/utilities/Constants/logoBox.dart';

class ProfileRecommendationTile extends StatefulWidget {
  final RecommendNotification recommend;
  final Function(Profile) _showNotificationProfile;
  ProfileRecommendationTile(this.recommend, this._showNotificationProfile);
  @override
  _ProfileRecommendationTileState createState() =>
      _ProfileRecommendationTileState();
}

class _ProfileRecommendationTileState extends State<ProfileRecommendationTile> {
  Profile _senderprofile, _recommendedProfile;
  bool _loaded = false;

  void _getDetails() async {
    if (!_loaded) {
      List<Profile> list = await FirebaseFunctions.getProfiles([
        widget.recommend.senderProfileId,
        widget.recommend.recommendedProfileId
      ]);
      _senderprofile = list.firstWhere(
          (prf) => prf.id == widget.recommend.senderProfileId,
          orElse: () => null);
      _recommendedProfile = list.firstWhere(
          (prf) => prf.id == widget.recommend.recommendedProfileId,
          orElse: () => null);
      _loaded = true;
      if (this.mounted) setState(() {});
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
              widget._showNotificationProfile(_recommendedProfile);
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
                                text: "Recommended",
                                style: myTs(
                                  color: color4,
                                  size: 16,
                                ),
                              ),
                              TextSpan(
                                text:
                                    " you ${_recommendedProfile?.name ?? "Name"}'s card",
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
                              TimeOfDay.fromDateTime(widget.recommend.date),
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
