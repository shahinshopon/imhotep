import 'dart:async';
import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/sign_up/confirm_account.dart';
import 'package:imhotep/sign_up/update_password.dart';
import 'package:imhotep/widgets/button/button_icon_less.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({Key? key}) : super(key: key);

  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  String currentText = "";
  bool cont = false;

  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController = StreamController();

  void next() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const UpdatePassword();
    }));
  }

  void back() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const ConfirmAccount();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 22.0, horizontal: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: back,
                          child: const Icon(Icons.arrow_back,
                              color: whiteColor, size: 25)),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            "Confirm Your Account",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: whiteColor),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "A code has been sent to your phone number.Enter that code here",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: whiteColor),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 0,
                        ),
                        child: Column(
                          children: [
                            PinCodeTextField(
                              appContext: context,
                              keyboardType: TextInputType.number,
                              pastedTextStyle: TextStyle(
                                color: Colors.green.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                              cursorColor: blueColor,
                              enablePinAutofill: true,
                              length: 6,
                              obscureText: false,
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                activeColor: yellowgradientColor,
                                selectedColor: blueColor,
                                inactiveColor: whiteColor,
                                inactiveFillColor: Colors.white,
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 55,
                                fieldWidth: 40,
                                activeFillColor: Colors.white,
                              ),
                              errorAnimationController: errorController,
                              controller: textEditingController,
                              animationDuration: Duration(milliseconds: 300),
                              enableActiveFill: false,
                              onCompleted: (v) {
                                print("Completed");
                              },
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  currentText = value;
                                  value.length == 6
                                      ? cont = true
                                      : cont = false;
                                });
                              },
                              beforeTextPaste: (text) {
                                print("Allowing to paste $text");
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20),
                        child: ButtonIconLess('Verify', blueColor, blueColor,
                            whiteColor, 1, 16, 20, next, 12),
                      ),
                      Center(
                        child: Column(
                          children: const [
                            Text(
                              "Didn't recieve a verification code ?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: whiteColor),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Resend code Or Change Number",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: yellowgradientColor),
                            ),
                          ],
                        ),
                      )

                      //const SizedBox(height: 10,),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
