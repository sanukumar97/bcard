import 'package:bcard/utilities/Classes/MessageClasses/imageMessageClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Constants/encodersAndDecoders.dart';
import 'package:bcard/utilities/Constants/logoBox.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:flutter/material.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:shimmer/shimmer.dart';



class ImageMessageTile extends StatelessWidget {
  final ImageMessage imageMessage;
  final Profile profile;
  ImageMessageTile(this.imageMessage, this.profile);

  void _onTap(BuildContext context, Size size) {
    showDialog(
      context: context,
      builder: (context) => Container(
        height: size.height * 0.9,
        width: size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 0.2),
          color: color3,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                child: Icon(
                  Icons.arrow_back,
                  color: color5,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageMessage.imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null)
                      return child;
                    else
                      return Shimmer.fromColors(
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
                      );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool _iAmSender =
        AppConfig.currentProfile.id == imageMessage.senderProfileId;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: logoBox(false, profile.logoUrl, profile.profileType, 40, 40),
        title: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: _iAmSender
                    ? AppConfig.currentProfile.name ??
                        AppConfig.currentProfile.companyName ??
                        "Name"
                    : profile?.name ?? profile?.companyName ?? "Name",
                style:
                    myTs(color: color5, size: 18, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: "   " +
                    timeString(TimeOfDay.fromDateTime(imageMessage.date)),
                style: myTs(color: Colors.grey.withOpacity(0.5), size: 12),
              ),
            ],
          ),
        ),
        subtitle: GestureDetector(
          onTap: () {
            _onTap(context, size);
          },
          child: Container(
            height: size.width * 0.7,
            width: size.width * 0.7,
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 0.2),
              color: color3,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageMessage.imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null)
                    return child;
                  else
                    return Shimmer.fromColors(
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
                    );
                },
              ),
            ),
          ),
        ),
        /* subtitle: Container(
          alignment: Alignment.bottomRight,
          child: Text(
            timeString(TimeOfDay.fromDateTime(imageMessage.date)),
            style: myTs(color: Colors.grey.withOpacity(0.5), size: 12),
          ),
        ), */
      ),
    );
  }
}
