import 'package:dits/controller/signup_controller.dart';
import 'package:dits/model/signup_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dits/view/common/header.dart';
import 'package:dits/view/common/heading.dart';
import 'package:dits/view/login.dart';
import 'package:dits/view/common/custom_form_button.dart';
import 'package:dits/view/common/custom_input_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _signupFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isValidMobileNumber(String input) {
    // Regular expression to match a 10-digit mobile number
    final RegExp mobileRegExp = RegExp(r'^\d{10}$');
    return mobileRegExp.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Form(
                key: _signupFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const PageHeader(),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          const PageHeading(
                            title: 'Sign-up',
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomInputField(
                            controller: _nameController,
                            labelText: 'Name',
                            hintText: 'Your name',
                            maxLength: 28,
                            keyboardType: TextInputType.text,
                            isDense: true,
                            validator: (textValue) {
                              if (textValue == null || textValue.isEmpty) {
                                return 'Name field is required!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomInputField(
                            controller: _mobileNumberController,
                            labelText: 'Mobile no.',
                            hintText: 'Your mobile number',
                            maxLength: 10,
                            keyboardType: TextInputType.phone,
                            isDense: true,
                            validator: (textValue) {
                              if (textValue == null || textValue.isEmpty) {
                                return 'Mobile number is required!';
                              }
                              if (!isValidMobileNumber(textValue)) {
                                return 'Please enter a valid 10-digit mobile number';
                              }
                              return null;
                            },
                          ),
                          CustomInputField(
                              controller: _emailController,
                              labelText: 'Email',
                              hintText: 'Your email id',
                              maxLength: 30,
                              keyboardType: TextInputType.emailAddress,
                              isDense: true,
                              validator: (textValue) {
                                if (textValue == null || textValue.isEmpty) {
                                  return 'Email is required!';
                                }
                                if (!EmailValidator.validate(textValue)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              }),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomInputField(
                            controller: _passwordController,
                            labelText: 'Password',
                            hintText: 'Create Your password',
                            maxLength: 14,
                            keyboardType: TextInputType.visiblePassword,
                            isDense: true,
                            obscureText: true,
                            validator: (textValue) {
                              if (textValue == null || textValue.isEmpty) {
                                return 'Password is required!';
                              }
                              return null;
                            },
                            suffixIcon: true,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          CustomFormButton(
                            innerText: 'Signup',
                            onPressed: _userSignup,
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account ? ',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xff939393),
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()))
                                  },
                                  child: const Text(
                                    'Log-in',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xff748288),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  void _userSignup() async {
    // Validate the form
    if (!_signupFormKey.currentState!.validate()) {
      return;
    }
    // Create Product object
    User user = User(
      name: _nameController.text,
      mobileNumber: int.parse(_mobileNumberController.text),
      email: _emailController.text,
      password: _passwordController.text,
    );

    bool status = await adduserToBox(context, user);
    if (status) {
      _nameController.clear();
      _mobileNumberController.clear();
      _emailController.clear();
      _passwordController.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignupPage()),
      );
    }
  }
}
