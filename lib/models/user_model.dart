import "package:hive/hive.dart";
import "email_model.dart";

part "user_model.g.dart";

@HiveType(typeId: 1)
class User{
  @HiveField(0)
  String username;
  @HiveField(1)
  String password;
  @HiveField(2)
  List<Email> mails;

  User(this.username, this.mails, this.password);
}