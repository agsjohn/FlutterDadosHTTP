import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<List<dynamic>> fetchUsers() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/users');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    print('Resposta: ${response.body}');
    return jsonDecode(response.body);
  } else {
    print('Erro: ${response.statusCode}');
    {
      throw Exception('Failed to load data');
    }
  }
}

class _MyHomePageState extends State<MyHomePage> {
  String email = "";
  String phone = "";
  String address = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dados utilizando requisições HTTP'),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: fetchUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else {
              // ListView.builder(
              //   itemBuilder: (BuildContext context, int index) {

              //   }
              final data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  email = data[index]['email'];
                  phone = data[index]['phone'];
                  address = data[index]['address']['zipcode'];
                  return ListTile(
                    title: Text(data[index]['name']),
                    subtitle: Text(
                        'Email: $email \nNúmero: $phone\nCódigo postal: $address'),
                  );
                },
              );
            }
          },
        ));
  }
}
