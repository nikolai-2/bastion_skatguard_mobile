import 'dart:convert';

class LoginDto {
  final String access_token;
  final User user;
  LoginDto({
    required this.access_token,
    required this.user,
  });

  LoginDto copyWith({
    String? access_token,
    User? user,
  }) {
    return LoginDto(
      access_token: access_token ?? this.access_token,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'access_token': access_token,
      'User': user.toMap(),
    };
  }

  factory LoginDto.fromMap(Map<String, dynamic> map) {
    return LoginDto(
      access_token: map['access_token'],
      user: User.fromMap(map['User']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginDto.fromJson(String source) =>
      LoginDto.fromMap(json.decode(source));

  @override
  String toString() => 'LoginDto(access_token: $access_token, user: $user)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginDto &&
        other.access_token == access_token &&
        other.user == user;
  }

  @override
  int get hashCode => access_token.hashCode ^ user.hashCode;
}

class User {
  final String name;
  final String avatar_src;
  final String role;
  final int id;

  User({
    required this.name,
    required this.avatar_src,
    required this.role,
    required this.id,
  });

  User copyWith({
    String? name,
    String? avatar_src,
    String? role,
    int? id,
  }) {
    return User(
      name: name ?? this.name,
      avatar_src: avatar_src ?? this.avatar_src,
      role: role ?? this.role,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'avatar_src': avatar_src,
      'role': role,
      'id': id,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      avatar_src: map['avatar_src'],
      role: map['role'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(name: $name, avatar_src: $avatar_src, role: $role, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.name == name &&
        other.avatar_src == avatar_src &&
        other.role == role &&
        other.id == id;
  }

  @override
  int get hashCode {
    return name.hashCode ^ avatar_src.hashCode ^ role.hashCode ^ id.hashCode;
  }
}
