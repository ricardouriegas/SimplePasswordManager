
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Contrasena'),
      ),
      body:
      Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        TextField(
          controller: TextEditingController(),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.blue
                )
            ),

            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.blue
                )
            ),
          ),

          style:TextStyle(
            color: Colors.white,
          ),
          keyboardType: TextInputType.text,
        ),

        const SizedBox(
          height: 12.0, //space bc it looks nashe
        ),

        FloatingActionButton(
          backgroundColor: Colors.cyan,
          child: const Icon(Icons.arrow_forward_ios_rounded),

          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondRoute()),
            );

          },
        ),
      ],
    ),

    );
  }

}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenid@"),
      ),
      body: Center(

      ),
    );
  }
}
