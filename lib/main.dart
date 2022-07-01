import 'package:deepmood/Screens/set_username.dart';
import 'package:deepmood/Services/notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:deepmood/Screens/survey_screen_before.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/survey_screen_after.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  runApp(
    const MaterialApp(
      title: 'DeepMood',
      home: HomePage(),
    )
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String userName = "Username";
  String preTime = "";
  String postTime = "";
  String errorMessage = "";
  int submitButtonMode = 0;

  @override
  void initState() {
    getData();
    super.initState();
    getNotifications(context);
  }

  getData() async{
    SharedPreferences savedData = await SharedPreferences.getInstance();
    print("username : ${savedData.getString('username').toString()} , submitButtonMode : ${savedData.getInt('submitButtonMode').toString()}");
    setState(() {
      if(savedData.getString('username') != null) {
        userName = savedData.getString('username').toString();
        // print("username found : $userName");
        if(savedData.getInt('submitButtonMode') != null){
          submitButtonMode = savedData.getInt('submitButtonMode')!;
        }
        else{
          savedData.setInt('submitButtonMode', 1);
          submitButtonMode = 1;
        }

        if(savedData.getInt('submitButtonMode')==2 ){
          if(errorMessage.isEmpty) {
            errorMessage = "Please take the survey again after finishing trial..";
          }
        }
        else{errorMessage = "";}
      }
      else{ userName = "Username"; submitButtonMode = 0;}

      if(savedData.getString('pretime') != null) {
        preTime = savedData.getString('pretime').toString();
      }
      else{ preTime = "No surveys taken yet !";}
      if(savedData.getString('posttime') != null) {
        postTime = savedData.getString('posttime').toString();
      }
      else{ postTime = "No surveys taken yet !";}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("DEEPMOOD", style: GoogleFonts.manrope(),),
        actions: <Widget>[
          TextButton.icon(
              onPressed: () async{
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsernameSet()),
                );
                print(userName);
                setState(() {
                  getData();
                });
              },
              icon: const Icon(Icons.person, color: Colors.white70,),
              label: Text(userName, style: const TextStyle(color: Colors.white70),)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  color: Colors.grey[300],
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Row(
                    children: <Widget>[
                      const Text("Last Pre-Trial Survey :  "),
                      Text(preTime),
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey[300],
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Row(
                    children: <Widget>[
                      const Text("Last Post-Trial Survey :  "),
                      Text(postTime),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Welcome to DeepMood Survey App",
                        maxLines: 2,
                        softWrap: true,
                        style: GoogleFonts.encodeSans(fontSize: 26, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                Text(
                  "Tell us about your digital experience and mood, take the Survey",
                  style: GoogleFonts.bioRhyme(fontSize: 18, color: Colors.black45),
                  // textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20,),
                TextButton(
                  onPressed: () async{
                    SharedPreferences savedData = await SharedPreferences.getInstance();
                    getData();
                    // print(submitButtonMode);
                    if (submitButtonMode == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SurveyPage()),
                      );
                    }
                    else if (submitButtonMode == 2) {
                      DateTime surveyActivationTime = DateTime.parse(savedData.getString('surveyActivationTime')!);
                      setState(() {
                        errorMessage = "Please take the survey again after finishing trial..";
                      });
                      if (surveyActivationTime.isBefore(DateTime.now())) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SurveyPage2()),
                        );
                      }
                      else{
                        setState(() {
                          errorMessage = "You have ${surveyActivationTime.difference(DateTime.now()).inMinutes} minutes left before taking the Post-Trial Survey !!";
                        });
                      }
                    }
                    else{
                      setState(() {
                        errorMessage = "Please set Username";
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
                  ),
                  child: Text("Take Survey", style: GoogleFonts.raleway(color: Colors.black, fontWeight: FontWeight.w500),),
                ),
                Text(errorMessage, style: const TextStyle(color: Colors.redAccent, fontSize: 10),),
              ],
            ),
            Column(
              children: <Widget>[
                SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/iitj_logo.png', height: 50,),
                    SizedBox(width: 15,),
                    Text("IIT Jodhpur", style: GoogleFonts.raleway(color: Colors.grey[600], fontWeight: FontWeight.w500),),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
