import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
 

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String _token = '';
  String responseText = "";
  int responError = 0;

  Future<void> _login() async {
    responseText = '';
    var username = _usernameController.text;
    var password = _passwordController.text;

    if (username == "" || password == "") {
    setState(() {
      responError = 255;
      responseText= "Přihlašovací údaje jsou prázdné";
    });
    return;
  }

    var apiUrl = 'https://stis.starnet.cz/api-token/create';
    Map<String, dynamic> body = {
      'api_login_form': {
        'username': username,
        'password': password,
        'attr': {
          'androidOsVersion': '9.1',
          'appTechnikVersion': '1.23',
          'imei': '1246543365434',
        },
      },
    };

    Map<String, String> headers = {
      'Accept': 'application/stis+json;version=1',
      'Content-Type': 'application/json',
    };

    try {
      final response = await Dio().post(
        apiUrl,
        data: body,
        options: Options(
          headers: headers,
        ),
       );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
           _token = data['token'];
          responseText = "Token: $_token";
          responError = 0;
          FocusScope.of(context).requestFocus(FocusNode());
        });
      }
      else {
        // Handle other status codes
        setState(() {
          responError = 255;
          responseText = 'Nepodařilo se přihlásit'; // Generic error message
          _token = '';
        });
      }
    } catch (error) {
      // ignore: avoid_print
      print('Chyba při volání API: $error');
      setState(() {
        responError = 255;
        responseText = 'Nepodařilo se přihlásit'; // Display error message if there's any exception
        _token = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
                const SizedBox(height: 50),

                Text("Login",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(fontSize: 50, fontWeight: FontWeight.w500, color: Colors.red)),

                const SizedBox(height: 15),

                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(255, 57, 57, 0.94), width: 2)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(255, 57, 57, 0.94), width: 3)),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Username",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),

                const SizedBox(height: 10),

                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(255, 57, 57, 0.94), width: 2)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(255, 57, 57, 0.94), width: 3)),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Password",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              obscureText: true,
            ),

            const SizedBox(height: 16.0),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: _login,
              child: const
                Text('Přihlásit se'),
            ),

            const SizedBox(height: 15),

            SelectableText(
              responseText,
              style: TextStyle(
              fontSize:12,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(responError,0,0,1)

              ),
            ),
          ],
        ),
      ),
    );
  }
}
