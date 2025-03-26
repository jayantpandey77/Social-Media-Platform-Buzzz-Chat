import 'package:buzzzchat/features/auth/controller.dart';
import 'package:buzzzchat/features/auth/widget/phone.dart';
import 'package:buzzzchat/features/auth/screen/signupscreen.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  Country? country;

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  void countryPicker() {
    showCountryPicker(
        context: context,
        onSelect: (Country ncountry) {
          setState(() {
            country = ncountry;
          });
        });
  }

  void login() {
    if (formkey.currentState!.validate()) {
      String mail = emailcontroller.text.trim();
      String password = passwordcontroller.text.trim();
      ref
          .read(authControllerProvider)
          .loginUserWithMail(context, mail, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 253, 216, 3),
            Color.fromARGB(255, 252, 127, 3)
          ])),
          child: Form(
            key: formkey,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(7),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(
                      //   height: height * 0.1,
                      // ),
                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                            fontSize: 50.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: height * 0.06,
                              ),
                              TextFormField(
                                  style: TextStyle(fontSize: height * 0.03),
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailcontroller,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: height * 0.018,
                                          horizontal: width * 0.02),
                                      icon: Icon(
                                        Icons.email,
                                        size: height * 0.04,
                                        color: Colors.black,
                                      ),
                                      hintText: "buzz@exmaple.com",
                                      hintStyle: TextStyle(
                                          fontSize: height * 0.02,
                                          fontWeight: FontWeight.w400)),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty ||
                                        !value.contains("@")) {
                                      return "Enter Valid Email Id";
                                    }
                                    return null;
                                  }),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  style: TextStyle(fontSize: height * 0.03),
                                  controller: passwordcontroller,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: height * 0.018,
                                          horizontal: width * 0.02),
                                      icon: Icon(
                                        Icons.security,
                                        size: height * 0.04,
                                        color: Colors.black,
                                      ),
                                      hintText: "********",
                                      hintStyle: TextStyle(
                                          fontSize: height * 0.02,
                                          fontWeight: FontWeight.w400)),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty ||
                                        value.trim().length <= 8) {
                                      return "Enter Valid Password";
                                    }
                                    return null;
                                  }),
                              Row(
                                children: [
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen(),
                                      ));
                                    },
                                    child: Text(
                                      "Forget Password",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                              color: const Color.fromARGB(
                                                  255, 73, 7, 255)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 9,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: height * 0.06,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 60),
                                child: ElevatedButton(
                                  onPressed: login,
                                  style: ElevatedButton.styleFrom(
                                      minimumSize:
                                          const Size(double.infinity, 32)),
                                  child: Padding(
                                    padding: EdgeInsets.all(width * 0.03),
                                    child: Text("Log In",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(color: Colors.black)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.015,
                              ),
                              Phone(),
                              SizedBox(
                                height: height * 0.05,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an Account ? ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.w400),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpScreen(),
                                        ));
                                      },
                                      child: Text(
                                        "SignUp",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromARGB(
                                                    255, 73, 7, 255)),
                                      ),
                                    ),
                                  ]),
                              SizedBox(
                                height: height * 0.06,
                              ),
                              Text(
                                "Sign Up using",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    child: CircleAvatar(
                                      foregroundImage:
                                          AssetImage("asset/images/apple.png"),
                                      radius: width * 0.06,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    child: CircleAvatar(
                                      foregroundImage:
                                          AssetImage("asset/images/face.png"),
                                      radius: width * 0.06,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Color.fromARGB(255, 255, 153, 64),
                                      foregroundImage:
                                          AssetImage("asset/images/goog.png"),
                                      radius: width * 0.06,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
