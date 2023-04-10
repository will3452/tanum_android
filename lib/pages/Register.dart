import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tanum/utils/constant.dart';
import 'package:tanum/utils/helpers.dart';
import "package:http/http.dart" as api;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? _email = "";
  String? _password = "";
  String? _name = "";
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;


  void _register() async {
    var payload = {
      "email": _email,
      "name": _name,
      "password": _password,
    };

    setState(() {
      _isLoading = true;
    });

    var url = Helpers.getUrl('/api/register');

    var response = await api.post(url, body: payload);

    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration sucess! You may now login.")),
      );

      Navigator.pushNamed(context, '/'); // go to login
    } else {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(body['message']),backgroundColor: Colors.red),
      );
    }

    print(payload.toString());
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
                        const Icon(Icons.energy_savings_leaf, color: Colors.green),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Register to Tanum!".toUpperCase(),
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
                        label: Text("Name"),
                        icon: Icon(Icons.person),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _name = value;
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

                        onPressed: _isLoading ? null:() {
                          // validate the form first
                          if (_formKey.currentState!.validate()) {
                            _register();
                          } else {
                            print("the form is not valid!");
                          }
                        },

                        child: Text("REGISTER NOW"),
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
                          Navigator.pushNamed(context, '/');
                        },
                        child: const Text("AlREADY HAVE AN ACCOUNT?"),
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
