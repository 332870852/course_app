import 'package:flutter/material.dart';
import './InputFields.dart';

class FormContainer extends StatelessWidget {
  FormContainer({Key key,@required this.usernameController,@required this.pwdController}) : super(key: key);
  final TextEditingController usernameController;
  final TextEditingController pwdController;
  @override
  Widget build(BuildContext context) {
    return (new Container(
      margin: new EdgeInsets.symmetric(horizontal: 20.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Form(
              child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new InputFieldArea(
                hint: "手机号码/邮箱",
                obscure: false,
                icon: Icons.person_outline,
                controller: usernameController,
              ),
              new InputFieldArea(
                hint: "密码",
                obscure: true,
                passWordVisible: false,
                icon: Icons.lock_outline,
                controller: pwdController,
              ),
            ],
          )),
        ],
      ),
    ));
  }
}
