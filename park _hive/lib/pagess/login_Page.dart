import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:social/sevices/firebase_service.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  double? _deviceHeight, _deviceWidth;

  FirebaseService? _firebaseService;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  String? _email;
  String? _password;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _titleWidget(),
                _imageWidget(),
                _loginform(),
                _loginbutton(),
                _registerPageLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return const Text(
      "Spot Saver",
      style: TextStyle(
        color: Color.fromARGB(255, 22, 202, 196),
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Widget _socialImageWidget() {
  //   return Container(
  //     height: _deviceHeight! * 1.2,
  //     width: _deviceHeight! * 1.2,
  //     decoration: const BoxDecoration(
  //       image: DecorationImage(
  //         fit: BoxFit.contain,
  //         image: AssetImage("social\assets\images\social_image.png"),
  //       ),
  //     ),
  //   );
  //}

  Widget _loginform() {
    return Container(
      height: _deviceHeight! * 0.18,
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_emailTextField(), _passwordTextField()],
        ),
      ),
    );
  }

  Widget _imageWidget() {
    return Container(
      height: _deviceHeight! * 0.3,
      width: _deviceWidth! * 0.3,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/parked-car.png"),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: "Enter your email id",
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        fillColor: Colors.white,
      ),
      onSaved: (_value) {
        setState(
          () {
            _email = _value;
          },
        );
      },
      validator: (_value) {
        bool _result = _value!.contains(
          RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
        );
        return _result ? null : "Please enter a valid email id";
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      obscureText: true,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: "Enter the password",
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        fillColor: Colors.white,
      ),
      onSaved: (_value) {
        setState(
          () {
            _password = _value;
          },
        );
      },
      validator: (_value) => _value!.length > 5
          ? null
          : "Please enter the password greater then 5 charachter",
    );
  }

  Widget _loginbutton() {
    return MaterialButton(
      onPressed: _loginUser,
      minWidth: _deviceWidth! * 0.1,
      height: _deviceHeight! * 0.03,
      color: Color.fromARGB(255, 22, 202, 196),
      child: const Text(
        "Login",
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Widget _loginbutton() {
  //   final ButtonStyle style =
  //       ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 20));

  //   return Center(
  //     child: Column(
  //       mainAxisSize: MainAxisSize.max,
  //       children: <Widget>[
  //         // ElevatedButton(
  //         //   style: style,
  //         //   onPressed: null,
  //         //   child: const Text('Disabled'),
  //         // ),
  //         const SizedBox(
  //           height: 20,
  //         ),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(32),
  //             ),
  //           ),
  //           onPressed: () {},
  //           child: const Text('Login'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _registerPageLink() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'register'),
      child: const Text(
        "don't have an account?register",
        style: TextStyle(
            color: Colors.blue, fontSize: 15, fontWeight: FontWeight.w200),
      ),
    );
  }

  void _loginUser() async {
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
      bool _result = await _firebaseService!
          .loginUser(email: _email!, password: _password!);
      if (_result) Navigator.popAndPushNamed(context, 'home');
    }
  }
}
