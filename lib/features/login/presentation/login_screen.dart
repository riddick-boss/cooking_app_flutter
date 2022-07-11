import 'package:cooking_app_flutter/core/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/core/navigation/main_app_nav.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:cooking_app_flutter/core/util/extension/string_extension.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  void onSignInClicked() {
    if (_formKey.currentState!.validate()) {
      //  TODO: sign in
    }
  }

  void onSignUpClicked() {
    MainAppNav.navigator.currentState?.pushReplacementNamed(MainAppNav.signUpRoute);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                AppStrings.loginTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (email) => EmailValidator.validate(email!)
                          ? null
                          : AppStrings.loginEnterValidEmailMessage,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: AppStrings.loginEmailTextFieldHint,
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    itemSpacingBox(),
                    TextFormField(
                      validator: (password) {
                        if (password.isNullOrEmpty) {
                          return AppStrings.loginEnterPasswordMessage;
                        }
                        return null;
                      },
                      maxLines: 1,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: AppStrings.loginPasswordTextFieldHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    itemSpacingBox(),
                    ElevatedButton(
                      onPressed: onSignInClicked,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                      ),
                      child: const Text(
                        AppStrings.loginSignInButton,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    itemSpacingBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(AppStrings.loginNotRegisteredYet),
                        TextButton(
                            onPressed: onSignUpClicked,
                            child: const Text(
                                AppStrings.loginCreateAccountButton)),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget itemSpacingBox() => const SizedBox(
        height: 20,
      );
}