import 'package:brew_crew/screens/authenticate/components/input_box.dart';
import 'package:brew_crew/screens/loading.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Sign In To Brew Crew'),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person),
                    label: Text('Register'))
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
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
                          validator: (value) =>
                              value.isEmpty ? 'Enter an email' : null,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        InputBox(
                          hint: 'Password',
                          obscureText: true,
                          onChange: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          validator: (value) => value.length < 6
                              ? 'Enter a password 6+ char long'
                              : null,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        RaisedButton(
                          color: Colors.pink[400],
                          child: Text('Sign in',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result =
                                  await _auth.signIn(email, password);
                              if (result == null) {
                                setState(() {
                                  error = 'Something went wrong';
                                  loading = false;
                                });
                                print(result);
                              }
                            }
                          },
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          child: Text('Sign in with Google', style: TextStyle(color: Colors.white)),
                          onPressed: (){
                            _auth.signInWithGoogle();
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        )
                      ],
                    ),
                  )),
            ),
          );
  }
}
