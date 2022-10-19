import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/features/account/presentation/account_vm.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _viewModel = getIt<AccountViewModel>();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Column(
          children: [
            StreamBuilder<String?>(
              stream: _viewModel.name,
              builder: (context, snapshot) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  AppStrings.accountTitle(snapshot.data),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const _ActionsDivider(),
            _ActionRow(
              text: AppStrings.accountLogoutButton,
              iconData: Icons.logout_outlined,
              onTap: _viewModel.onLogoutClicked,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: Text(
                AppStrings.accountProvidedBy,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.end,
              ),
            )
          ],
        ),
      );
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.text,
    required this.iconData,
    required this.onTap,
  });

  final String text;
  final IconData iconData;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  Icon(iconData)
                ],
              ),
            ),
          ),
          const _ActionsDivider(),
        ],
      );
}

class _ActionsDivider extends StatelessWidget {
  const _ActionsDivider();

  @override
  Widget build(BuildContext context) => const Divider(
        color: Colors.white,
        height: 0.5,
        thickness: 0.5,
      );
}
