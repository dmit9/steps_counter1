import 'package:flutter/material.dart';

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({super.key});

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  late String _email;
  late String _password;
  bool showLogin = true;

  @override
  Widget build(BuildContext context) {

    Widget _logo(){
      return Padding(
        padding: EdgeInsets.only(top:30),
        child: Container(
          child: Align(
            child: Text('STEPS COUNTER', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),),
          ),
        ),
        );
    }

    Widget _input(Icon icon, String hint, TextEditingController controller, bool obsecure){
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          obscureText: obsecure,
          style: TextStyle(fontSize: 20, color: Colors.white),
          decoration: InputDecoration(
            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white30),
            hintText: hint,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white54, width: 1)
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white54, width: 1)
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: IconTheme(
                data: IconThemeData(color: Colors.white),
                child: icon
                ),
              )
          ),
        ),
      );
    }

    Widget _button(String text, void func()){
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          disabledForegroundColor: Colors.white.withOpacity(0.68),
         disabledBackgroundColor: Colors.white.withOpacity(0.12)),
        child:Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 20),
        ),
        onPressed: (){
          func();
        }
        );
    }

    Widget _form(String label, void func()){
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20, top: 10),
            child: _input(Icon(Icons.email), "EMAIL", _emailController, false)
            ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: _input(Icon(Icons.lock), "PASSWORD", _passwordController, true)
            ),
          SizedBox(height: 20,),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: _button(label, func)
            )
            ),    
        ],
      );
    }

    void _buttonActionr(){
      _email = _emailController.text;
      _password = _passwordController.text;
      _emailController.clear();
      _passwordController.clear();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          _logo(),
          (
            showLogin
            ? Column(
              children: <Widget>[
                _form('LOGIN', _buttonActionr),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    child: Text('Not registered yet? Register!', style: TextStyle(fontSize: 20, color: Colors.white30)),
                    onTap:() {
                      setState(() {
                        showLogin = false;
                      });
                    }
                    ),
               )
              ],
            )
            : Column(
              children: <Widget>[
                _form('REGISTER', _buttonActionr),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    child: Text('Already registered ? Login!', style: TextStyle(fontSize: 20, color: Colors.white30)),
                    onTap:() {
                      setState(() {
                        showLogin = true;
                      });
                    }
                    ),
               )
              ],
            )
          ),
    //      _form('LOGIN', _buttonActionr),
        ],
      ),
    );
  }
}

