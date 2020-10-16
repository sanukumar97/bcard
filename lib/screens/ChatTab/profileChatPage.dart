import 'dart:io';
import 'package:bcard/screens/ChatTab/imageMessageTile.dart';
import 'package:bcard/screens/ChatTab/reminderMessageTile.dart';
import 'package:bcard/screens/ChatTab/textMessageTile.dart';
import 'package:bcard/utilities/Classes/MessageClasses/messageClass.dart';
import 'package:bcard/utilities/Classes/MessageClasses/textMessageClass.dart';
import 'package:bcard/utilities/Classes/MessageClasses/imageMessageClass.dart';
import 'package:bcard/utilities/Classes/MessageClasses/reminderMessageClass.dart';
import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:bcard/utilities/Classes/reminderClass.dart';
import 'package:bcard/utilities/Constants/encodersAndDecoders.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/firebaseFunctions.dart';
import 'package:flutter/material.dart';
import 'package:bcard/screens/ChatTab/helperClasses.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


class ProfileChatPage extends StatefulWidget {
  final Profile profile;
  final List<DateMessages> messages;
  ProfileChatPage(this.profile, this.messages);
  @override
  _ProfileChatPageState createState() => _ProfileChatPageState();
}

class _ProfileChatPageState extends State<ProfileChatPage> {
  TextEditingController _controller = new TextEditingController();
  ScrollController _scrollController =
      new ScrollController(initialScrollOffset: 0.0);
  bool _imageSending = false;
  bool _addingReminder = false;
  DateTime _reminderDate;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  void _startAddingReminder() {
    setState(() {
      _addingReminder = true;
      _controller.clear();
    });
  }

  void _stopAddingReminder() {
    setState(() {
      _addingReminder = false;
      _controller.clear();
      _reminderDate = null;
    });
  }

  void _sendTextMessage() {
    TextMessage textMessage = new TextMessage(
        AppConfig.currentProfile.id, widget.profile.id, _controller.value.text);
    FirebaseFunctions.sendMessage(textMessage);
    setState(() {
      _controller.clear();
    });
  }

  void _selectImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      int bytes = await image.length();
      if (bytes / 1024 <= 3096) {
        image = await ImageCropper.cropImage(sourcePath: image.path);
        if (image != null) {
          _sendImageMessage(image);
        }
      } else {
        appToast("Maximum Image size allowed is 3MB", context);
      }
    }
  }

  void _sendImageMessage(File image) async {
    setState(() {
      _imageSending = true;
    });
    String imageUrl = await FirebaseFunctions.uploadImage(image,
        "${AppConfig.currentProfile.id}${widget.profile.id}${DateTime.now().toIso8601String()}");
    ImageMessage imageMessage = new ImageMessage(
        AppConfig.currentProfile.id, widget.profile.id, imageUrl);
    await FirebaseFunctions.sendMessage(imageMessage);
    setState(() {
      _imageSending = false;
    });
  }

  void _selectDate() async {
    DateTime _today = DateTime.now();
    DateTime _dt = await showDatePicker(
      context: context,
      initialDate: _reminderDate ?? _today,
      firstDate: _today,
      lastDate: _today.add(Duration(days: 30 * 12)),
      currentDate: _reminderDate,
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDatePickerMode: DatePickerMode.day,
    );
    if (_dt != null) {
      TimeOfDay _time =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (_time != null) {
        setState(() {
          _reminderDate = new DateTime(
              _dt.year, _dt.month, _dt.day, _time.hour, _time.minute, 0, 0, 0);
        });
      }
    }
  }

  void _sendReminderMessage() async {
    if (_reminderDate != null) {
      Reminder reminder = new Reminder(
          _reminderDate,
          AppConfig.currentProfile.id,
          _controller.value.text,
          [],
          false,
          widget.profile.id);
      String id = (await FirebaseFunctions.addReminders([reminder])).first;
      ReminderMessage reminderMessage = new ReminderMessage(
          AppConfig.currentProfile.id, widget.profile.id, id);
      FirebaseFunctions.sendMessage(reminderMessage);
      _stopAddingReminder();
    } else {
      appToast("Select Reminder Date", context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* if (_scrollController.positions.isNotEmpty &&
        _scrollController.offset != 0.0) {
      _scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 1000), curve: Curves.ease);
    } */
    return GestureDetector(
      onTap: () {
        if (!FocusScope.of(context).hasPrimaryFocus)
          FocusScope.of(context).unfocus();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                reverse: true,
                child: Column(
                  children: List<Widget>.generate(
                    widget.messages.length,
                    (i) {
                      return _dayTiles(
                          widget.messages[i].date, widget.messages[i].messages);
                    },
                  ),
                ),
              ),
            ),
            Container(
              child: TextFormField(
                controller: _controller,
                style: myTs(color: color4, size: 16),
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: color3,
                  hintText: "Type a message...",
                  hintStyle: myTs(color: color4.withOpacity(0.8), size: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: _addingReminder
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: color4,
                              ),
                              onPressed: _stopAddingReminder,
                            ),
                            IconButton(
                              icon: SvgPicture.asset("assets/icons/clock.svg"),
                              onPressed: _selectDate,
                              iconSize: 15,
                            ),
                            _controller.value.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.send,
                                      color: color4,
                                    ),
                                    onPressed: _sendReminderMessage,
                                  )
                                : SizedBox(),
                          ],
                        )
                      : _controller.value.text.isEmpty
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Opacity(
                                  opacity: _imageSending ? 0.2 : 1,
                                  child: IconButton(
                                    icon: SvgPicture.asset(
                                      "assets/icons/image.svg",
                                      fit: BoxFit.contain,
                                    ),
                                    onPressed:
                                        _imageSending ? null : _selectImage,
                                  ),
                                ),
                                IconButton(
                                  icon: SvgPicture.asset(
                                    "assets/icons/followup.svg",
                                    fit: BoxFit.contain,
                                  ),
                                  onPressed: _startAddingReminder,
                                ),
                              ],
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.send,
                                color: color4,
                              ),
                              onPressed: _sendTextMessage,
                            ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _dayTiles(DateTime date, List<Message> messages) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            dateString(date),
            style: myTs(color: Colors.grey.withOpacity(0.4), size: 14),
          ),
        ),
        SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: List<Widget>.generate(
              messages.length,
              (i) {
                Message message = messages[i];
                bool _iAmSender =
                    AppConfig.currentProfile.id == message.senderProfileId;
                if (message.senderProfileId == AppConfig.currentProfile.id ||
                    message.recieverProfileId == AppConfig.currentProfile.id) {
                  switch (message.type) {
                    case MessageType.text:
                      return TextMessageTile(
                        message as TextMessage,
                        _iAmSender ? AppConfig.currentProfile : widget.profile,
                      );
                      break;
                    case MessageType.image:
                      return ImageMessageTile(
                          message as ImageMessage,
                          _iAmSender
                              ? AppConfig.currentProfile
                              : widget.profile);
                      break;
                    case MessageType.reminder:
                      return ReminderMessageTile(
                          message as ReminderMessage,
                          _iAmSender
                              ? AppConfig.currentProfile
                              : widget.profile);
                      break;
                    default:
                      return SizedBox();
                  }
                } else
                  return SizedBox();
              },
            ),
          ),
        )
      ],
    );
  }
}

