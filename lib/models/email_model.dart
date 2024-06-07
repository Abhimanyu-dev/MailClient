import "package:hive/hive.dart";

part "email_model.g.dart";

@HiveType(typeId: 0)
class Email{
  @HiveField(0)
  String sender;
  @HiveField(1)
  String subject;
  @HiveField(2)
  int? uid;

  Email(this.sender, this.subject, this.uid);
}