import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/screens/auth_screen.dart';
import 'package:imhotep/sign_up/sign_up.dart';
import 'package:imhotep/sign_up/verify_otp.dart';
import 'package:imhotep/widgets/button/button_icon_less.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  bool isChecked = false;

  abc() {}
  goToSignUp() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const SignUp();
    }));
  }

  void next() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return AuthScreen();
    }));
  }

  void back() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const VerifyOtp();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  bluegradientColor.withOpacity(1),
                  yellowgradientColor.withOpacity(1)
                ])),
            child: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration:
                    BoxDecoration(color: Colors.transparent.withOpacity(0.4)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: back,
                          child: const Icon(Icons.arrow_back,
                              color: whiteColor, size: 25),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          "Update Password",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: whiteColor),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 0,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'New Password',
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    color: whiteColor,
                                    border:
                                        Border.all(color: Colors.transparent)),
                                child: const TextField(
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      focusedBorder: InputBorder.none),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 0,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Confirm Password',
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    color: whiteColor,
                                    border:
                                        Border.all(color: Colors.transparent)),
                                child: const TextField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      focusedBorder: InputBorder.none),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ButtonIconLess('Update Password', blueColor,
                              blueColor, whiteColor, 1, 16, 16, next, 12),
                        ),
                      ]),
                ),
              ),
            )),
      ),
    );
  }
}
