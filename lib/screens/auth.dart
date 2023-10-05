import 'package:flutter/material.dart';

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({super.key});

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late String _email;
  late String _password;
  bool showLogin = true;

  @override
  Widget build(BuildContext context) {

    Widget _logo(){
      return Padding(
        padding: const EdgeInsets.only(top:30),
        child: Container(
          child: const Align(
            child: Text('STEPS COUNTER', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),),
          ),
        ),
        );
    }

    Widget _input(Icon icon, String hint, TextEditingController controller, bool obsecure){
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          obscureText: obsecure,
          style: const TextStyle(fontSize: 20, color: Colors.white),
          decoration: InputDecoration(
            hintStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white30),
            hintText: hint,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white54, width: 1)
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white54, width: 1)
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: IconTheme(
                data: const IconThemeData(color: Colors.white),
                child: icon
                ),
              )
          ),
        ),
      );
    }

    Widget _button(String text, void Function() func){
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

    Widget _form(String label, void Function() func){
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child: _input(const Icon(Icons.email), "EMAIL", _emailController, false)
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _input(const Icon(Icons.lock), "PASSWORD", _passwordController, true)
            ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SizedBox(
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
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    child: const Text('Not registered yet? Register!', style: TextStyle(fontSize: 20, color: Colors.white30)),
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
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    child: const Text('Already registered ? Login!', style: TextStyle(fontSize: 20, color: Colors.white30)),
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

        ],
      ),
    );
  }
}

