import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_02/constants/constants.dart';
import 'package:firebase_flutter_02/screens/overview_screen.dart';
import 'package:form_validator/form_validator.dart';
import 'package:flutter_svg/svg.dart';

/*


*/

/*



<------Auth Screen Having Both SignUp and Login Screen + Authentication using Firebase--------->





*/

import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  ///////////// Change Quickly between Login and SignUp Screen //////////

  var _isLogin = true;

  // for Progress purpose
  var isLoading = false;

///////////////////////////////////  Text Editing Controller ////////////////////////

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  ///////////////////////////////////  Form Validator ////////////////////////

  final _emailValidator = ValidationBuilder().email().minLength(8).build();
  final _passwordValidator = ValidationBuilder().minLength(6).build();

  loginForm(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        setState(() {
          isLoading = false;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OverviewScreen()),
          );
        });
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          e.code,
          textAlign: TextAlign.center,
        )));
      }
    }
  }

  signUpForm(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        setState(() {
          isLoading = false;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OverviewScreen()),
          );
        });
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          e.code,
          textAlign: TextAlign.center,
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    const Text('Hi!', style: kHeadBottomTxtStyle),
                    SvgPicture.asset(
                      'assets/images/login.svg',
                      width: 175,
                      height: 175,
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              labelText: 'email'.toUpperCase(),
                              labelStyle: kFieldTxtStyle,
                              focusedBorder: kFieldBorderColor),
                          keyboardType: TextInputType.emailAddress,
                          validator: _emailValidator),
                      if (!_isLogin) const SizedBox(height: 20.0),
                      if (!_isLogin)
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'username'.toUpperCase(),
                              labelStyle: kFieldTxtStyle,
                              focusedBorder: kFieldBorderColor),
                        ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'PASSWORD'.toUpperCase(),
                            labelStyle: kFieldTxtStyle,
                            focusedBorder: kFieldBorderColor,
                          ),
                          obscureText: true,
                          validator: _passwordValidator),
                      const SizedBox(
                        height: 35,
                      ),
                      if (isLoading) const CircularProgressIndicator(),
                      if (!isLoading)
                        MaterialButton(
                          height: 57,
                          color: kBtnBgColor,
                          elevation: 10.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              _isLogin ? "Login" : "Sign up",
                              style: kBtnTxtStyle,
                            ),
                          ),
                            onPressed: () {
                            if (_isLogin) {
                              loginForm(_emailController.text,
                                  _passwordController.text);
                            }
                            else {
                              signUpForm(_emailController.text,
                                  _passwordController.text);
                            }
                          },
                        ),
                      const SizedBox(
                        height: 25,
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(40.0),
                        animationDuration: const Duration(seconds: 2),
                        color: Colors.white,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Center(
                            child: Text(
                                _isLogin
                                    ? "Create new account"
                                    : "I already have an account",
                                style:
                                    kHeadBottomTxtStyle.copyWith(fontSize: 22)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
