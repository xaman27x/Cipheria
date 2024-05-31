import 'package:firebase_auth/firebase_auth.dart';
import '../models/chats.dart';
import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final FirebaseAuth _deleteInfo = FirebaseAuth.instance;
  User? get currUser => _deleteInfo.currentUser;
  DeleteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Delete Chats'),
      onPressed: () {
        Chats().deleteChats(currUser!.uid, currUser!.email.toString());
      },
    );
  }
}
