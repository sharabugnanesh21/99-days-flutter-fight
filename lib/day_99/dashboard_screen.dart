import 'package:basic_app/day_99/dashboard_data_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class OurDashbaord extends StatefulWidget {
  const OurDashbaord({super.key});

  @override
  State<OurDashbaord> createState() => _OurDashbaordState();
}

class _OurDashbaordState extends State<OurDashbaord>{
  // SharedPreferencesAsync? prefs = await SharedPreferencesAsync.getInstance();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                OurDisplayData(whereFrom: 'Shared Preferences', future: getVaulesFromSharedPreferences()),
                SizedBox(height: 20,),
                OurDisplayData(whereFrom: 'SQLite', future: getVaulesFromSqfLite()),
                SizedBox(height: 20,),
                OurDisplayData(whereFrom: 'Hive', future: getVaulesFromHive()),
                SizedBox(height: 20,),
                OurDisplayData(whereFrom: 'Secure Storage', future: getVaulesFromSecureStorage()),
              ],
            ),
          ),
        ),
      )
    );
  }

  Future<Map<String, String?>> getVaulesFromSharedPreferences() async {
    SharedPreferencesAsync prefs = SharedPreferencesAsync();
    var data = {
      'email':  await prefs.getString('email'),
      'password':  await prefs.getString('password'),
    };
    return data;
  }

  Future<Map<String, String?>> getVaulesFromSqfLite() async {
    Database db = await openDatabase('our_database.db');
    List<Map<String, dynamic>> result = await db.query('user_data', columns: ['email', 'password']);
    var data = {
      'email':  result.isNotEmpty ? result.first['email'] as String? : null,
      'password':  result.isNotEmpty ? result.first['password'] as String? : null,
    };
    return data;
  }

  Future<Map<String, String?>> getVaulesFromHive() async {
    var box = await Hive.openBox('user_data');
    var data = {
      'email':  box.get('email') as String?,
      'password':  box.get('password') as String?,
    };
    return data;
  }

  Future<Map<String, String?>> getVaulesFromSecureStorage() async {
    const storage = FlutterSecureStorage();
    var data = {
      'email':  await storage.read(key: 'email'),
      'password':  await storage.read(key: 'password'),
    };
    return data;
  }
}
  