final String tableUser = "user";

class UserFields {
  static final List<String> values = [id, name, email, photo, type];
  static final String id = "_id";
  static final String name = "name";
  static final String email = "email";
  static final String photo = "photo";
  static final String type = "type";
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? photo;
  final String? type;

  const User({
    this.id,
    required this.name,
    required this.email,
    this.photo,
    this.type,
  });

  Map<String, Object?> toJson() => {
        UserFields.id: id,
        UserFields.name: name,
        UserFields.email: email,
        UserFields.photo: photo,
        UserFields.type: type,
      };

  User copy({
    int? id,
    String? name,
    String? email,
    String? photo,
    String? type,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        photo: photo ?? this.photo,
        type: type ?? this.type,
      );

  static User fromJson(Map<String, Object?> json) => User(
        id: json[UserFields.id] as int?,
        name: json[UserFields.name] as String?,
        email: json[UserFields.email] as String?,
        photo: json[UserFields.photo] as String?,
        type: json[UserFields.type] as String?,
      );
}
