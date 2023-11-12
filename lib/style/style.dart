import 'package:flutter/material.dart';


TextStyle AppTextStyle(){
  return TextStyle(
    fontSize: 17,fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic
  );
}

InputDecoration TextFieldInputDecoration(label){
  return InputDecoration(
    labelText: label,

      filled: true,
      border: OutlineInputBorder(
      )
  );
}