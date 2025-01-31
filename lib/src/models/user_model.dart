import 'package:ggsb_project/src/models/character_model.dart';

class UserModel {
  final String? uid;
  final String? deviceToken;
  final String? nickname;
  final String? loginType;
  final String? email;
  final String? school;
  final bool? isTimer;
  final int? totalSeconds;
  final int? cash;
  final List<String>? roomIdList;
  final CharacterModel? characterData;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isMarketingAgreed;

  UserModel(
      {this.uid,
      this.deviceToken,
      this.nickname,
      this.loginType,
      this.email,
      this.school,
      this.isTimer,
      this.totalSeconds,
      this.cash,
      this.roomIdList,
      this.characterData,
      this.createdAt,
      this.updatedAt,
      this.isMarketingAgreed});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] == null ? null : json['uid'] as String,
      deviceToken:
          json['deviceToken'] == null ? null : json['deviceToken'] as String,
      nickname: json['nickname'] == null ? null : json['nickname'] as String,
      loginType: json['loginType'] == null ? null : json['loginType'] as String,
      email: json['email'] == null ? null : json['email'] as String,
      school: json['school'] == null ? null : json['school'] as String,
      isTimer: json['isTimer'] == null ? null : json['isTimer'] as bool,
      totalSeconds:
          json['totalSeconds'] == null ? null : json['totalSeconds'] as int,
      cash: json['cash'] == null ? null : json['cash'] as int,
      roomIdList: json['roomIdList'] == null
          ? null
          : List<String>.from(json['roomIdList']),
      characterData: json['characterData'] == null
          ? null
          : CharacterModel.fromJson(json['characterData']),
      createdAt: json['createdAt'] == null ? null : json["createdAt"].toDate(),
      updatedAt: json['updatedAt'] == null ? null : json["updatedAt"].toDate(),
      isMarketingAgreed: json['isMarketingAgreed'] == null
          ? null
          : json['isMarketingAgreed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'deviceToken': deviceToken,
      'nickname': nickname,
      'loginType': loginType,
      'email': email,
      'school': school,
      'isTimer': isTimer,
      'totalSeconds': totalSeconds,
      'cash': cash,
      'roomIdList': roomIdList,
      'characterData': characterData == null ? null : characterData!.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isMarketingAgreed': isMarketingAgreed,
    };
  }

  UserModel copyWith({
    String? uid,
    String? deviceToken,
    String? nickname,
    String? loginType,
    String? email,
    String? school,
    bool? isTimer,
    int? totalSeconds,
    int? cash,
    List<String>? roomIdList,
    CharacterModel? characterData,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isMarketingAgreed,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      deviceToken: deviceToken ?? this.deviceToken,
      nickname: nickname ?? this.nickname,
      loginType: loginType ?? this.loginType,
      email: email ?? this.email,
      isTimer: isTimer ?? this.isTimer,
      school: school ?? this.school,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      cash: cash ?? this.cash,
      roomIdList: roomIdList ?? this.roomIdList,
      characterData: characterData ?? this.characterData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isMarketingAgreed: isMarketingAgreed ?? this.isMarketingAgreed,
    );
  }
}
