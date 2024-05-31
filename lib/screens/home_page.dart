import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/auth.dart';
import '../models/chats.dart';
import '../widgets/messages.dart';

Future<void> signOut() async {
  await Auth().signOut();
}

class HomePage extends StatefulWidget {
  final FirebaseAuth _instance = FirebaseAuth.instance;
  User? get currUser => _instance.currentUser;
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  bool isSubmitted = false;
  String input = '';
  String userId = '';
  String? fetchedData;
  String? userName;
  String? userlastname;
  final TextEditingController _controllerInput = TextEditingController();

  static final model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: dotenv.env['GENERATIVE_MODEL_API_KEY']!,
  );

  @override
  void initState() {
    userId = HomePage().currUser!.uid;
    super.initState();
    isSubmitted = false;
    _getUserName();
    _getUserLastName();
  }

  @override
  void dispose() {
    super.dispose();
    isSubmitted = false;
  }

  Future<void> _getUserName() async {
    try {
      final emailID = Auth().currentUser?.email ?? '';
      final name = await Auth().getName(emailID);
      setState(() {
        userName = name;
      });
    } catch (e) {
      ('Error retrieving user name: $e');
    }
  }

  Future<void> _getUserLastName() async {
    try {
      final emailID = Auth().currentUser?.email ?? '';
      final lastname = await Auth().getLastName(emailID);
      setState(() {
        userlastname = lastname;
      });
    } catch (e) {
      ('Error retrieving user name: $e');
    }
  }

  Widget _searchButton(TextEditingController controller) {
    return IconButton(
      icon: const Icon(Icons.search_rounded),
      onPressed: () {
        isLoading = true;
        isSubmitted = true;
        final inputText = controller.text;
        if (inputText.isNotEmpty) {
          setState(() {
            input = inputText;
            _fetchData(input);
          });
        }
        controller.clear();
      },
    );
  }

  Widget _showData(isSubmitted) {
    if (isSubmitted) {
      return Container(
        margin: const EdgeInsets.all(50.0),
        color: Colors.black,
        width: 600.0,
        height: 350.0,
        child: _displayRetrievedInformation(),
      );
    } else {
      return const Text('');
    }
  }

  Future<void> _fetchData(String inputText) async {
    try {
      final generatedText = await retrieveMessage(inputText);
      Chats().uploadChats(userId, inputText);
      setState(() {
        isLoading = false;
        fetchedData = generatedText;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        fetchedData = 'Error: ${e.toString()}';
      });
    }
  }

  Future<String> retrieveMessage(String inputText) async {
    final content = [Content.text(inputText)];
    final response = await model.generateContent(content);
    if (response.text == null) {
      throw Exception('Generated text is null');
    }
    return response.text!;
  }

  Widget inputField(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          hintText: 'Enter your query..',
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          labelStyle: GoogleFonts.oxanium(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: GoogleFonts.oxanium(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: _searchButton(controller),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _displayRetrievedInformation() {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 120, horizontal: 240),
        child: CircularProgressIndicator(
            color: Color.fromARGB(255, 161, 153, 153)),
      );
    } else if (fetchedData == null) {
      return const Center(
        heightFactor: double.infinity,
        child: Text(
          'Please enter a query and press search.',
          style: TextStyle(
            color: Color.fromARGB(255, 176, 174, 174),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        controller: ScrollController(),
        child: Text(
          fetchedData!,
          style: const TextStyle(
            color: Color.fromARGB(255, 176, 174, 174),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _userInfo() {
    return Container(
      color: const Color.fromARGB(255, 9, 9, 9),
      child: Text(
        'User: $userName $userlastname',
        style: GoogleFonts.oxanium(
          color: const Color.fromARGB(255, 83, 82, 82),
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 5, 6, 6),
        title: Text(
          "CIPHERIA",
          style: GoogleFonts.orbitron(
            color: const Color.fromARGB(255, 134, 124, 124),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: signOut,
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Color.fromARGB(255, 78, 72, 72),
              ),
            ),
            child: Text(
              "SIGN OUT",
              style: GoogleFonts.oxanium(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              selectionColor: const Color.fromARGB(255, 59, 54, 54),
            ),
          ),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10)),
          ElevatedButton(
            onPressed: () {
              launchURL("https://www.github.com/xaman27x");
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Color.fromARGB(255, 78, 72, 72),
              ),
            ),
            child: Text(
              "GITHUB",
              style: GoogleFonts.oxanium(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              selectionColor: const Color.fromARGB(255, 59, 54, 54),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        surfaceTintColor: const Color.fromARGB(255, 30, 29, 29),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        shadowColor: const Color.fromARGB(255, 23, 23, 23),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'CIPHERIA',
              style: GoogleFonts.orbitron(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 134, 124, 124),
              ),
            ),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 9, 9, 9),
          ),
          body: Container(
            color: const Color.fromARGB(255, 9, 9, 9),
            child: Messages(),
          ),
          bottomSheet: _userInfo(),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background3.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
            child: Column(
              children: [
                if (userName != null)
                  Text(
                    "Hello $userName,\nHow can I help you today?",
                    style: GoogleFonts.orbitron(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 154, 153, 159),
                    ),
                  ),
                Center(
                  child: _showData(isSubmitted),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: inputField("Ask Me Anything!", _controllerInput),
    );
  }
}
