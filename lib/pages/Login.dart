import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanum/utils/constant.dart';
import 'package:tanum/utils/helpers.dart';
import 'package:http/http.dart' as api;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? _email = "";
  String? _password = "";
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _login() async {

    try {
      setState(() {
        _isLoading = true;
      });

      var payload = {
        "email": _email,
        "password": _password,
      };

      var url = Helpers.getUrl('/api/login');

      var response = await api.post(url, body: payload);

      if (response.statusCode == 200) {
        Helpers.alert(context: context, message: "Login Success!");
        var body = jsonDecode(response.body);

        bool setted = await Helpers.setAuth(body);

        if (setted) {
          Helpers.alert(
              context: context, message: "welcome ${body['user']['name']}");

          Navigator.pushNamed(context, '/garden');
        }
      } else {
        Helpers.alert(
            context: context,
            message: "Failed to login, please check your email and password.");
      }
    } catch (e) {
      Helpers.alert(context: context, message: "$e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Helpers.loader(_isLoading),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const Icon(Icons.energy_savings_leaf,
                            color: Colors.green),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Login to Tanum!".toUpperCase(),
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        label: Text("Email"),
                        icon: Icon(Icons.email),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });
                      },
                      validator: (value) {
                        if (Helpers.required(value)) {
                          return null;
                        }

                        return "This field is required.";
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        label: Text("Password"),
                        icon: Icon(Icons.password),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                      validator: (value) {
                        if (Helpers.required(value)) {
                          return null;
                        }

                        return "This field is required.";
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // validate the form first
                          if (_formKey.currentState!.validate()) {
                            _login();
                          }

                          return null;
                        },
                        child: Text("LOGIN NOW"),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("or"),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/register");
                        },
                        child: Text("REGISTER NOW"),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
