import 'package:brew_crew/screens/authenticate/components/input_box.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign Up To Brew Crew'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: Icon(Icons.person),
              label: Text('Sign In'))
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                InputBox(
                  hint: 'Email',
                  onChange: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  validator: (value) => value.isEmpty ? 'Enter an email' : null,
                ),
                SizedBox(
                  height: 20.0,
                ),
                InputBox(
                  hint: 'Password',
                    obscureText:true,
                  onChange: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  validator: (value) =>
                  value.length < 6 ? 'Enter a password 6+ char long' : null,
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  color: Colors.pink[400],
                  child:
                      Text('Register', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result =
                          await _auth.registerWithEmailPass(email, password);
                      if (result == null) {
                        setState(() {
                          error = 'Something went wrong';
                        });
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(error, style: TextStyle(
                  color: Colors.red, fontSize: 14
                ),)
              ],
            ),
          )),
    );
    ;
  }
}
