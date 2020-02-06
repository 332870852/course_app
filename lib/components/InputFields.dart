import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFieldArea extends StatefulWidget {
  final String hint;
  bool obscure;
  final IconData icon;
  final TextEditingController controller;
  bool passWordVisible;

  InputFieldArea(
      {this.hint,
      this.obscure,
      this.icon,
      this.controller,
      this.passWordVisible});

  @override
  _InputFieldAreaState createState() => _InputFieldAreaState();
}

class _InputFieldAreaState extends State<InputFieldArea> {
  @override
  Widget build(BuildContext context) {
    return (new Container(
      decoration: new BoxDecoration(
        border: new Border(
          bottom: new BorderSide(
            width: 0.5,
            color: Colors.white24,
          ),
        ),
      ),
      child: new TextFormField(
        controller: widget.controller,
        obscureText: widget.obscure,
        style: const TextStyle(
          color: Colors.white,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(32),
        ],
        decoration: new InputDecoration(
          icon: new Icon(
            widget.icon,
            color: Colors.white,
          ),
          suffixIcon: (widget.passWordVisible != null)
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      widget.obscure = widget.passWordVisible;
                      widget.passWordVisible = !widget.passWordVisible;
                    });
                  },
                  icon: widget.passWordVisible == true
                      ? Icon(
                          Icons.visibility,
                          color: Colors.black,
                        )
                      : Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                )
              : null,
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
          contentPadding: const EdgeInsets.only(
              top: 30.0, right: 30.0, bottom: 30.0, left: 5.0),
        ),
      ),
    ));
  }
}
