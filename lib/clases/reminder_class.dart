import 'dart:convert';
List<Reminder> reminderFromJson(String str) =>
    List<Reminder>.from(json.decode(str).map((x) => Reminder.fromJson(x)));

String reminderToJson(List<Reminder> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reminder {
  Reminder({
    required this.id,
    required this.priority,
    required this.reminder,
    required this.date,
  });

  String id;
  String priority;
  String reminder;
  String date;

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        id: json["id"],
        priority: json["priority"],
        reminder: json["reminder"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "priority": priority,
        "reminder": reminder,
        "date": date,
      };
}
