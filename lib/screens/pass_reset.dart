import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Cipheria/screens/pass_reset.dart';

final TextEditingController _controllerPassReset = TextEditingController();
String errorMessage = '';
bool sentData = false;

class PassResetPage extends StatefulWidget {
  const PassResetPage({Key? key}) : super(key: key);
  @override
  State<PassResetPage> createState() => _PassResetPageState();
}

class _PassResetPageState extends State<PassResetPage> {
  Future<void> sendEmailForPassReset() async {
    try {
      await Auth().sendPasswordResetEmail(
        email: _controllerPassReset.text,
      );
    } on FirebaseException catch (e) {
      setState(() {
        errorMessage = e.message.toString();
        sentData = false;
      });
    }
  }

  Widget _passResetField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Enter Your Email Address',
          filled: true,
          fillColor: const Color.fromARGB(255, 155, 151, 151).withOpacity(0.1),
          labelStyle:
              const TextStyle(color: Color.fromARGB(255, 176, 170, 170)),
          hintStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        style: const TextStyle(color: Color.fromARGB(255, 213, 203, 203)),
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(252, 76, 78, 79),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text("SUBMIT"),
        onPressed: () {
          setState(() {
            sentData = true;
          });
          sendEmailForPassReset();
          _controllerPassReset.clear();
        });
  }

  Widget _successPopUp(bool sent) {
    if (sent) {
      return Center(
        child: Text(
          "An Email with the link to reset your password has been sent successfully. Kindly check your mail !",
          style: GoogleFonts.orbitron(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: const Color.fromARGB(255, 134, 124, 124),
          ),
        ),
      );
    } else {
      return const Text('');
    }
  }

  Widget _errorMessage(String error) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Center(
        child: Text(
          error,
          style: const TextStyle(
            color: Color.fromARGB(255, 203, 19, 6),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    sentData = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          '✻ CIPHERIA',
          style: GoogleFonts.orbitron(
            color: const Color.fromARGB(255, 134, 124, 124),
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
        leading: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 0, 0)),
          onPressed: () {
            setState(() {
              sentData = false;
            });
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.only(right: 0),
            child: Icon(
              Icons.arrow_back_sharp,
              color: Color.fromARGB(255, 182, 180, 180),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(255, 0, 0, 0),
        height: double.infinity,
        width: double.infinity,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10, left: 5),
              child: Text(
                'To Reset Your Password, Please enter your Email Address registered with us: ',
                style: GoogleFonts.orbitron(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: const Color.fromARGB(255, 134, 124, 124),
                ),
              ),
            ),
            _passResetField(_controllerPassReset),
            _submitButton(),
            _errorMessage(errorMessage),
            _successPopUp(sentData),
          ],
        ),
      ),
    );
  }
}
