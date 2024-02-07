import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'fetching.dart';

Future<void> senddata(Map<String, String> data) async {
  // Your API endpoint URL
  String apiUrl = 'http://192.168.1.6:3000/adddata';
  print(data);
  try {
    // Make a POST request with the data
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      print('Data sent successfully');
      Fluttertoast.showToast(
        msg: "new note added",
        gravity: ToastGravity.CENTER,
      );
      // You can handle the response data if needed
      print('Response: ${response.body}');
    } else {
      print('Failed to send data. Status code: ${response.statusCode}');
      // You can handle the error response if needed
      print('Error: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

class addnewnotes extends StatefulWidget {
  const addnewnotes({Key? key}) : super(key: key);

  @override
  State<addnewnotes> createState() => _addnewnotesState();
}

class _addnewnotesState extends State<addnewnotes> {
  var textnote= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black26,
        scaffoldBackgroundColor: Colors.white24,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => fetchingdata()),);
            },
          ),
          title: Text('Add a new Note'),
          backgroundColor: Colors.black26,
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_upward_rounded),
              onPressed: () {
                String name = textnote.text ?? '';
                var data = {
                  "name" : name,
                };
                print('Sending data: $data');
                senddata(data);
                print('Settings button pressed');

              },
            ),
          ],
        ),
        body: Container(
          child: TextField(
            controller: textnote,
            decoration: const InputDecoration(
              hintText: "datahere",
              hintStyle: TextStyle(color: Colors.white38),
            ),
            style: TextStyle(color: Colors.white),
          ),
        ) ,
      ),
    );
  }
}
