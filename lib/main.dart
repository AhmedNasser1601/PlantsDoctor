import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plants_doctor/LOGIN.dart';
import 'package:plants_doctor/SIGNUP.dart';
import 'package:plants_doctor/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PlantsDoctor());
}

class PlantsDoctor extends StatelessWidget {
  const PlantsDoctor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plants Doctor',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      appBar: AppBar(
        title: Text(
          "Cure your plants with ease.. 🌱",
          style: TextStyle(
            fontSize: 20,
            color: Colors.yellow[200],
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info, color: Colors.orangeAccent[200]),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Info"),
                    content: Text(
                        "Plants Doctor is a simple and easy-to-use application that helps you grow healthy plants. With this app, you can get quick and accurate diagnoses for your plant's diseases, browse informative articles about plant care, and connect with a community of plant enthusiasts. Whether you're an experienced gardener or just starting out, Plants Doctor is the perfect tool to keep your plants happy and thriving. Download now and start your plant journey today!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Great!"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
        backgroundColor: Colors.green[800],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 16.0,
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green[800]!),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpPage()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 16.0,
                  ),
                  child: Text(
                    "Signup",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.green[800]!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
