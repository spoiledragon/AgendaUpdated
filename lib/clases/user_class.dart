import 'dart:convert';

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
    User({
        required this.id,
        required this.userName,
        required this.email,
        required this.code,
        required this.error,
    });

    String id;
    String userName;
    String email;
    String code;
    String error;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["Id"],
        userName: json["UserName"],
        email: json["Email"],
        code: json["Code"],
        error: json["Error"],
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "UserName": userName,
        "Email": email,
        "Code": code,
        "Error": error,
    };
}