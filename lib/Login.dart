import 'package:flutter/material.dart';
import 'Database.dart';
import 'SharedPreferences.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }

}

class LoginState extends State<Login> {

  final _loginkey = GlobalKey<FormState>();

  final userid = TextEditingController();
  final password = TextEditingController();

  RegisterProvider user = RegisterProvider();

  int loginState = 0;

  bool loginCheck = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("LogIn"),
      ),
      body: Form(
        key: _loginkey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 30, 5),
          children: <Widget>[
            Image.asset(
              "images/login.png",
              width: 200,
              height: 200,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "User Id",
                icon: Icon(Icons.person, size: 40,)
              ),
              controller: userid,
              keyboardType: TextInputType.text,
              validator: (value){
                if (value.isNotEmpty){
                  this.loginState += 1;
                }
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Password",
                icon: Icon(Icons.lock, size: 40,)
              ),
              controller: password,
              obscureText: true,
              keyboardType: TextInputType.text,
              validator: (value){
                if (value.isNotEmpty){
                  this.loginState += 1;
                }
              },
            ),
            RaisedButton(
              child: Text("LOGIN"),
              color: Colors.yellow[300],
              onPressed: () async{
                _loginkey.currentState.validate();

                await user.open("user.db");

                Future<List<User>> allUser = user.getAllUser();

                if (loginState != 2){
                   Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Please fill out this form')));
                    this.loginState = 0;
                }
                else {
                  this.loginState = 0;
                  var userList = await allUser;
                  for (var i=0; i< userList.length; i++) {
                    if (userid.text == userList[i].username && password.text == userList[i].password) {
                      this.loginCheck = true;
                      SharePreference.id = userList[i].id;
                      SharePreference.setAttr(userList[i]);
                      print('User Valid');
                      break;
                    }
                  }

                  if(!loginCheck){
                    Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Invalid user or password')));
                  }
                  else {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                }
                
              },
            ),
            FlatButton(
              child: Container(
                child: Text("Register New Account", textAlign: TextAlign.right,),
              ),
              onPressed: (){
                Navigator.of(context).pushNamed('/register');
              },
              padding: EdgeInsets.only(left: 170.0),
            )
          ],
        ),
      ),
    );
  }

}