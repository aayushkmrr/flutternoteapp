import 'package:finalnotesapp/addingnotes.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


Future<List<String>> fetchData() async {
  final apiUrl = 'http://192.168.1.6:3000/getdata'; // Replace with your actual API endpoint
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    // Parse the JSON response and extract the "name" fields
    List<dynamic> data = jsonDecode(response.body);
    print(data);
    List<String> names = data.map((item) => item['name'].toString()).toList();
    print(names);
    return names;
  } else {
    // Handle error
    throw Exception('Failed to load data');
  }
}


Future<void> deletePerson(String name) async {
  final apiUrl = 'http://192.168.1.6:3000/deletepeople/$name';

  try {
    final response = await http.delete(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      print('Person deleted successfully');
      // Refresh the page after deletion


    } else {
      print('Error deleting person: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

class fetchingdata extends StatefulWidget {
  const fetchingdata({Key? key}) : super(key: key);

  @override
  State<fetchingdata> createState() => _fetchingdataState();
}

class _fetchingdataState extends State<fetchingdata> {
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
          title: Text('Notes'),
          backgroundColor: Colors.black26,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => addnewnotes()),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder(
            future: fetchData(),
            builder: (context,snapshot){
         if (snapshot.connectionState == ConnectionState.waiting) {
             return Center(child: CircularProgressIndicator());
         } else if (snapshot.hasError) {
             return Center(child: Text('Error: ${snapshot.error}'));
         } else {

    // Use the retrieved names to build containers
              List<String> names = snapshot.data as List<String>;
               return ListView.builder(

               itemCount: names.length,
               itemBuilder: (context, index) {
               return Container(
                 padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 3.0),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                   color: Colors.black26
                 ),
                 child: ListTile(
                   iconColor: Colors.white54,
                   textColor: Colors.white,
                  title: Text(' ${names[index]}'),
                  trailing: IconButton(
                   color: Colors.white54.withOpacity(0.2),
                   icon: Icon(Icons.delete),
                      onPressed: () {
                       deletePerson(names[index]);
                       Navigator.push(context,MaterialPageRoute(
                                      builder:(context) => fetchingdata()),);},
                                      ),
                                ),
               );
                        },
                     );
                  }
              },
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context) => fetchingdata()),);
          },
          child: Icon(Icons.refresh_rounded),
          backgroundColor: Colors.black26,

        ),
        

      ));
  }
}
