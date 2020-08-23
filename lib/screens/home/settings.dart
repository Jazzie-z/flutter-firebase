import 'package:brew_crew/constants.dart';
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/authenticate/components/input_box.dart';
import 'package:brew_crew/screens/loading.dart';
import 'package:brew_crew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  String _currentname;
  String _currentSugar;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Update your brew strength',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  InputBox(
                      hint: 'Name',
                      onChange: (value) {
                        setState(() {
                          _currentname = value;
                        });
                      },
                      validator: (value) =>
                          value.isEmpty ? 'Enter a name' : null,
                      initialValue: userData.name),
                  SizedBox(
                    height: 20.0,
                  ),
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _currentSugar ?? userData.sugars,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                          value: sugar, child: Text('$sugar sugars'));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _currentSugar = val;
                      });
                    },
                  ),
                  Slider(
                    min: 100.0,
                    max: 900.0,
                    activeColor:
                        Colors.brown[_currentStrength ?? userData.strength],
                    inactiveColor:
                        Colors.brown[_currentStrength ?? userData.strength],
                    divisions: 8,
                    onChanged: (val) {
                      setState(() {
                        _currentStrength = val.round();
                      });
                    },
                    value: (_currentStrength ?? userData.strength).toDouble(),
                  ),
                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'UPDATE',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await DatabaseService(uid: userData.uid).updateUserData(
                            _currentSugar ?? userData.sugars,
                            _currentname ?? userData.name,
                            _currentStrength ?? userData.strength);
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
