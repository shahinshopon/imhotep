import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/screens/auth_screen.dart';
import 'package:imhotep/sign_up/verify_otp.dart';
import 'package:imhotep/widgets/button/button_icon_less.dart';

class ConfirmAccount extends StatefulWidget {
  const ConfirmAccount({Key? key}) : super(key: key);

  @override
  _ConfirmAccountState createState() => _ConfirmAccountState();
}

class _ConfirmAccountState extends State<ConfirmAccount> {
  void next() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return VerifyOtp();
    }));
  }

  void back() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return AuthScreen();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: barColor,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: SingleChildScrollView(
        child: SafeArea(
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
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration:
                  BoxDecoration(color: Colors.transparent.withOpacity(0.4)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 22.0, horizontal: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: back,
                        child:
                            Icon(Icons.arrow_back, color: whiteColor, size: 25),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Confirm Your Account",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: whiteColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "we'll send you a code to confirm this account is yours",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: whiteColor,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 0,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Email/Phone Number',
                                style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: whiteColor,
                                  border:
                                      Border.all(color: Colors.transparent)),
                              child: TextField(
                                decoration: InputDecoration(
                                    focusedBorder: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 40),
                        child: ButtonIconLess('Reset', blueColor, blueColor,
                            whiteColor, 1, 16, 20, next, 12),
                      ),

                      // SizedBox(height: 10,),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
