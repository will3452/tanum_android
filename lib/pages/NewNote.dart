import 'package:flutter/material.dart';
import 'package:tanum/utils/helpers.dart';
import 'package:http/http.dart' as api;
import '../utils/TitleHeader.dart';

class NewNote extends StatefulWidget {
  const NewNote({Key? key}) : super(key: key);

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final _formKey = GlobalKey<FormState>();
  String? _token;
  String? _title;
  String? _body;
  bool _isLoading = false;

  void _loadToken() async {
    String? token = await Helpers.getAuth(key: "bearerToken");
    setState(() {
      _token = token;
      // Helpers.alert(context: context, message: "$_token");
    });
  }

  void _submit() async {
    try {
      // validate the form first
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        var payload = {
          "title": _title,
          "body": _body,
        };
        print('payload >>  ${payload.toString()}');

        var url = Helpers.getUrl('api/diary');

        var response = await api.post(
          url,
          headers: {"Authorization": "Bearer $_token"},
          body: payload,
        );
        print("status >> ${response.statusCode} : $_token");
        print("body >> ${response.body}");
        if (response.statusCode == 201) {
          Helpers.alert(context: context, message: "Notes has been created!");
          print('pushed!');
          Navigator.pushNamed(context, '/diaries');
        } else {
          throw Exception("Failed to submit to server."); 
        }
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadToken();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        TitleHeader("New Notes"),
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Title"),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _title = value;
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
                  height: 10,
                ),
                TextFormField(
                  maxLines: null,
                  decoration: const InputDecoration(
                    label: Text("Body"),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _body = value;
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
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: const Text('Submit'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
