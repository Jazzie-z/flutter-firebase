import 'package:brew_crew/constants.dart';
import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final String hint, initialValue;
  final bool obscureText;
  final Function onChange, validator;

  const InputBox({Key key, this.hint, this.validator, this.onChange, this.obscureText=false, this.initialValue=''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: textInputDecoration.copyWith(
        hintText: hint,
      ),
      obscureText: obscureText,
      onChanged: onChange,
      validator: validator,
      initialValue: initialValue,
    );
  }
}
