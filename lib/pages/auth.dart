import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/http_exception.dart';
import 'package:shop/pages/product_overview.dart';
import 'package:shop/providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthPage extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context, 
      builder: (ctx) => 
        AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(), 
              child: const Text('OK')
            )
          ],
        )
    );
  }

  Future<void> _submit() async {
    try {
      if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
      }
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).login(_authData['email']!, _authData['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false).singUp(_authData['email']!, _authData['password']!);
      }
      Navigator.of(context).pushReplacementNamed(ProductOverview.routeName);
    } on HttpException catch(err) {
      String message = 'Authentication failed';
      if(err.toString().contains('EMAIL_EXISTS')) {
        message = 'This email address is already in use.';
      } else if(err.toString().contains('INVALID_EMAIL')) {
        message = 'This is not a valid email address.';
      } else if (err.toString().contains('WEAK_PASSWORD')) {
        message = 'This password is too weak.';
      } else if(err.toString().contains('EMAIL_NOT_FOUND')) {
        message = 'Could not find a user with that email.';
      } else if(err.toString().contains('INVALID_PASSWORD')) {
        message = 'Invalid password.';
      }
      _showErrorDialog(message);
    } catch (err) {
        const message = 'Could not authenticate you. Please truy again later.';
        _showErrorDialog(message);
    }

    setState(() {
        _isLoading = false;
      });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value!.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null; 
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 8) {
                      return 'Weak password!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.Signup) 
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ButtonStyle(
                      foregroundColor: const MaterialStatePropertyAll(Colors.white),
                      shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )
                      ),
                      backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
                      padding: const MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0)
                      )
                    ),
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4)
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: MaterialStatePropertyAll(
                      TextStyle(
                        color: Theme.of(context).primaryColor
                      )
                     ),
                  ),
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
