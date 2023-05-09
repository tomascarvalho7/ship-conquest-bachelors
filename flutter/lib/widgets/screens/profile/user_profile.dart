import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ship_conquest/widgets/screens/start_menu/start_menu.dart';

import '../../../domain/user/user_info.dart';
import '../../../services/ship_services/ship_services.dart';

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
    _getUser();
  }

  Future<void> _getUser() async {
    final services = Provider.of<ShipServices>(context, listen: false);

    final userInfo = await services.getPersonalInfo();
    setState(() {
      user = userInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                children: [
                  if (user != null) ...[
                    Container(
                      padding: const EdgeInsets.fromLTRB(39, 60, 75, 9),
                      width: double.infinity,
                      child:
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "${user?.name.split(' ').first ?? ''}'s profile",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      )
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: 0.3,
                        widthFactor: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: Align(
                            alignment: const Alignment(0.0, 0.0),
                            child: Text(
                              user?.description != null ? "${user?.description}" : "Add a description to your profile!",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        Align(
                          alignment: const Alignment(0, 0.5),
                          child: SizedBox(
                              child: Image.asset(
                            'assets/images/profile_back_mountain.png',
                            fit: BoxFit.fill,
                          )),
                        ),
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
                              image: NetworkImage(user?.imageUrl != null ? "${user?.imageUrl}" : "force error"), // force the error if the image is null
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
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
                        Align(
                          alignment: const Alignment(0, 0.5),
                          child: SizedBox(
                              child: Image.asset(
                                  'assets/images/profile_front_mountains.png',
                                  fit: BoxFit.fill)),
                        ),
                      ],
                    ),
                  ] else ...[
                    const WaitForAsyncScreen(mountainsPath: 'assets/images/profile_mountains.png')
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
