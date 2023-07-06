import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/user/user_info.dart';
import 'package:ship_conquest/providers/game/event_handlers/general_event.dart';
import 'package:ship_conquest/services/google/google_signin_api.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';
import 'package:ship_conquest/widgets/screens/menu_utils/green_background.dart';
import 'package:ship_conquest/widgets/screens/menu_utils/mountains_background.dart';
import 'package:ship_conquest/widgets/screens/menu_utils/screen_template.dart';
import 'package:ship_conquest/widgets/screens/profile/profile_top_section.dart';
import 'package:ship_conquest/widgets/screens/wait_for_async_screen.dart';

/// Builds the whole profile screen by joining the smaller pieces in one.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserInfo? user;

  @override
  void initState() {
    super.initState();
    // load user personal info
    GeneralEvent.getPersonalInfo(
        context, (info) => setState(() => user = info));
  }

  @override
  Widget build(BuildContext context) {
    final services = Provider.of<ShipServices>(context, listen: false);

    final firstName = user?.name.split(' ').first;
    return buildScreenTemplateWidget(context, [
      if (user != null && firstName != null) ...[
        buildProfileTopSection(
            context,
            () {
              logout(services)
                  .then((value) => context.go("/signIn"));
            },
            firstName),
        Stack(
          children: [
            buildGreenBackgroundWidget(context),
            buildMountainsBackgroundWidget(context, 'assets/images/profile_back_mountain.png'),
            Align(
              alignment: const Alignment(0.0, 0.0),
              child: ClipOval(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0.0, 0.0),
              child: ClipOval(
                child: FadeInImage(
                  width: 170,
                  height: 170,
                  placeholder: const AssetImage(
                      'assets/images/default_user_image.png'),
                  image: NetworkImage(user?.imageUrl != null
                      ? "${user?.imageUrl}"
                      : "force error"),
                  // force the error if the image is null
                  fit: BoxFit.cover,
                  imageErrorBuilder:
                      (context, error, stackTrace) {
                    // If the image fails to load, return a default image
                    return Image.asset(
                      'assets/images/default_user_image.png',
                      width: 170,
                      height: 170,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            buildMountainsBackgroundWidget(context, 'assets/images/profile_front_mountains.png'),
            Align(
              alignment: Alignment.topCenter,
              child: FractionallySizedBox(
                heightFactor: 0.6,
                widthFactor: 1,
                child: Container(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Align(
                    alignment: const Alignment(0.0, 0.0),
                    child: Text(
                      user?.description != null
                          ? "${user?.description}"
                          : "Add a description to your profile!",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ] else ...[
        const WaitForAsyncScreen(
            mountainsPath: 'assets/images/profile_mountains.png')
      ],
    ]);
  }

  Future logout(ShipServices services) async {
    await GoogleSignInApi.logout();
    await services.logoutUser();
  }
}
