// ignore_for_file: avoid_print

import 'package:basic_app/day_99/dashboard_screen.dart';
import 'package:basic_app/day_99/button.dart';
import 'package:basic_app/day_99/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final testController = TextEditingController();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OurTextFormField(
                controller: emailController,
                label: 'Email',
                validator:(value) {
                  return RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(value ?? '') ? null : 'Enter a valid email';
                },
              ),

              SizedBox(height: 20),

              OurTextFormField(
                controller: passwordController,
                isObscureText: true,
                label: 'Password',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),
              
              // TextFormField(
              //   controller: testController,
              //   validator:(value) {
              //     return RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(value ?? '') ? null : 'Enter a valid email';
              //   },
              //   inputFormatters: [
              //     FilteringTextInputFormatter.deny(RegExp(r'\s')),
              //   ]
              // ),

              SizedBox(height: 20),

              OurButton(
                onPressed: () async {
                  // formKey.currentState!.validate();
                  print('Login button pressed');
                  print(emailController.text);
                  print(passwordController.text);
                  print(testController.text);

                  if (formKey.currentState!.validate()) {
                    print('Form is valid');

                    await saveToSharedPreferences(emailController.text, passwordController.text);
                    await saveToSqfLitePreferences(emailController.text, passwordController.text);
                    await saveToHive(emailController.text, passwordController.text);
                    await saveToSecureStorage(emailController.text, passwordController.text);

                    if (!context.mounted) return;
                    Navigator.pushReplacement(context, MaterialPageRoute<void>(
                      builder: (BuildContext context) => const OurDashbaord(),
                    ));
                  } else {
                    print('Form is invalid');
                    // return;
                  }

                },
              ),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveToSharedPreferences(String email, String password) async {
    SharedPreferencesAsync prefs = SharedPreferencesAsync();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Future<void> saveToSqfLitePreferences(String email, String password) async {
    Database myDB = await openDatabase(
      'our_database.db',
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS user_data(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT)',
        );
      },
    );
    
    await myDB.insert('user_data', {
      'email': email,
      'password': password,
    });
  }

  Future<void> saveToHive(String email, String password) async {
    var box = await Hive.openBox('user_data');
    await box.put('email', email);
    await box.put('password', password);
  }

  Future<void> saveToSecureStorage(String email, String password) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'password', value: password);
  }
}
