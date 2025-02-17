import 'package:flutter/material.dart';
import 'package:calorieMeter/forgotpwd.dart';
import 'package:calorieMeter/dashboard.dart';
import 'signup.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  bool isChecked = false; // Checkbox state
  bool _obscureConfirmPassword = true; // For the Confirm Password field
  final _auth = AuthService();

  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true, // Make sure the screen resizes when the keyboard appears
        body: SafeArea(
          child: SingleChildScrollView(
            // Wrap the content to enable scrolling when the keyboard appears
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  const Column(
                    children: [
                      Image(
                        height: 150,
                        width: 100,
                        image: AssetImage('assets/logoIcon.png'),
                      ),
                      Text(
                        'Login to your account!',
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Lora',
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: const TextStyle(
                          fontSize: 17,
                          fontFamily: 'Lora',
                          color: Colors.black,
                        ),
                        fillColor: const Color(0xffF8F9FA),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xffE4E7E8)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xffE4E7E8)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.email_outlined, size: 20, color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                    child: TextFormField(
                      controller: _password,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                            fontSize: 17,
                            fontFamily: 'Lora',
                            color: Colors.black),
                        fillColor: const Color(0xffF8F9FA),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Color(0xffE4E7E8)),
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Color(0xffE4E7E8)),
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.lock_open,
                            size: 20, color: Colors.black),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 25,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const forgotpwd(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot password?',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Lora',
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: 300,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () async {
                        // Authenticate the user
                        User? user = await _auth.loginUserWithEmailAndPassword(_email.text, _password.text);

                        if (user != null) {
                          // If authentication is successful, navigate to dashboard
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => dashboard()),
                          );
                        } else {
                          // Show error message if credentials are wrong
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Login Failed"),
                                content: Text("Incorrect email or password. Please try again."),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 22, fontFamily: 'Lora', color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, fontFamily: 'Lora', color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const signup()),
                          );
                        },
                        child: Text(
                          ' Sign Up',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, fontFamily: 'Lora', fontWeight: FontWeight.w600, color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
