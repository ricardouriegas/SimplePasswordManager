//running this app with --no-sound-null-safety
/*
Author: Ricardo Uriegas
 */

import 'dart:convert';
import 'dart:ui';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';


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

//create the secure storage
final storage = new FlutterSecureStorage();

Future saveSecureStorage (String key, String value) async {
  await storage.write(key: key, value: value);
}

Future readValueInSecureStorage (String key) async {
  //this should return an string the value
  return await storage.read(key: key);
}

Future deleteValueInSecureStorage (String key) async {
  await storage.delete(key: key);
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


/**
 * Login page: para entrar a ver la lista de contrasenas del usuario
 */
class _HomePageState extends State<HomePage> {
  @override
  //variable password writed on the text field
  final passwordTextField = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var valueMother;

    readValueInSecureStorage('mother_key').then(
            (value) {
          valueMother = value;
        });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Contraseña 😏'),
      ),

      body:Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          ListTile(
              title: Text(
                  'Contraseña',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize:50,
                    color: Colors.black,
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
              hintText: "Ingresar contraseña",
              hintStyle: TextStyle(color: Colors.grey),

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
              color: Colors.black,
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

                //saveSecureStorage('mother_key', passwordTextField.text);


                if(passwordTextField.text == '') {
                  //show alert when the password field its empty
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Creo que se le olvido escribir su '
                                        'contraseña'),
                      content: const Text('No puedo dejarlo pasar sin invitacion'
                                          ' 🙂'),

                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  if(valueMother == '' || valueMother == null){
                    // print(valueMother);
                    saveSecureStorage('mother_key', passwordTextField.text);
                  } else {
                    if(passwordTextField.text == valueMother.toString()){
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SecondRoute()),
                            (Route<dynamic> route) => false,
                      );
                    } else {

                      print('Valor de value mother: ' + valueMother.toString());

                      //contrasena incorrecta
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Contraseña incorrecta'),
                          content: const Text('No puedo dejarlo pasar sin invitacion 🙂'),

                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

}



ListTile tile(String title, String subtitle) {

  return ListTile(
    title: Text(title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text(subtitle),
    trailing: Icon(Icons.copy),
    onTap: () {
      Clipboard.setData(ClipboardData(text: subtitle));
    },
  );
}


setPassword() {
  //character is a variable to choose if use special character, number, mayus or minus
  int character = 1 + Random().nextInt(5 - 1);

  //here with the variable character i return the random type of character
  if (character == 1) {
    //special characters
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
String titulo = '';

//funcion crear contraseña
/**
 * Funcion para crear una contrasena
 * @return void
 * @param length longitud the la contrasena
 */
getPassword(int lenght) {
  for (var i = 0 ; i < lenght; i++) {
    //concatenate string
    password += String.fromCharCode(setPassword());
  }
  // print(password);
}

/**
 * Function to get all the data inside the storage and put it in a map
 */
Future<Map<String, String>> getAllList() async {
  return storage.readAll();
}


/**
 * Segunda ventana: lista de contrasenas
 */
class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // getAllList().then((s){
    //
    //     concatenate = concatenate + (key + '\n' + value + '\n');
    //
    //   });
    //   print('concatenao en then: ' + concatenate);
    // });
    // print ('cosa 2');

    String concatenate = '';
    Map<String, String> claves;

    final getKeyString = TextEditingController();


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Bienvenid@"),
      ),
      body:

      ListView(
        padding: EdgeInsets.all(10),
        children: [


          FutureBuilder (
              future: getAllList(),
              initialData: Text("Vacio"),

              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  claves = snapshot.data;
                  claves.forEach((key, value) {
                    // print(key);
                    concatenate += ('Titulo: ' + key + '\n' + 'Contraseña: ' + value + '\n\n');
                  });

                  return Text(concatenate);

                } else {
                  return Text('No contraseñeishon');
                }
              }
          ),
          
          Align(
            alignment: Alignment.bottomRight,

            child:FloatingActionButton(
              backgroundColor: Colors.cyan,
              child: const Icon(Icons.add),

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ThirdRoute()),
                );
              },
            ),
          ),


          const SizedBox(
            height: 12.0, //space bc it looks nashe
          ),

          TextField(
            controller: getKeyString,
            decoration: InputDecoration(

              //hint
              hintText: "Titulo para copiar al clipboard una contraseña",
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

          const SizedBox(
            height: 12.0, //space bc it looks nashe
          ),

          Align(
            alignment: Alignment.bottomRight,

            child:FloatingActionButton(
              backgroundColor: Colors.cyan,
              child: const Icon(Icons.copy_rounded),

              onPressed: () {
                if (getKeyString.text == '') {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Vacio? 🤔'),
                      content: const Text('No puedo copiar al ClipBoard si esta vacio 🙂'),

                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  /**
                   * Read some value from secure storage using the key string
                   */
                  readValueInSecureStorage(getKeyString.text).then((s){

                    if(s == null){
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Creo que hay algo mal con el titulo 🤔'),
                          content: const Text('Parece que el titulo puesto es incorrecto 🙂'),

                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      Clipboard.setData(ClipboardData(text: s));
                    }

                  });
                }
              },
            ),
          ),
        ],
      ),

    );
  }
}


/**
 * Tercera ventana: Agregar nueva contrasena
 */
class ThirdRoute extends StatelessWidget {

  //variables textfield
  final passwordTitle = TextEditingController();
  final passwordLength = TextEditingController();

  int lenghtChoose = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Generar Contraseña"),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          TextField(
            controller: passwordTitle,
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

          const SizedBox(
            height: 12.0, //space bc it looks nashe
          ),

          TextField(
            controller: passwordLength,
              keyboardType:
              TextInputType.numberWithOptions(signed: false, decimal: false),
            decoration: InputDecoration(

              //hint
              hintText: "Largo de la contraseña",
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
                lenghtChoose =  int.tryParse(passwordLength.text.toString())!;

                if(passwordTitle.text == '' || lenghtChoose.isNegative || lenghtChoose.isNaN){
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Vacio? 🤔'),
                      content: const Text('No puedo dejarlo pasar 🙂'),

                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  password != getPassword(lenghtChoose);

                  saveSecureStorage(passwordTitle.text, password);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SecondRoute()),
                        (Route<dynamic> route) => false,
                  );
                }

              },
            ),
          )

        ],
      ),

    );
  }
}
