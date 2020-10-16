import 'package:bcard/utilities/Classes/MessageClasses/messageClass.dart';
import 'package:bcard/utilities/localStorage.dart';

class AllMessages {
  List<ProfileMessages> _messages;
  Function({String profileId}) _getProfile;
  AllMessages(this._getProfile) {
    _messages = [];
  }

  void addMessage(Message message) {
    String _oppositeId = [
      AppConfig.me.businessDocId,
      AppConfig.me.personalDocId
    ].contains(message.senderProfileId)
        ? message.recieverProfileId
        : message.senderProfileId;

    int i = _messages.indexWhere((pm) => pm.profileId == _oppositeId);
    ProfileMessages profileMessages;
    if (i == -1) {
      _getProfile(profileId: _oppositeId);
      profileMessages = new ProfileMessages(_oppositeId);
      _messages.insert(0, profileMessages);
    } else {
      profileMessages = _messages[i];
    }
    profileMessages.addMessage(message);
    _messages.sort((pm1, pm2) {
      return -1 * pm1.messages.last.date.compareTo(pm2.messages.last.date);
    });
  }

  List<ProfileMessages> get messages => _messages;

  ProfileMessages getProfileMessages(String profileId) => _messages.firstWhere(
        (pm) => pm.profileId == profileId,
        orElse: () => null,
      );

  void clear() {
    _messages.clear();
  }
}

class ProfileMessages {
  String profileId;
  List<DateMessages> _messages;

  ProfileMessages(this.profileId) {
    _messages = [];
  }

  void addMessage(Message message) {
    DateTime date =
        new DateTime(message.date.year, message.date.month, message.date.day);
    int i = _messages.indexWhere(
        (dm) => dm.date.toIso8601String() == date.toIso8601String());
    if (i >= 0) {
      _messages[i].addMessage(message);
    } else {
      DateMessages dateMessages = new DateMessages(date);
      dateMessages.addMessage(message);
      _messages.add(dateMessages);
      if (_messages.length >= 2 &&
          _messages.last.date.isBefore(_messages[_messages.length - 2].date)) {
        _messages.sort((DateMessages dm1, DateMessages dm2) {
          return dm1.date.compareTo(dm2.date);
        });
      }
    }
  }

  List<DateMessages> get messages => _messages;
}

class DateMessages {
  DateTime date;
  List<Message> _messages;

  DateMessages(this.date) {
    this._messages = [];
  }

  void addMessage(Message message) {
    _messages.removeWhere((msg) => msg.id == message.id);
    _messages.add(message);
    if (_messages.length >= 2 &&
        _messages.last.date.isBefore(_messages[_messages.length - 2].date)) {
      _messages.sort((Message m1, Message m2) {
        return m1.date.compareTo(m2.date);
      });
    }
  }

  List<Message> get messages => _messages;
}
