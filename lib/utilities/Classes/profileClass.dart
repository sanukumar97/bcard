import 'package:bcard/utilities/Classes/locationClass.dart';
import 'package:bcard/utilities/Constants/encodersAndDecoders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Profile {
  String userName;
  String _backgroundImageUrl,
      _logoUrl,
      _companyName,
      _occupation,
      _name,
      _coverUrl;
  Color _companyNameColor, _occupationColor, _nameColor;
  List<String> _mobile, _phone, _email, _website, _socialMedia, _tags;
  List<Location> _locations;
  CardStructure _cardStructure;
  ProfileStatus _profileStatus;
  ProfileType _profileType;
  ProfileLevel _profileLevel;
  DocumentReference ref;
  String id;

  bool updated;

  set backgroundImageUrl(String url) {
    this._backgroundImageUrl = url;
    updated = true;
  }

  String get backgroundImageUrl => this._backgroundImageUrl;

  set logoUrl(String url) {
    this._logoUrl = url;
    updated = true;
  }

  String get logoUrl => this._logoUrl;

  set companyName(String s) {
    this._companyName = s;
    updated = true;
  }

  String get companyName => this._companyName;

  set occupation(String s) {
    this._occupation = s;
    updated = true;
  }

  String get occupation => this._occupation;

  set name(String s) {
    this._name = s;
    updated = true;
  }

  String get name => this._name;

  set coverUrl(String url) {
    this._coverUrl = url;
    updated = true;
  }

  String get coverUrl => this._coverUrl;

  set companyNameColor(Color color) {
    this._companyNameColor = color;
    updated = true;
  }

  Color get companyNameColor => this._companyNameColor;

  set occupationColor(Color color) {
    this._occupationColor = color;
    updated = true;
  }

  Color get occupationColor => this._occupationColor;

  set nameColor(Color color) {
    this._nameColor = color;
    updated = true;
  }

  Color get nameColor => this._nameColor;

  set cardStructure(CardStructure cardStructure) {
    this._cardStructure = cardStructure;
    updated = true;
  }

  CardStructure get cardStructure => this._cardStructure;

  set profileStatus(ProfileStatus profileStatus) {
    this._profileStatus = profileStatus;
    updated = true;
  }

  ProfileStatus get profileStatus => this._profileStatus;

  set profileType(ProfileType profileType) {
    this._profileType = profileType;
    updated = true;
  }

  ProfileType get profileType => this._profileType;

  set profileLevel(ProfileLevel profileLevel) {
    this._profileLevel = profileLevel;
    updated = true;
  }

  ProfileLevel get profileLevel => this._profileLevel;

  set mobile(List<String> mobile) {
    this._mobile = mobile;
    updated = true;
  }

  List<String> get mobile => this._mobile;

  set phone(List<String> phone) {
    this._phone = phone;
    updated = true;
  }

  List<String> get phone => this._phone;

  set email(List<String> email) {
    this._email = email;
    updated = true;
  }

  List<String> get email => this._email;

  set website(List<String> website) {
    this._website = website;
    updated = true;
  }

  List<String> get website => this._website;

  set socialMedia(List<String> socialMedia) {
    this._socialMedia = socialMedia;
    updated = true;
  }

  List<String> get socialMedia => this._socialMedia;

  set tags(List<String> tags) {
    this._tags = tags;
    updated = true;
  }

  List<Location> get locations => this._locations;

  set locations(List<Location> locations) {
    this._locations = locations;
    updated = true;
  }

  List<String> get tags => this._tags;

  Profile(this.userName, this._cardStructure, this._profileType, this.id) {
    this.backgroundImageUrl = null;
    this.logoUrl = null;
    this.companyName = null;
    this.companyNameColor = Colors.white;
    this.occupation = null;
    this.occupationColor = Colors.white;
    this.name = null;
    this.nameColor = Colors.white;
    this.coverUrl = null;
    this.mobile = [];
    this.phone = [];
    this.email = [];
    this.website = [];
    this.socialMedia = List.filled(5, null);
    this.tags = [];
    this.locations = [];
    this.profileStatus = ProfileStatus.public;
    this.profileLevel = ProfileLevel.beginner;
  }

  Profile.fromJson(Map<String, dynamic> data) {
    this.id = data["id"];
    this.userName = data["userName"];
    this.backgroundImageUrl = data["backgroundImageUrl"];
    this.logoUrl = data["logoUrl"];
    this.companyName = data["companyName"];
    this.companyNameColor = colorDecoder(data["companyNameColor"]);
    this.occupation = data["occupation"];
    this.occupationColor = colorDecoder(data["occupationColor"]);
    this.name = data["name"];
    this.nameColor = colorDecoder(data["nameColor"]);
    this.coverUrl = data["coverUrl"];
    this.mobile = data["mobile"] != null
        ? List<String>.generate(data["mobile"].length, (i) => data["mobile"][i])
        : [];
    this.phone = data["phone"] != null
        ? List<String>.generate(data["phone"].length, (i) => data["phone"][i])
        : [];
    this.email = data["email"] != null
        ? List<String>.generate(data["email"].length, (i) => data["email"][i])
        : [];
    this.website = data["website"] != null
        ? List<String>.generate(
            data["website"].length, (i) => data["website"][i])
        : [];
    this.socialMedia = data["socialMedia"] != null
        ? List<String>.generate(
            data["socialMedia"].length, (i) => data["socialMedia"][i])
        : [];
    this.tags = data["tags"] != null
        ? List<String>.generate(data["tags"].length, (i) => data["tags"][i])
        : [];
    this.locations = data["locations"] != null
        ? List<Location>.generate(data["locations"].length,
            (i) => new Location.fromJson(data["locations"][i]))
        : [];
    this.cardStructure = cardStructureNamesRev[data["cardStructure"]];
    this.profileStatus = profileStatusNamesRev[data["profileStatus"]];
    this.profileType = profileTypeNamesRev[data["profileType"]];
    this.profileLevel =
        profileLevelNamesRev[data["profileLevel"] ?? "beginner"];
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'userName': this.userName,
        'backgroundImageUrl': this.backgroundImageUrl,
        'logoUrl': this.logoUrl,
        'companyName': this.companyName,
        'companyNameColor': colorEncoder(this.companyNameColor),
        'occupation': this.occupation,
        'occupationColor': colorEncoder(this.occupationColor),
        'name': this.name,
        'nameColor': colorEncoder(this.nameColor),
        'coverUrl': this.coverUrl,
        'mobile': this.mobile,
        'phone': this.phone,
        'email': this.email,
        'website': this.website,
        'socialMedia': this.socialMedia,
        'tags': this.tags,
        'locations': List<Map<String, dynamic>>.generate(
            this.locations.length, (i) => this.locations[i].toJson()),
        'cardStructure': cardStructureNames[this.cardStructure],
        'profileStatus': profileStatusNames[this.profileStatus],
        'profileType': profileTypeNames[this.profileType],
        'profileLevel': profileLevelNames[this.profileLevel],
      };

  Map<String, dynamic> tobeUpdatedData(Profile other) {
    Map<String, dynamic> data = {};
    if (this.backgroundImageUrl != other.backgroundImageUrl)
      data.addAll({"backgroundImageUrl": this.backgroundImageUrl});
    if (this.logoUrl != other.logoUrl) data.addAll({"logoUrl": this.logoUrl});
    if (this.companyName != other.companyName)
      data.addAll({"companyName": this.companyName});
    if (this.occupation != other.occupation)
      data.addAll({"occupation": this.occupation});
    if (this.name != other.name) data.addAll({"name": this.name});
    if (this.coverUrl != other.coverUrl)
      data.addAll({"coverUrl": this.coverUrl});
    if (colorEncoder(this.companyNameColor) !=
        colorEncoder(other.companyNameColor))
      data.addAll({"companyNameColor": colorEncoder(this.companyNameColor)});
    if (colorEncoder(this.occupationColor) !=
        colorEncoder(other.occupationColor))
      data.addAll({"occupationColor": colorEncoder(this.occupationColor)});
    if (colorEncoder(this.nameColor) != colorEncoder(other.nameColor))
      data.addAll({"nameColor": colorEncoder(this.nameColor)});
    if (this.cardStructure != other.cardStructure)
      data.addAll({"cardStructure": cardStructureNames[this.cardStructure]});
    if (this.profileStatus != other.profileStatus)
      data.addAll({"profileStatus": profileStatusNames[this.profileStatus]});
    if (this.profileType != other.profileType)
      data.addAll({"profileType": profileTypeNames[this.profileType]});
    if (this.profileLevel != other.profileLevel)
      data.addAll({"profileLevel": profileLevelNames[this.profileLevel]});
    if (!listEqual(this.mobile, other.mobile))
      data.addAll({"mobile": this.mobile});
    if (!listEqual(this.phone, other.phone)) data.addAll({"phone": this.phone});
    if (!listEqual(this.email, other.email)) data.addAll({"email": this.email});
    if (!listEqual(this.website, other.website))
      data.addAll({"website": this.website});
    if (!listEqual(this.socialMedia, other.socialMedia))
      data.addAll({"socialMedia": this.socialMedia});
    if (!listEqual(this.tags, other.tags)) data.addAll({"tags": this.tags});
    if (!listEqual(this.locations.map<String>((e) => e.address).toList(),
        other.locations.map<String>((e) => e.address).toList()))
      data.addAll({
        "locations": List<Map<String, dynamic>>.generate(
            this.locations.length, (i) => this.locations[i].toJson())
      });
    return data;
  }
}


enum CardStructure { horizantal, vertical }

Map<CardStructure, String> cardStructureNames = {
  CardStructure.horizantal: "Horizantal",
  CardStructure.vertical: "Vertical"
};

Map<String, CardStructure> cardStructureNamesRev = {
  "Horizantal": CardStructure.horizantal,
  "Vertical": CardStructure.vertical
};

enum ProfileStatus { public, requested }

Map<ProfileStatus, String> profileStatusNames = {
  ProfileStatus.public: "Public",
  ProfileStatus.requested: "Requested"
};

Map<String, ProfileStatus> profileStatusNamesRev = {
  "Public": ProfileStatus.public,
  "Requested": ProfileStatus.requested
};

enum ProfileType { business, personal }
Map<ProfileType, String> profileTypeNames = {
  ProfileType.business: "business",
  ProfileType.personal: "personal"
};
Map<String, ProfileType> profileTypeNamesRev = {
  "business": ProfileType.business,
  "personal": ProfileType.personal,
};

enum ProfileLevel { beginner, intermediate, professional }
Map<ProfileLevel, String> profileLevelNames = {
  ProfileLevel.beginner: "Beginner",
  ProfileLevel.intermediate: "Intermediate",
  ProfileLevel.professional: "Professional"
};
Map<String, ProfileLevel> profileLevelNamesRev = {
  "Beginner": ProfileLevel.beginner,
  "Intermediate": ProfileLevel.intermediate,
  "Professional": ProfileLevel.professional
};

bool listEqual(List<String> l1, List<String> l2) {
  bool equal = true;
  if (l1.length != l2.length) return false;
  l1.forEach((e) {
    if (!l2.contains(e)) equal = false;
  });
  return equal;
}

