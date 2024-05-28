import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:namer_app/screens/pass_reset.dart';
import '../models/auth.dart';
import '../models/chats.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:random_string_generator/random_string_generator.dart';

bool forgotPass = false;
var generator = RandomStringGenerator(
  hasSymbols: false,
  fixedLength: 20,
);

var gen_2 = RandomStringGenerator(
  hasSymbols: false,
  fixedLength: 12,
);

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  String? errorMessage = '';
  String? emailID = '';
  bool isLogin = true;
  bool _authobscure = true;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerAge = TextEditingController();

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      emailID = _controllerEmail.text;
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      String currUserID = Auth().currentUser!.uid;
      String currUserEmailID = Auth().currentUser!.email.toString();

      Map<String, dynamic> dataUpload = {
        'UserID': currUserID,
        'EmailID': currUserEmailID,
        'FirstName': _controllerFirstName.text,
        'LastName': _controllerLastName.text,
        'Age': int.parse(_controllerAge.text),
      };
      Map<String, dynamic> chatuserID = {
        'UserID': currUserID,
        'FirstName': _controllerFirstName.text,
        'LastName': _controllerLastName.text,
        'data': {},
      };
      Auth()
          .users
          .doc(generator.generate())
          .set(dataUpload)
          .then((value) => ("User Added"))
          .catchError((error) => ("Failed to add user: $error"));

      Chats()
          .userChats
          .doc(currUserID)
          .set(chatuserID)
          .then((value) => print("User Added"))
          .catchError((error) => print('$error'));
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _entryField(
      String title, TextEditingController controller, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          hintText:
              title == 'Password' ? 'Enter your password' : 'Enter your $title',
          filled: true,
          fillColor: const Color.fromARGB(193, 255, 255, 255).withOpacity(0.1),
          labelStyle: const TextStyle(color: Colors.white),
          hintStyle: const TextStyle(color: Color.fromARGB(174, 255, 255, 255)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        style: const TextStyle(color: Colors.white),
        obscureText: obscureText,
      ),
    );
  }

  Widget _errorMessage() {
    return errorMessage == ''
        ? const SizedBox.shrink()
        : Text(
            '$errorMessage',
            style: const TextStyle(color: Colors.red),
          );
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(251, 41, 43, 44),
        foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
    ).animate().scale(duration: 300.ms, curve: Curves.easeInOut);
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
          _controllerFirstName.clear();
          _controllerLastName.clear();
          _controllerEmail.clear();
          _controllerPassword.clear();
          _controllerAge.clear();
        });
      },
      child: Text(
        isLogin ? 'Register Instead' : 'Login Instead',
        style: const TextStyle(color: Colors.white),
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _forgotPassword() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PassResetPage()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(251, 41, 43, 44),
        foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        "Forgot Password?",
        style: TextStyle(color: Colors.white),
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _loginGreeting(bool islogin) {
    if (islogin) {
      return Text(
        "Welcome Back, Good To See You Again!",
        style: GoogleFonts.orbitron(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 154, 153, 159)),
      );
    } else {
      return Text(
        "Welcome to Cipheria! A Futuristic and Agile AI ChatBot which resolves queries efficiently <> Kindly register yourself to continue!",
        style: GoogleFonts.orbitron(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 154, 153, 159)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 2, 2),
        foregroundColor: Colors.white,
        title: Text(
          '✻ CIPHERIA',
          style: GoogleFonts.orbitron(
            color: const Color.fromARGB(255, 134, 124, 124),
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 17, 17, 17),
          image: DecorationImage(
            image: AssetImage(
              'assets/images/background2.jpg',
            ),
            fit: BoxFit.fill,
          ),
        ),
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              ),
              _loginGreeting(isLogin),
              if (!isLogin)
                _entryField('First Name', _controllerFirstName, false),
              if (!isLogin)
                _entryField('Last Name', _controllerLastName, false),
              if (!isLogin) _entryField('Age', _controllerAge, false),
              _entryField('E-mail Address', _controllerEmail, false),
              _entryField('Password', _controllerPassword, _authobscure),
              const SizedBox(height: 10),
              const Text(
                "Toggle Password Visibility",
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _authobscure = !_authobscure;
                  });
                },
                icon: Icon(
                  _authobscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
              ),
              _errorMessage(),
              const SizedBox(height: 10),
              _submitButton(),
              _loginOrRegisterButton(),
              _forgotPassword()
            ],
          ),
        ).animate().fadeIn(duration: 1000.ms),
      ),
    );
  }
}
