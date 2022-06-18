//running this app with --no-sound-null-safety

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
  //this should return an string
  return await storage.read(key: key);
}

Future deleteValueInSecureStorage (String key) async {
  await storage.delete(key: key);
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}



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
      backgroundColor: Colors.black,
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

                //saveSecureStorage('mother_key', passwordTextField.text);


                if(passwordTextField.text == '') {
                  //show alert when the password field its empty
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Creo que se le olvido escribir su contraseña'),
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
                } else {
                  if(valueMother.toString() == ''){
                    print('null compayito');
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
String titulo = '';

//funcion crear contraseña
getPassword(int lenght) {
  for (var i = 0 ; i < lenght; i++) {
    //concatenate string
    password = password + String.fromCharCode(setPassword());
  }
  // print(password);
}

getAllList() async{
  Map<String, String> allValues = await storage.readAll();
  print('all values: '+ allValues.toString());
  return allValues;
}

RichText? generateList() {

  String concatenate = '';

  getAllList().then((s){
    s.forEach((key, value) {

      // print(key + '\n' + value);
      print('cosa 1');

      concatenate = concatenate + (key + '\n' + value + '\n');

    });
    print('concatenao en then: ' + concatenate);
    return RichText(
      text: TextSpan(
        text: concatenate,
      ),
    );
  });
  print ('cosa 2');


  print ('cosa 2');

}

// ListTile DataBase() {
//   getAllList().forEach((key, value) {
//     return tile(key, value);
// });
//
// }

// generateList() {
//
//   var concatenate = generateListthen();
//   print('list will return: ' + concatenate);
//   // print ('concatenao: ' + concatenate);
//
// }


//segunda ventana
/*
  REPEAT = FOR
 */
class SecondRoute extends StatelessWidget {
  //readValueInSecureStorage('arremangala').then((s){print(s);})



  @override
  Widget build(BuildContext context) {

    // String concatenate = '';
    //
    // getAllList().then((s){
    //   s.forEach((key, value) {
    //
    //     // print(key + '\n' + value);
    //     print('cosa 1');
    //
    //     concatenate = concatenate + (key + '\n' + value + '\n');
    //
    //   });
    //   print('concatenao en then: ' + concatenate);
    // });
    // print ('cosa 2');

    var list;
    @override
    void initState() {
      list != generateList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Bienvenid@"),
      ),


      body:
      ListView(
        padding: EdgeInsets.all(10),
        children: [

          tile('', 'password'),

          // list,




          Align(
            alignment: Alignment.bottomRight,

            child: FloatingActionButton(
              backgroundColor: Colors.cyan,
              child: const Icon(Icons.add),

              onPressed: () {

                // print(Lista);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ThirdRoute()),
                );
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
                  titulo != passwordTitle.text;
                  password != getPassword(lenghtChoose);

                  saveSecureStorage(titulo, password);

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
