import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: buildLoginScreen(context),
        ),
      ),
    );
  }
}

final TextEditingController _usernameController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

Widget buildLoginScreen(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  double fontSize = screenWidth > 600 ? 24 : 16;

  if (fontSize > 24) {
    fontSize = 24;
  } else if (fontSize < 16) {
    fontSize = 16;
  }

  final double textFieldWidth = screenWidth > 600 ? 400 : screenWidth - 40;

  return Scaffold(
    appBar: AppBar(
      title: Text('eCakeShop'),
      backgroundColor: Color.fromRGBO(97, 142, 246, 1),
    ),
    backgroundColor: Color.fromRGBO(222, 235, 251, 1),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: textFieldWidth,
            child: TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
              ),
              maxLines: 1,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: textFieldWidth,
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              maxLines: 1,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 48),
              backgroundColor: Color.fromRGBO(97, 142, 246, 1),
            ),
            child: Text(
              "Login",
              style: TextStyle(fontSize: fontSize),
            ),
          )
        ],
      ),
    ),
  );
}
