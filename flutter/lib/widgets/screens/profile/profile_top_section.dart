import 'package:flutter/material.dart';

/// Builds the profile's top section, including the name and logout button.
Widget buildProfileTopSection(BuildContext context, void Function() onLogout, String firstName) => Container(
    padding: const EdgeInsets.fromLTRB(39, 60, 75, 9),
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildProfileName(context, firstName),
        buildProfileLogoutButton(context, onLogout)
      ],
    ));

Widget buildProfileName(BuildContext context, String firstName) => FittedBox(
    fit: BoxFit.scaleDown,
    child: Text(
      "${firstName ?? ''}${firstName.endsWith('s') ? "'" : "'s"} profile",
      style:
      Theme.of(context).textTheme.titleLarge,
    ));

Widget buildProfileLogoutButton(BuildContext context, void Function() onLogout) => ElevatedButton(
  onPressed: onLogout,
  style: Theme.of(context)
      .elevatedButtonTheme
      .style
      ?.copyWith(
      backgroundColor:
      MaterialStatePropertyAll(
          Theme.of(context)
              .colorScheme
              .primary),
      textStyle: MaterialStatePropertyAll(
          Theme.of(context)
              .textTheme
              .bodySmall)),
  child: const Text("Logout!"),
);