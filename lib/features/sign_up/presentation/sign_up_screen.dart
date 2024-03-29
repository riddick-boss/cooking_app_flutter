import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/assets/graphics/graphics.dart';
import 'package:cooking_app_flutter/domain/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/domain/navigation/main_app_nav.dart';
import 'package:cooking_app_flutter/domain/util/snack_bar.dart';
import 'package:cooking_app_flutter/features/sign_up/data/sign_up_step.dart';
import 'package:cooking_app_flutter/features/sign_up/presentation/sign_up_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _viewModel = getIt<SignUpViewModel>();

  Future<void> onSignUpClicked() async {
    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      await _viewModel.createUserWithEmailAndPassword(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
    }
  }

  void onAlreadyRegisteredClicked() {
    MainAppNav.navigator.currentState
        ?.pushReplacementNamed(MainAppNavDestinations.login.route);
  }

  @override
  void initState() {
    super.initState();

    _viewModel.showLoginErrorSnackBarStream.listen((message) {
      showSnackBar(context, message);
    });

    _viewModel.onNavigateToDishesScreenStream.listen((event) {
      MainAppNav.navigator.currentState?.pushNamedAndRemoveUntil(
        MainAppNavDestinations.main.route,
        (route) => false,
      ); // clear stack and go to dishes screen
    });

    _viewModel.progressIndicatorState.listen((event) {
      switch(event) {
        case SignUpStep.collectingIngredients: {
          EasyLoading.show(status: AppStrings.signUpCollectingIngredients);
          break;
        }
        case SignUpStep.mixing: {
          EasyLoading.show(status: AppStrings.signUpMixing);
          break;
        }
        case SignUpStep.tastingWonderfulDishes: {
          EasyLoading.show(status: AppStrings.signUpTastingDishes);
          break;
        }
        case SignUpStep.done: {
          EasyLoading.showSuccess(AppStrings.signUpReadyToCook);
          break;
        }
        case null: {
          EasyLoading.dismiss();
          break;
        }
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
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
                AppStrings.signUpTitle,
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
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            validator: (name) =>
                                _viewModel.isFirstNameValid(firstName: name?.trim())
                                    ? null
                                    : AppStrings.signUpFirstNameTextFieldHint,
                            decoration: InputDecoration(
                              hintText: AppStrings.signUpFirstNameTextFieldHint,
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.black45,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            validator: (name) =>
                                _viewModel.isLastNameValid(lastName: name?.trim())
                                    ? null
                                    : AppStrings.signUpLastNameTextFieldHint,
                            decoration: InputDecoration(
                              hintText: AppStrings.signUpLastNameTextFieldHint,
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.black45,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: (email) =>
                          _viewModel.isEmailValid(email: email?.trim())
                              ? null
                              : AppStrings.signUpEnterValidEmailMessage,
                      decoration: InputDecoration(
                        hintText: AppStrings.signUpEmailTextFieldHint,
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.black45,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: (password) =>
                          _viewModel.isPasswordValid(password: password?.trim())
                              ? null
                              : AppStrings.signUpPasswordTextFieldHint,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.black45,
                        ),
                        hintText: AppStrings.signUpPasswordTextFieldHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: onSignUpClicked,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                        backgroundColor: Colors.purpleAccent,
                      ),
                      child: const Text(
                        AppStrings.signUpSignUpButton,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          AppStrings.signUpAlreadyRegistered,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: onAlreadyRegisteredClicked,
                          child: const Text(
                            AppStrings.signUpAlreadyRegisteredButton,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
}
