import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ship_conquest/widgets/screens/bottom_navigation_bar/bottom_bar.dart';

import '../../../domain/user_info.dart';
import '../../../services/ship_services/ship_services.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final services = Provider.of<ShipServices>(context);

    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 100),
          Text(
            'Your Profile',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: [
                Shadow(
                  offset: const Offset(2, 2),
                  blurRadius: 5,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
          FutureBuilder<UserInfo>(
            future: services.getPersonalInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                final user = snapshot.data!;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 75.0,
                        height: 75.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            user.imageUrl,
                            fit: BoxFit.cover,
                            width: 200.0,
                            height: 200.0,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user.email,
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ],
                  )
                );
              } else {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
