class Report {
  String profileId, senderId, description;

  Report(this.profileId, this.senderId, this.description);

  Map<String, dynamic> toJson() => {
        "profileId": this.profileId,
        "senderId": this.senderId,
        "description": this.description,
      };
}
