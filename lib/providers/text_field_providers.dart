import 'package:flutter/material.dart';

// Define the ChangeNotifier class
class SignInDetailsProvider with ChangeNotifier {
  String _email = '';
  String  _password = '';

  
  String get email => _email;
  String get password => _password;

  
  set email(String value) {
    _email  = value;
    notifyListeners(); // Notify listeners when the value changes
  }
  set password(String value) {
    _password  = value;
    notifyListeners(); // Notify listeners when the value changes
  }
}
