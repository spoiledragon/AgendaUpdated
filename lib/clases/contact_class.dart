import 'dart:convert';

List<Contact> contactFromJson(String str) =>
    List<Contact>.from(json.decode(str).map((x) => Contact.fromJson(x)));

String contactToJson(List<Contact> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Contact {
  Contact({
    required this.id,
    required this.name,
    required this.email,
    required this.tel,
    required this.photoUrl,
  });

  String id;
  String name;
  String email;
  String tel;
  String photoUrl;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["id"],
        name: json["Name"],
        email: json["Email"],
        tel: json["Tel"],
        photoUrl: json["PhotoUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Name": name,
        "Email": email,
        "Tel": tel,
        "PhotoUrl": photoUrl,
      };
}
