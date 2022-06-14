import 'dart:convert';
import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

int id = 1;
String title = 'Crear contraseña';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

Future<void> guardar(String id, String data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('uno', 'segunda cosa guardada');
}

class _HomePageState extends State<HomePage> {

  //variable password writed on the text field
  final passwordTextField = TextEditingController();
  String password = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Contraseña 😏'),
      ),

      body:

        Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          ListTile(
              title: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize:50,
                    color: Colors.white,
                  )
              ),
            ),


          Padding(padding: EdgeInsets.all(12),),

          TextField(
            //los puntos que se usan en las contraseñas
            obscureText: true,

            controller: passwordTextField,
            decoration: InputDecoration(

              //hint
              hintText: "Contraseña",
              hintStyle: TextStyle(color: Colors.white54),

              //bordes
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

          // GridView.count(crossAxisCount: crossAxisCount),

          Padding(padding: EdgeInsets.all(12),),
          Align(

            alignment: Alignment.bottomRight,

            child: FloatingActionButton(

              backgroundColor: Colors.cyan,
              child: const Icon(Icons.arrow_forward_ios_rounded),

              onPressed: () {
                password = passwordTextField.text;

                //funcion guardar shared_preferences
                guardar(id.toString() ,password);

                if(password == '') {
                  print('A te bañaste');
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SecondRoute()),
                        (Route<dynamic> route) => false,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

}


ListTile tile(String title, String subtitle, IconData icon) {
  return ListTile(
    title: Text(title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text(subtitle),
    trailing: Icon(icon),
    onTap: () {
      Clipboard.setData(ClipboardData(text: subtitle));
    },
  );
}


//aqui trato de obtener string
Future<String?> getStringValuesSF() async {
  late final String variableParaString;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  variableParaString = (await prefs.getString('uno'))!;
  print(variableParaString);
  return variableParaString.toString();
}

setPassword() {
  //character is a varaible to choose if use special character, number, mayus or minus
  int character = 1 + Random().nextInt(5 - 1);

  //here with the variable character i return the random type of character
  if (character == 1) {
    //special charactes
    return 33 + Random().nextInt(39 - 33);
  } else if (character == 2) {
    //numbers
    return 48 + Random().nextInt(58 - 48);
  } else if (character == 3) {
    //mayus letters
    return 64 + Random().nextInt(91 - 64);
  } else if (character == 4) {
    //minus letters
    return 97 + Random().nextInt(123 - 97);
  }
}

String password = '';
//funcion crear contraseña
getPassword(int lenght) {


  // String password = String.fromCharCode(specialCharacters) + String.fromCharCode(numbers) + String.fromCharCode(mayus) + String.fromCharCode(minus);


  for (var i = 0 ; i < lenght; i++) {
    //concatenate string
    password = password + String.fromCharCode(setPassword());
  }
  print(password);

}

//segunda ventana
/*
  REPEAT = FOR
 */
class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Bienvenid@"),
      ),

      body:

      ListView(
        padding: EdgeInsets.all(10),
        children: [

          tile('Facebook', 'asd', Icons.copy),


          //
          tile(getStringValuesSF().toString(), 'asd', Icons.copy),

          Align(
            alignment: Alignment.bottomRight,

            child: FloatingActionButton(
              backgroundColor: Colors.cyan,
              child: const Icon(Icons.add),

              onPressed: () {
                getPassword(500);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ThirdRoute()),
                // );
              },
            ),
          )
        ],
      ),
    );
  }
}


//tercera ventana
class ThirdRoute extends StatelessWidget {

  //variables textfield
  final passwordTextField = TextEditingController();
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Generar Contraseña"),
      ),

      body:


      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: TextEditingController(),
            decoration: InputDecoration(

              //hint
              hintText: "Titulo Para La Contraseña",
              hintStyle: TextStyle(color: Colors.grey),

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
              color: Colors.black,
            ),
            keyboardType: TextInputType.text,
          ),



          ListTile(
            title: Text("Arre 1"),
            leading: Radio(
              value: 1,
              groupValue: -1,
              onChanged: (value) {

              },
              activeColor: Colors.blue,
            ),
          ),

          ListTile(
            title: Text("Arre 2"),
            leading: Radio(
              value: 2,
              groupValue: 1,
              onChanged: (value) {

              },
              activeColor: Colors.blue,
            ),
          ),

          const SizedBox(
            height: 12.0, //space bc it looks nashe
          ),


          Align(
            alignment: Alignment.bottomRight,

            child: FloatingActionButton(
              backgroundColor: Colors.cyan,
              child: const Icon(Icons.arrow_forward_ios_rounded),

              onPressed: () {
                getPassword(2);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SecondRoute()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          )

        ],
      ),

    );
  }
}
