class RoomModel {
  final String? roomId;
  final String? roomName;
  final String? creatorUid;
  final String? creatorName;
  final String? roomType;
  final String? color;
  final List<String>? uidList;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RoomModel({
    this.roomId,
    this.roomName,
    this.creatorUid,
    this.creatorName,
    this.roomType,
    this.color,
    this.uidList,
    this.createdAt,
    this.updatedAt,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      roomId: json['roomId'] == null ? null : json['roomId'] as String,
      roomName: json['roomName'] == null ? null : json['roomName'] as String,
      creatorUid:
          json['creatorUid'] == null ? null : json['creatorUid'] as String,
      creatorName:
          json['creatorName'] == null ? null : json['creatorName'] as String,
      roomType: json['roomType'] == null ? null : json['roomType'] as String,
      color: json['color'] == null ? null : json['color'] as String,
      uidList:
          json['uidList'] == null ? null : List<String>.from(json['uidList']),
      createdAt: json['createdAt'] == null ? null : json['createdAt'].toDate(),
      updatedAt: json['updatedAt'] == null ? null : json['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'roomName': roomName,
      'creatorUid': creatorUid,
      'creatorName': creatorName,
      'roomType': roomType,
      'color': color,
      'uidList': uidList,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  RoomModel copyWith({
    String? roomId,
    String? roomName,
    String? creatorUid,
    String? creatorName,
    String? roomType,
    String? color,
    List<String>? uidList,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RoomModel(
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      creatorUid: creatorUid ?? this.creatorUid,
      creatorName: creatorName ?? this.creatorName,
      roomType: roomType ?? this.roomType,
      color: color ?? this.color,
      uidList: uidList ?? this.uidList,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.createdAt,
    );
  }
}
