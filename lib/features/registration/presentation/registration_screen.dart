import 'package:cooking_app_flutter/core/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/core/navigation/navigator_util.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) =>
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            emailTextField(),
            nameTextField(),
            submitButton()
          ],
        )
    )
  );

  Widget emailTextField() => TextFormField(
    decoration: const InputDecoration(
      icon: Icon(Icons.email_rounded),
      hintText: AppStrings.registrationEmailInputHint,
      labelText: AppStrings.registrationEmailInputLabel
    ),
    validator: (email) {
      if(email == null || email.isEmpty) { // TODO: email validation
        return AppStrings.registrationIncorrectEmailMessage;
      }
      return null;
    },
  );

  Widget nameTextField() => TextFormField(
    decoration: const InputDecoration(
      icon: Icon(Icons.person),
      hintText: AppStrings.registrationNameInputHint,
      labelText: AppStrings.registrationNameInputLabel
    ),
    validator: (name) {
      if(name == null || name.isEmpty) {
        return AppStrings.registrationIncorrectNameMessage;
      }
      return null;
    },
  );

  Widget submitButton() => Container(
    padding: const EdgeInsets.only(top: 20),
    width: double.infinity,
    alignment: Alignment.center,
    child: ElevatedButton(
      onPressed: () {
        if(_formKey.currentState!.validate()) {
          Scaffold.of(context).showSnackBar(const SnackBar(content: Text("Processing data")));
          NavigatorUtil.localDishesNav.currentState!.pushReplacementNamed("/localDishesNav/dishes_list");
        }
      },
      child: const Text(AppStrings.registrationSubmitButton),
    ),
  );
}