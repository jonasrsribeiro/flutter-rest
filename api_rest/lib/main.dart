import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> dataList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        dataList = jsonResponse;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: dataList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int index) {
                final item = dataList[index];

                // Alterna cores de fundo: azul claro para pares e azul escuro para ímpares
                final Color backgroundColor =
                    index % 2 == 0 ? Colors.lightBlue[100]! : Colors.blue[900]!;
                
                // Altera a cor do texto para branco no fundo azul escuro
                final Color textColor = index % 2 == 0 ? Colors.black : Colors.white;

                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: backgroundColor, // Cor de fundo alternada
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Text(
                      'Name: ${item['name']}',
                      style: TextStyle(color: textColor), // Cor do título
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email: ${item['email']}',
                          style: TextStyle(color: textColor), // Cor do subtítulo
                        ),
                        Text(
                          'Phone: ${item['phone']}',
                          style: TextStyle(color: textColor), // Cor do subtítulo
                        ),
                        Text(
                          'Website: ${item['website']}',
                          style: TextStyle(color: textColor), // Cor do subtítulo
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}