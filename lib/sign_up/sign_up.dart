import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/screens/home_screen.dart';
import 'package:imhotep/viewmodels/auth_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/button/button_icon_less.dart';
import 'package:imhotep/widgets/new_text_field.dart';
import 'package:imhotep/widgets/text_field_with_icon.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  goToHome() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return HomeScreen();
    }));
  }

  abc() {}
  @override
  Widget build(BuildContext context) {
    return VMProvider<AuthVm>(
      vm: AuthVm(context),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  bluegradientColor.withOpacity(0.8),
                  yellowgradientColor.withOpacity(0.5)
                ],
              ),
            ),
            child: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.transparent.withOpacity(0.4),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (appUser == null) {
                            Navigator.pop(context);
                          } else {
                            vm.logOut();
                          }
                        },
                        icon: Icon(Icons.arrow_back_rounded),
                        color: whiteColor,
                      ),
                      NewTextField(
                        'Name',
                        '',
                        controller: vm.nameController,
                      ),
                      if (appUser == null)
                        NewTextField(
                          'Email Address',
                          '',
                          controller: vm.emailController,
                        ),
                      if (appUser == null)
                        NewTextField(
                          'Password',
                          '',
                          controller: vm.passwordController,
                        ),
                      NewTextField(
                        'Phone Number',
                        '',
                        controller: vm.phoneController,
                      ),
                      TextFieldWithIcon(
                        'Country',
                        '  Tap to select Country',
                        Icons.location_city_outlined,
                        onCountrySelect: vm.updateCountry,
                      ),
                      NewTextField(
                        'Bio',
                        '  Write few lines about you',
                        controller: vm.bioController,
                      ),
                      TextFieldWithIcon(
                        'Upload Profile Image',
                        '  Tap to upload image',
                        Icons.upload,
                        onImageSelect: vm.updateProfileImage,
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ButtonIconLess(
                          appUser == null ? 'Sign Up' : 'Continue',
                          blueColor,
                          blueColor,
                          whiteColor,
                          1,
                          16,
                          20,
                          appUser == null
                              ? vm.signUpWithEmailAndPassword
                              : () => vm.updateUserDetails(appUser),
                          12,
                          loading: appUser == null
                              ? vm.stateType == StateType.busy
                              : vm.loadingGLogin,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (appUser == null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an Account?",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.05,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: bluegradientColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
