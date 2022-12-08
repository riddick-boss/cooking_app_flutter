import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/assets/graphics/graphics.dart';
import 'package:cooking_app_flutter/domain/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/domain/navigation/main_app_nav.dart';
import 'package:cooking_app_flutter/domain/util/snack_bar.dart';
import 'package:cooking_app_flutter/features/login/presentation/login_vm.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _viewModel = getIt<LoginViewModel>();

  Future<void> onSignInClicked() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      await _viewModel.onSignInClicked(email: email, password: password);
    }
  }

  void onSignUpClicked() {
    MainAppNav.navigator.currentState
        ?.pushNamed(MainAppNavDestinations.signUp.route);
  }

  @override
  void initState() {
    super.initState();

    _viewModel.showLoginErrorSnackBarStream.listen((message) {
      showSnackBar(context, message);
    });

    _viewModel.onNavigateToDishesScreenStream.listen((event) {
      MainAppNav.navigator.currentState
          ?.pushReplacementNamed(MainAppNavDestinations.main.route);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Graphics.loginSingUpBackground.path),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                AppStrings.loginTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.black,
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
                      style: const TextStyle(color: Colors.black),
                      controller: _emailController,
                      validator: (email) =>
                          _viewModel.isEmailValid(email: email)
                              ? null
                              : AppStrings.loginEnterValidEmailMessage,
                      decoration: InputDecoration(
                        hintText: AppStrings.loginEmailTextFieldHint,
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.black45,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    itemSpacingBox(),
                    TextFormField(
                      controller: _passwordController,
                      validator: (password) =>
                          _viewModel.isPasswordValid(password: password)
                              ? null
                              : AppStrings.loginEnterPasswordMessage,
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Colors.black,
                        focusColor: Colors.black,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.black26,
                        ),
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
                        backgroundColor: Colors.yellow,
                      ),
                      child: const Text(
                        AppStrings.loginSignInButton,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    itemSpacingBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          AppStrings.loginNotRegisteredYet,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: onSignUpClicked,
                          child: const Text(
                            AppStrings.loginCreateAccountButton,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget itemSpacingBox() => const SizedBox(height: 20);
}
