import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chats.dart';

class Messages extends StatelessWidget {
  final FirebaseAuth _userRetrieval = FirebaseAuth.instance;

  User? get currUser => _userRetrieval.currentUser;

  Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Chats()
          .userChats
          .where('UserID', isEqualTo: currUser!.uid)
          .snapshots(),
      builder: (ctx, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapShot.hasError) {
          return Center(
            child: Text("An error occurred: ${snapShot.error}"),
          );
        } else {
          final chatDocs = snapShot.data!.docs;
          return Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 100),
            child: ListView.builder(
              reverse: false,
              itemBuilder: (context, index) {
                final dataMap = chatDocs[index]['data'];
                final List<Widget> textWidgets = [];
                textWidgets.add(
                  Center(
                    child: Text(
                      "✽ Your Previous Chats:",
                      style: GoogleFonts.oxanium(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 172, 166, 166),
                      ),
                    ),
                  ),
                );
                dataMap.values.forEach(
                  (value) {
                    textWidgets.add(
                      Text(
                        "> ${value.toString()}\n",
                        style: GoogleFonts.oxanium(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 172, 166, 166),
                        ),
                      ),
                    );
                  },
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: textWidgets,
                );
              },
              itemCount: chatDocs.length,
            ),
          );
        }
      },
    );
  }
}
