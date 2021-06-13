import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reseau_agroagri_app/services/base_auth.dart';

enum AuthMode { LOGIN, SIGNUP, FORGOTPASSWORD }

class AuthPage extends StatelessWidget {
  static const String ROUTE = '/auth';

  @override
  Widget build(BuildContext context) {
    //final deviceSize = MediaQuery.of(context).size;

    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return AuthCard();
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.LOGIN;
  final FireAuth _auth = new FireAuth();
  Map<String, String> _authData = {
    'username': '',
    'email': '',
    'password': '',
  };
  AnimationController _loginButtonController;
  var animationStatus = 0;

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);

    buttonSqueezeanimation = new Tween(
      begin: 320.0,
      end: 70.0,
    ).animate(
      new CurvedAnimation(
        parent: _loginButtonController,
        curve: new Interval(
          0.0,
          0.150,
        ),
      ),
    );
    containerCircleAnimation = new EdgeInsetsTween(
      begin: EdgeInsets.only(top: 20),
      end: const EdgeInsets.only(top: 0.0),
    ).animate(
      new CurvedAnimation(
        parent: _loginButtonController,
        curve: new Interval(
          0.520,
          0.999,
          curve: Curves.ease,
        ),
      ),
    );
  }

  Animation<EdgeInsets> containerCircleAnimation;
  Animation buttonSqueezeanimation;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return new Padding(
      padding: EdgeInsets.only(top: 20),
      child: new InkWell(
        onTap: () {
          _playAnimation();
        },
        child: new Hero(
          tag: "fade",
          child: Container(
            width: buttonSqueezeanimation.value,
            height: 60.0,
            alignment: FractionalOffset.center,
            decoration: new BoxDecoration(
              color: const Color.fromRGBO(247, 64, 106, 1.0),
              borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
            ),
            child: buttonSqueezeanimation.value > 75.0
                ? _textPrimaryButton()
                : new CircularProgressIndicator(
                    value: null,
                    strokeWidth: 1.0,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
          ),
        ),
      ),
    );
  }

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
      print('NOOOOO');
      return;
    }
    String userId = "";
    FocusScope.of(context).unfocus();
    _formKey.currentState.save();
    setState(() {
      animationStatus = 1;
    });
    _playAnimation();

    try {
      if (_authMode == AuthMode.LOGIN) {
        userId = await _auth.signIn(_authData['email'], _authData['password']);
        //await Provider.of<Auth>(context, listen: false).login(_authData['email'], _authData['password']);
      } else if (_authMode == AuthMode.SIGNUP) {
        userId = await _auth.signUp(
            _authData['email'], _authData['password'], _authData['username']);
        //await Provider.of<Auth>(context, listen: false).signup(_authData['email'], _authData['password']);
      } else {
        _auth.sendPasswordReset(_authData['email']);
        _showPasswordEmailSentDialog();
      }
    } catch (error) {
      print(error.toString());
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
      setState(() {
        animationStatus = 0;
      });
      _showErrorDialog(errorMessage);
    }

    if (userId.length > 0 && userId != null && _authMode == AuthMode.LOGIN) {}
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

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
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Background.webp'),
          fit: BoxFit.cover,
        ),
      ),
      child: new BackdropFilter(
        filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: new Container(
          decoration: new BoxDecoration(color: Colors.white.withOpacity(0.2)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200,
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top +
                            AppBar().preferredSize.height,
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
                      child: Image(
                        image: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, right: 20.0, left: 20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _showUserNameInput(),
                          _showEmailInput(),
                          _showPasswordInput(),
                        ],
                      ),
                    ),
                  ),
                  animationStatus == 0
                      ? new Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: new InkWell(
                            onTap: _submit,
                            child: _showPrimaryButton(),
                          ),
                        )
                      : new AnimatedBuilder(
                          builder: _buildAnimation,
                          animation: _loginButtonController,
                        ),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 10, right: 20.0, left: 20.0),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _showSecondaryButton(),
                            _showForgotPasswordButton(),
                          ])),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _showUserNameInput() {
    return Offstage(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: new InputDecoration(
            hintStyle: GoogleFonts.openSans(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 16,
            color: Colors.white,
            shadows: [
              Shadow(color: Colors.black, offset: Offset.zero, blurRadius: 20.0)
            ],
          ),
              errorStyle: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 14,
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                shadows: [
                  Shadow(
                      color: Colors.black,
                      offset: Offset.zero,
                      blurRadius: 40.0)
                ],
              ),
              hintText: 'Nom d\'utilisateur',
              icon: new Icon(
                Icons.mail,
                color: Colors.grey,
              )),
          validator: (value) {
            if ((value.length < 5 || value.isEmpty) &&
                _authMode == AuthMode.SIGNUP) {
              return 'Le nom d\'utilisateur n\'est pas valide!';
            } else {
              return null;
            }
          },
          onSaved: (value) => _authData['username'] = value.trim(),
        ),
      ),
      offstage: _authMode != AuthMode.SIGNUP,
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
          
          hintStyle: GoogleFonts.openSans(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 16,
            color: Colors.white,
            shadows: [
              Shadow(color: Colors.black, offset: Offset.zero, blurRadius: 20.0)
            ],
          ),
          errorStyle: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            shadows: [
              Shadow(color: Colors.black, offset: Offset.zero, blurRadius: 40.0)
            ],
          ),
          hintText: 'Email',
          icon: new Icon(
            Icons.mail,
            color: Colors.green.shade400,
          ),
        ),
        validator: (value) {
          if (!value.contains('@') || value.isEmpty) {
            return 'L\'addresse n\'est pas valide!';
          } else {
            return null;
          }
        },
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
            hintStyle: GoogleFonts.openSans(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 16,
            color: Colors.white,
            shadows: [
              Shadow(color: Colors.black, offset: Offset.zero, blurRadius: 20.0)
            ],
          ),
              errorStyle: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 14,
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                shadows: [
                  Shadow(
                      color: Colors.black,
                      offset: Offset.zero,
                      blurRadius: 40.0)
                ],
              ),
              hintText: 'Password',
              icon: new Icon(
                Icons.lock,
                color: Colors.green.shade400,
              )),
          validator: (value) =>
              value.isEmpty ? 'Le mot de passe ne peut pas etre vide' : null,
          onSaved: (value) => _authData['password'] = value.trim(),
        ),
      );
    } else {
      return new Text('Un mail vas etre envoyer a votre boite!', style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 16,
                color: Colors.green,
                fontStyle: FontStyle.italic,
                shadows: [
                  Shadow(
                      color: Colors.black,
                      offset: Offset.zero,
                      blurRadius: 80.0)
                ],
              ),);
    }
  }

  Widget _showPrimaryButton() {
    return new Container(
      width: 300.0,
      height: 50.0,
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: const Color.fromRGBO(247, 64, 106, 1.0),
        borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
      ),
      child: _textPrimaryButton(),
    );
    /*return new Padding(
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
        ));*/
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
    return Offstage(
      offstage: _authMode != AuthMode.LOGIN,
      child: TextButton(
        onPressed: _changeFormToPasswordReset,
        child: Text(
          'Mot de passe oublié?',
          style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            shadows: [
              Shadow(color: Colors.black, offset: Offset.zero, blurRadius: 20.0)
            ],
          ),
        ),
      ),
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
        return new Text(
          'Créer un compte!',
          style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            shadows: [
              Shadow(color: Colors.black, offset: Offset.zero, blurRadius: 20.0)
            ],
          ),
        );
        break;
      case AuthMode.SIGNUP:
        return new Text(
          'Vous avez deja un compte? Connectez-vous',
          style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 17,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            shadows: [
              Shadow(color: Colors.black, offset: Offset.zero, blurRadius: 20.0)
            ],
          ),
        );
        break;
      case AuthMode.FORGOTPASSWORD:
        return new Text(
          'Cancel',
          style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            shadows: [
              Shadow(color: Colors.black, offset: Offset.zero, blurRadius: 20.0)
            ],
          ),
        );
        break;
    }
    return new Spacer();
  }

  void _showPasswordEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Forgot your password"),
          content: new Text("An email has been sent to reset your password"),
          actions: <Widget>[
            new TextButton(
              child: new Text("Dismiss"),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
