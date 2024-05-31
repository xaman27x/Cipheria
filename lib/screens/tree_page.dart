import 'package:flutter/material.dart';
import 'package:Cipheria/screens/login_page.dart';
import 'home_page.dart';
import '../models/auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData && !forgotPass) {
            return HomePage();
          } else {
            return const LoginPage();
          }
        });
  }
}
