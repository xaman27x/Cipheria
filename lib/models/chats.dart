import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string_generator/random_string_generator.dart';
import 'auth.dart';

var generator = RandomStringGenerator(
  hasSymbols: false,
  fixedLength: 20,
);

class Chats {
  Map<String, String> chatData = {};
  CollectionReference userChats =
      FirebaseFirestore.instance.collection('UserChats');

  Future<void> retreiveChats(String userID) async {
    try {
      final chatSnapshot =
          await Chats().userChats.where('UserID', isEqualTo: userID).get();
      if (chatSnapshot.docs.isEmpty) {
        ('No User Found with ID: $userID');
      } else {
        for (var doc in chatSnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          chatData = data['data'];
        }
      }
    } catch (e) {
      ('Error retrieving user: $e');
    }
    throw {('Error Fetching User')};
  }

  Future<void> uploadChats(String userID, String chat) async {
    Chats().userChats.doc(userID).set({
      'data': {generator.generate(): chat.toUpperCase()}
    }, SetOptions(merge: true));
  }

  Future<void> deleteChats(String userID, String email) async {
    Map<String, dynamic> dataUpload = {
      'FirstName': Auth().getName(email),
      'LastName': Auth().getLastName(email),
      'UserID': userID,
      'data': '',
    };
    Chats().userChats.doc(userID).set(
          dataUpload,
          SetOptions(merge: false),
        );
  }
}
