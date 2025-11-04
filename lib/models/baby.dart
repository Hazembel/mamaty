class Baby {
  String? id;
  String? name;
  String? birthday;
  String? gender;
  String? avatar;
  double? height;
  double? weight;
  String? disease;
  String? allergy;
  double? headSize;
  bool? autorisation;
  String userId;
  DateTime? lastHeadSizeUpdate;

  Baby({
    this.id,
    this.name,
    this.birthday,
    this.gender,
    this.avatar,
    this.height,
    this.weight,
    this.disease,
    this.allergy,
    this.headSize,
    this.autorisation,
    required this.userId,
    this.lastHeadSizeUpdate,
  });

 factory Baby.fromJson(Map<String, dynamic> json) {
  String userId;

  if (json['userId'] is Map) {
    // When backend returns full user object
    userId = json['userId']['_id'] ?? '';
  } else if (json['userId'] is String) {
    // When backend returns only the ID
    userId = json['userId'];
  } else {
    userId = '';
  }

  return Baby(
    id: json['_id'],
    name: json['name'],
    birthday: json['birthday'],
    gender: json['gender'],
    avatar: json['avatar'],
    height: (json['height'] != null) ? (json['height'] as num).toDouble() : null,
    weight: (json['weight'] != null) ? (json['weight'] as num).toDouble() : null,
    disease: json['disease'],
    allergy: json['allergy'],
    headSize: (json['headSize'] != null) ? (json['headSize'] as num).toDouble() : null,
    autorisation: json['autorisation'] ?? true,
    userId: userId,
    lastHeadSizeUpdate: json['lastheadsizeUpdate'] != null
        ? DateTime.tryParse(json['lastheadsizeUpdate'])
        : null,
  );
}


  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'birthday': birthday,
      'gender': gender,
      'avatar': avatar,
      'height': height,
      'weight': weight,
      'disease': disease,
      'allergy': allergy,
      'headSize': headSize,
      'autorisation': autorisation,
      'userId': userId, // ✅ match backend
      'lastheadsizeUpdate': lastHeadSizeUpdate?.toIso8601String(),
    };
  }
}
