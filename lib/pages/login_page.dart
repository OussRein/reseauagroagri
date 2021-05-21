import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

enum AuthMode { LOGIN, SIGNUP, FORGOTPASSWORD }

class AuthPage extends StatelessWidget {
  static const String ROUTE = '/auth';

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
                  Color.fromRGBO(63, 232, 122, 1).withOpacity(0.5),
                  Color.fromRGBO(114, 209, 183, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // transform how the container is presented / Matrix4 describe rotation, scaling and offset
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue.shade100,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'ReseauAgroagri.Com',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.black54),
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
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
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.LOGIN;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.LOGIN) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email'], _authData['password']);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email'], _authData['password']);
      }
    } catch (error) {
      var errorMessage = "Authentication failed - ";
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = "Email already exists";
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = "Email already exists";
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = "Your password is too weak";
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = "Email doesn't exist";
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = "Invalid password";
      } else {
        errorMessage =
            "Couldn't authenticate you, verify network and try again";
      }

      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  /*void _switchAuthMode() {
    if (_authMode == AuthMode.LOGIN) {
      setState(() {
        _authMode = AuthMode.SIGNUP;
      });
    } else {
      setState(() {
        _authMode = AuthMode.LOGIN;
      });
    }
  }*/

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    setState(() {
      _authMode = AuthMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    setState(() {
      _authMode = AuthMode.LOGIN;
    });
  }

  void _changeFormToPasswordReset() {
    _formKey.currentState.reset();
    setState(() {
      _authMode = AuthMode.FORGOTPASSWORD;
    });
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
        height: 400,
        constraints: BoxConstraints(minHeight: 360),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _showEmailInput(),
                /*TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),*/
                _showPasswordInput(),
                /*TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                if (_authMode == AuthMode.SIGNUP)
                  TextFormField(
                    enabled: _authMode == AuthMode.SIGNUP,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.SIGNUP
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),*/
                if (_isLoading) CircularProgressIndicator(),
                /*else
                  ElevatedButton(
                    child:
                        Text(_authMode == AuthMode.LOGIN ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                      foregroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryTextTheme.button.color),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                      //padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    ),
                  ),*/
                _showPrimaryButton(),
                _showSecondaryButton(),
                _showForgotPasswordButton(),
                /*TextButton(
                  child: Text(
                      "${_authMode == AuthMode.LOGIN ? "S'inscrire" : "Se connecter"}"),
                  onPressed: _switchAuthMode,
                  //padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor,
                    ),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _authData['email'] = value.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    if (_authMode != AuthMode.FORGOTPASSWORD) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'Password',
              icon: new Icon(
                Icons.lock,
                color: Colors.grey,
              )),
          validator: (value) =>
              value.isEmpty ? 'Le mot de passe ne peut pas etre vide' : null,
          onSaved: (value) => _authData['password'] = value.trim(),
        ),
      );
    } else {
      return new Text('Un mail vas etre envoyer a votre boite!');
    }
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.resolveWith<double>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) return 16;
                return null;
              }),
              foregroundColor: MaterialStateProperty.all(
                Theme.of(context).primaryColor,
              ),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )),
            ),
            child: _textPrimaryButton(),
            onPressed: _submit,
          ),
        ));
  }

  Widget _showSecondaryButton() {
    return new TextButton(
      child: _textSecondaryButton(),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
          Theme.of(context).primaryColor,
        ),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        )),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: _authMode == AuthMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
    );
  }

  Widget _showForgotPasswordButton() {
    return new TextButton(
      child: _authMode == AuthMode.LOGIN
          ? new Text(
              'Mot de passe oublié?',
              style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300),
            )
          : new Text(
              '',
              style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300),
            ),
      onPressed: _changeFormToPasswordReset,
    );
  }

  Widget _textPrimaryButton() {
    switch (_authMode) {
      case AuthMode.LOGIN:
        return new Text(
          'Login',
          style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        );
        break;
      case AuthMode.SIGNUP:
        return new Text(
          'Create account',
          style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        );
        break;
      case AuthMode.FORGOTPASSWORD:
        return new Text(
          'Reset password',
          style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        );
        break;
    }
    return new Spacer();
  }

  Widget _textSecondaryButton() {
    switch (_authMode) {
      case AuthMode.LOGIN:
        return new Text('Créer un compte!');
        break;
      case AuthMode.SIGNUP:
        return new Text('Vous avez deja un compte? Connectez-vous');
        break;
      case AuthMode.FORGOTPASSWORD:
        return new Text('Cancel');
        break;
    }
    return new Spacer();
  }
}
