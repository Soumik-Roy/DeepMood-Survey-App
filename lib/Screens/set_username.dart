import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsernameSet extends StatefulWidget{
  const UsernameSet({Key? key}) : super(key: key);

  @override
  State<UsernameSet> createState() => _UsernameSetState();
}

class _UsernameSetState extends State<UsernameSet> {

  final TextEditingController _newUsername = TextEditingController();
  String oldUsername = "", errorText = "";
  int submitPressCount = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async{
    SharedPreferences savedData = await SharedPreferences.getInstance();
    setState(() {
      if(savedData.getString('username') != null) {
        oldUsername = savedData.getString('username').toString();
        submitPressCount = 0;
      }
      else{
        oldUsername = "No Username set";
        submitPressCount = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text("Set Username"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: Colors.grey[300],
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Row(
                    children: <Widget>[
                      const Text("Current Username :  "),
                      Text(oldUsername),
                    ],
                  ),
                ),
                const SizedBox(height: 15,),
                const Text("Set your Username :", textAlign: TextAlign.left,),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: TextField(
                    controller: _newUsername,
                  ),
                ),
                const SizedBox(height: 20,),
                TextButton(
                  onPressed: () {
                    setState(() {
                        submitPressCount = (submitPressCount+1)%2;
                        if (_newUsername.text.isNotEmpty && oldUsername == "No Username set" && submitPressCount==0) {
                          // print("Setting Username to : ${_newUsername.text}");
                          errorText = "";
                          updateUsername(_newUsername.text);
                          getData();
                          Navigator.of(context).pop();
                        }
                        else if (_newUsername.text.isNotEmpty && oldUsername == "No Username set" && submitPressCount==1) {
                          // print("Setting Username to : ${_newUsername.text}");
                          errorText = "Once set, you cannot change your username..\nPress button again to set your final username";
                        }
                        else if((_newUsername.text.isNotEmpty && submitPressCount==1)|| oldUsername != "No Username set"){
                          errorText = "We recommend to give all surveys with a single Username.";
                        }
                        else {
                          submitPressCount = (submitPressCount-1)%2;
                          errorText = "Please enter a username !!";
                        }
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
                  ),
                  child: const Text("Change Username", style: TextStyle(color: Colors.black),),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Text(
                    errorText,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                    maxLines: 3,
                    softWrap: true,
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  updateUsername(String newUsername) async{
    SharedPreferences savedData = await SharedPreferences.getInstance();
    await savedData.setString('username', newUsername);
    // String x = savedData.getString('username').toString();
    // print("username is now : $x");
  }
}
