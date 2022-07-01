import 'package:deepmood/Screens/set_username.dart';
import 'package:deepmood/Utils/adjectives_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({Key? key}) : super(key: key);

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {

  String userName = "";
  String errorText = "";
  bool buttonActive = true;

  int overallMood = -10;
  int tenseArousal = -10;
  int energeticArousal = -10;

  @override
  void initState() {
    getData();
    super.initState();

    lively.val = -1;
    happy.val = -1;
    sad.val = -1;
    tired.val = -1;
    gloomy.val = -1;
    caring.val = -1;
    content.val = -1;
    jittery.val = -1;
    drowsy.val = -1;
    grouchy.val = -1;
    peppy.val = -1;
    nervous.val = -1;
    calm.val = -1;
    loving.val = -1;
    fedup.val = -1;
    active.val = -1;
  }

  getData() async{
    SharedPreferences savedData = await SharedPreferences.getInstance();
    setState(() {
      userName = savedData.getString('username').toString();
    });
  }

  updatePreTime(String newPretime) async{
    SharedPreferences savedData = await SharedPreferences.getInstance();
    await savedData.setString('pretime', newPretime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Take Survey"),
        actions: <Widget>[
          TextButton.icon(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsernameSet()),
                );
              },
              icon: const Icon(Icons.person, color: Colors.white70,),
              label: Text(userName, style: const TextStyle(color: Colors.white70),)
          )
        ],
      ),
      body: Center(
        child: Scrollbar(
          thickness: 6,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Center(
                  child: Text("Pre Trial", style: GoogleFonts.manrope(fontSize: 23),),
                ),
                const Divider(
                  color: Colors.teal,
                  thickness: 2,
                ),

                /// PART 1
                ListTile(
                  title: Text(
                    "Brief Mood Introspection",
                    style: GoogleFonts.bioRhyme(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),

                /// Adjectives
                Container(
                  padding: const EdgeInsets.all(20.0),
                  alignment: Alignment.centerLeft,
                  child: const Text("1.  Select the response that indicates how well each adjective best describes your present mood.", textAlign: TextAlign.left, style: TextStyle(fontSize: 18),),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), border: Border.all(color: Colors.black)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: const <Widget>[
                          Text("0"),
                          SizedBox(width: 12,),
                          Text("Definitely do not feel",),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: const <Widget>[
                          Text("1"),
                          SizedBox(width: 12,),
                          Text("Do not feel",),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: const <Widget>[
                          Text("2"),
                          SizedBox(width: 12,),
                          Text("Slightly feel",),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: const <Widget>[
                          Text("3"),
                          SizedBox(width: 12,),
                          Text("Definitely feel",),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey[300]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          SizedBox(width: 50,),
                          Text("0"),
                          Text("1"),
                          Text("2"),
                          Text("3"),
                          SizedBox(width: 20,),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      moodAdjectiveButton(lively),
                      moodAdjectiveButton(happy),
                      moodAdjectiveButton(sad),
                      moodAdjectiveButton(tired),
                      moodAdjectiveButton(caring),
                      moodAdjectiveButton(content),
                      moodAdjectiveButton(gloomy),
                      moodAdjectiveButton(jittery),
                      moodAdjectiveButton(drowsy),
                      moodAdjectiveButton(grouchy),
                      moodAdjectiveButton(peppy),
                      moodAdjectiveButton(nervous),
                      moodAdjectiveButton(calm),
                      moodAdjectiveButton(loving),
                      moodAdjectiveButton(fedup),
                      moodAdjectiveButton(active),
                    ],
                  ),
                ),

                /// overall mood
                Container(
                  padding: const EdgeInsets.all(20.0),
                  alignment: Alignment.centerLeft,
                  child: const Text("2.  Your overall mood is :", textAlign: TextAlign.left, style: TextStyle(fontSize: 18),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Very Unpleasant", style: GoogleFonts.manrope(fontSize: 9),),
                      Text("Neutral", style: GoogleFonts.manrope(fontSize: 9),),
                      Text("Very Pleasant   ", style: GoogleFonts.manrope(fontSize: 9),),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    overallMoodRadioButton(-3),
                    overallMoodRadioButton(-2),
                    overallMoodRadioButton(-1),
                    overallMoodRadioButton(0),
                    overallMoodRadioButton(1),
                    overallMoodRadioButton(2),
                    overallMoodRadioButton(3),
                  ],
                ),
                const SizedBox(height: 25,),
                const Divider(
                  color: Colors.teal,
                  thickness: 2,
                ),


                /// PART 2
                ListTile(
                  title: Text(
                    "Momentary Affect",
                    style: GoogleFonts.bioRhyme(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),

                /// tense Arousal
                Container(
                  padding: const EdgeInsets.all(20.0),
                  alignment: Alignment.centerLeft,
                  child: const Text("1.  Tense Arousal", textAlign: TextAlign.left, style: TextStyle(fontSize: 18),),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), border: Border.all(color: Colors.black)),
                    child: Text("Select the bubble which best describes your mood relative to specified aspects :")
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey[300]),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          tenseArousalButton(-4),
                          tenseArousalButton(-3),
                          tenseArousalButton(-2),
                          tenseArousalButton(-1),
                          tenseArousalButton(0),
                          tenseArousalButton(1),
                          tenseArousalButton(2),
                          tenseArousalButton(3),
                          tenseArousalButton(4),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Very Relaxed\nCalm\nComposed\nContent",
                              softWrap: true,
                              style: GoogleFonts.manrope(fontSize: 9),
                            ),
                            Text(
                              "Neutral\n\n\n",
                              style: GoogleFonts.manrope(fontSize: 9),
                            ),
                            Text(
                              "Very Nervous\nStressed\nAnxious\nTensed",
                              textAlign: TextAlign.right,
                              softWrap: true,
                              style: GoogleFonts.manrope(fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15,)
                    ],
                  ),
                ),
                const SizedBox(height: 20,),

                /// energetic arousal
                Container(
                  padding: const EdgeInsets.all(20.0),
                  alignment: Alignment.centerLeft,
                  child: const Text("2.  Energetic Arousal", textAlign: TextAlign.left, style: TextStyle(fontSize: 18),),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), border: Border.all(color: Colors.black)),
                    child: Text("Select the bubble which best describes your mood relative to specified aspects :")
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey[300]),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          energeticArousalButton(-4),
                          energeticArousalButton(-3),
                          energeticArousalButton(-2),
                          energeticArousalButton(-1),
                          energeticArousalButton(0),
                          energeticArousalButton(1),
                          energeticArousalButton(2),
                          energeticArousalButton(3),
                          energeticArousalButton(4),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Very Sluggish\nTired\nSleepy\nDull",
                              softWrap: true,
                              style: GoogleFonts.manrope(fontSize: 9),
                            ),
                            Text(
                              "Neutral\n\n\n",
                              style: GoogleFonts.manrope(fontSize: 9),
                            ),
                            Text(
                              "Very Active\nEnergetic\nAlert\nBright",
                              textAlign: TextAlign.right,
                              softWrap: true,
                              style: GoogleFonts.manrope(fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15,)
                    ],
                  ),
                ),


                /// Submit Button
                TextButton(
                  onPressed: () async{
                    buttonActive = SubmissionCheck();
                    if (buttonActive) {
                      bool submitBool = await Navigator.push(context, MaterialPageRoute (
                          builder: (BuildContext context) {
                            return Scaffold(
                              body: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text("Submit form ? "),
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                      width: 300,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), border: Border.all(color: Colors.black)),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text("Internet Connectivity is necessary to save your survey responses, so please ensure net connectivity before you submit", style: TextStyle(color: Colors.blue[600], fontSize: 11),),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 7,),
                                    TextButton(
                                      child: const Text("Yes", style: TextStyle(color: Colors.white),),
                                      onPressed: () { Navigator.pop(context, true); },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                      ));
                      if(submitBool==true){
                        submitForm();
                        SharedPreferences savedData = await SharedPreferences.getInstance();
                        savedData.setInt('submitButtonMode', 2);
                        savedData.setString('surveyActivationTime', DateTime.now().add(Duration(minutes: 30)).toString());
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()), (route) => !Navigator.of(context).canPop()
                        );
                      }
                    }
                    else{
                      setState(() {
                        errorText = "Please Answer all the Questions!";
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
                  ),
                  child: const Text("SUBMIT", style: TextStyle(color: Colors.black),),
                ),
                Text(errorText, style: TextStyle(color: Colors.redAccent, fontSize: 10),),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      )
    );
  }

  Future<void> submitForm() async{
    await Firebase.initializeApp();
    final db = FirebaseFirestore.instance;
    List<String> dateTime = DateTime.now().toString().split(" ");
    updatePreTime(dateTime[0]+' , '+dateTime[1].substring(0, 5));
    await db.collection('PreTrial_Survey').add(
        {
          'name': userName,
          'date' : dateTime[0],
          'time' : dateTime[1].substring(0, 8),
          'BMIS - Lively' : lively.val,
          'BMIS - Happy' : happy.val,
          'BMIS - Sad' : sad.val,
          'BMIS - Tired' : tired.val,
          'BMIS - Caring' : caring.val,
          'BMIS - Content' : content.val,
          'BMIS - Gloomy' : gloomy.val,
          'BMIS - Jittery' : jittery.val,
          'BMIS - Drowsy' : drowsy.val,
          'BMIS - Grouchy' : grouchy.val,
          'BMIS - Peppy' : peppy.val,
          'BMIS - Nervous' : nervous.val,
          'BMIS - Calm' : calm.val,
          'BMIS - Loving' : loving.val,
          'BMIS - Fedup' : fedup.val,
          'BMIS - Active' : active.val,
          'Overall Mood' : overallMood,
          'Tense Arousal' : tenseArousal,
          'Energetic Arousal' : energeticArousal,
        }
    );
  }

  overallMoodRadioButton(int val) {
    return Column(
      children: [
        Radio<int>(
          value: val,
          groupValue: overallMood,
          onChanged: (value){
            setState(() {
              overallMood = val;
            });
          },
        ),
        Text(val.toString()),
      ],
    );
  }

  tenseArousalButton(int val) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Radio<int>(
          visualDensity: VisualDensity(horizontal: -2.5, vertical: 0),
          // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: val,
          groupValue: tenseArousal,
          onChanged: (value){
            setState(() {
              tenseArousal = val;
            });
          },
        ),
        // Text(val.toString(), style: TextStyle(fontSize: 10),),
      ],
    );
  }

  energeticArousalButton(int val) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Radio<int>(
          visualDensity: VisualDensity(horizontal: -2.5, vertical: 0),
          value: val,
          groupValue: energeticArousal,
          onChanged: (value){
            setState(() {
              energeticArousal = val;
            });
          },
        ),
        // Text(val.toString(), style: TextStyle(fontSize: 10),),
      ],
    );
  }

  moodAdjectiveButton(Adj adjective) {
    return Row(
      children: <Widget>[
        Container(
          width: 75,
          alignment: Alignment.centerLeft,
          child: Text(adjective.name),
        ),
        Radio<int>(
          value: 0,
          groupValue: adjective.val,
          onChanged: (value){
            // print(adjective.val);
            setState(() {
              adjective.val = 0;
            });
          },
        ),
        Radio<int>(
          value: 1,
          groupValue: adjective.val,
          onChanged: (value){
            // print(adjective.val);
            setState(() {
              adjective.val = 1;
            });
          },
        ),
        Radio<int>(
          value: 2,
          groupValue: adjective.val,
          onChanged: (value){
            // print(adjective.val);
            setState(() {
              adjective.val = 2;
            });
          },
        ),
        Radio<int>(
          value: 3,
          groupValue: adjective.val,
          onChanged: (value){
            // print(adjective.val);
            setState(() {
              adjective.val = 3;
            });
          },
        ),
      ],
    );
  }
  bool SubmissionCheck() {
    return (
        overallMood != -10 &&
        tenseArousal != -10 &&
        energeticArousal != -10 &&
        lively.val != -1 &&
        happy.val != -1 &&
        sad.val != -1 &&
        tired.val != -1 &&
        gloomy.val != -1 &&
        caring.val != -1 &&
        content.val != -1 &&
        jittery.val != -1 &&
        drowsy.val != -1 &&
        grouchy.val != -1 &&
        peppy.val != -1 &&
        nervous.val != -1 &&
        calm.val != -1 &&
        loving.val != -1 &&
        fedup.val != -1 &&
        active.val != -1
    );
  }
}
