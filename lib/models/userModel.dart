class BEUser {
  final int id;
  final String? profileImage;
  final String firstName;
  final String lastName;
  final String preferredWakeupTime;
  final int successGameCount;
  final List<dynamic> groups;

  BEUser({
    required this.id,
    this.profileImage,
    required this.firstName,
    required this.lastName,
    required this.preferredWakeupTime,
    required this.successGameCount,
    required this.groups,
  });

  // JSON 데이터를 User 객체로 변환
  factory BEUser.fromJson(Map<String, dynamic> json) {
    return BEUser(
      id: json['id'] as int,
      profileImage: json['profileImage'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      preferredWakeupTime: json['preferredWakeupTime'] as String,
      successGameCount: json['successGameCount'] as int,
      groups: json['groups'] as List<dynamic>, // 빈 배열일 수도 있음
    );
  }
}
