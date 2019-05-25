import 'package:flutter/material.dart';
import 'Database.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  final _registerkey = GlobalKey<FormState>();

  RegisterProvider user = RegisterProvider();

  final userid = TextEditingController();
  final name = TextEditingController();
  final age = TextEditingController();
  final password = TextEditingController();

  bool check = false;

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Form(
        key: _registerkey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 30, 0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  labelText: "User Id",
                  hintText: "User Id ต้องมีความยาวอยู่ในช่วง 6-12 ตัวอักษร",
                  icon: Icon(Icons.person, size: 40)),
              controller: userid,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please fill out this form";
                } else if (value.length < 6 || value.length > 12) {
                  return "User Id ความยาวตัวอักษรไม่ถูกต้อง";
                }
              },
            ),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "ex. 'Kawisara Bunyen'",
                  icon: Icon(Icons.account_circle, size: 40),
                ),
                controller: name,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill out this form";
                  }
                  if (value.split(" ").length != 2) {
                    print(value.split(" ").length);
                    return "กรุณากรอกชื่อให้ถูกต้อง";
                  }
                }),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "Age",
                  hintText: "อายุต้องเป็นตัวเลข อยู่ระหว่าง 10-80 ปี",
                  icon: Icon(Icons.event_note, size: 40),
                ),
                controller: age,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill out this form";
                  } else if (!isNumeric(value) ||
                      int.parse(value) < 10 ||
                      int.parse(value) > 80) {
                    return "กรุณากรอกอายุให้ถูกต้อง";
                  }
                }),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Password ควรมีความยาวมากกว่า 6",
                  icon: Icon(Icons.lock, size: 40),
                ),
                controller: password,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty || value.length <= 6) {
                    return "Please fill out this form";
                  }
                }),
            RaisedButton(
              child: Text("REGISTER NEW ACCOUNT"),
              onPressed: () async {
                await user.open("user.db");
                List<User> allUser = await user.getAllUser();

                User data = User();

                data.username = userid.text;
                data.name = name.text;
                data.age = age.text;
                data.password = password.text;

                for (var i = 0; i < allUser.length; i++) {
                  if (data.username == allUser[i].username) {
                    this.check = true;
                  }
                }

                if (_registerkey.currentState.validate()) {
                  if(!check){
                    userid.text = "";
                    name.text = "";
                    age.text = "";
                    password.text = "";

                    await user.insertUser(data);
                    Navigator.pop(context);
                    print('Register success');
                  }
                }

                this.check = false;
              },
            )
          ],
        ),
      ),
    );
  }
}
