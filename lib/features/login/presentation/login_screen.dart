import 'package:cooking_app_flutter/core/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/core/navigation/main_app_nav.dart';
import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> onSignInClicked() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      await _viewModel.onSignInClicked(email: email, password: password);
    }
  }


  @override
  void initState() {
    super.initState();

    _viewModel.showLoginErrorSnackBarStream.listen((message) {
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    _viewModel.onNavigateToDishesScreenStream.listen((event) {
      MainAppNav.navigator.currentState?.pushReplacementNamed(MainAppNav.dishesMainDrawerRoute);
    });
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
                      controller: _emailController,
                      validator: (email) => _viewModel.isEmailValid(email: email) ? null : AppStrings.loginEnterValidEmailMessage,
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
                      controller: _passwordController,
                      validator: (password) => _viewModel.isPasswordValid(password: password) ? null : AppStrings.loginEnterPasswordMessage,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
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
                          child:
                              const Text(AppStrings.loginCreateAccountButton),
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
