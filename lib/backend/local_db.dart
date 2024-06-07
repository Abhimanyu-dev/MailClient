import "package:hive_flutter/hive_flutter.dart";

class DB{
  static Future<void> initialize() async{
    await Hive.initFlutter();
  }
}