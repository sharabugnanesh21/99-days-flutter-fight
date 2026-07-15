

import 'package:flutter/material.dart';

class OurDisplayData extends StatelessWidget {
  final Future<Map<String, String?>> future;
  final String whereFrom;
  const OurDisplayData({super.key, required this.future, required this.whereFrom});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.amber,
      child: FutureBuilder(
        future: future, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Column(
              children: [
                Text('$whereFrom: ', style: TextStyle(color: Colors.white),),
                SizedBox(height: 10),
                Text('Email: ${snapshot.data!['email'].toString()}'),
                Text('Password: ${snapshot.data!['password'].toString()}'),
              ],
            );
          }
        },
      ),
    );
  }
}