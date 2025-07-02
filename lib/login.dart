import 'package:flutter/material.dart';
import 'package:calorieMeter/forgotpwd.dart';
import 'package:calorieMeter/dashboard.dart';
import 'welcome.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  bool _obscureConfirmPassword = true;
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
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
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
                                builder: (context) => const forgotPwd(),
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
                        if (_email.text.isEmpty || _password.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text(
                                  "Missing Information",
                                  style: TextStyle(color: Colors.black),
                                ),
                                content: const Text(
                                  "Please enter email and password first.",
                                  style: TextStyle(color: Colors.black),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.green,
                                    ),
                                    child: const Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }

                        try {
                          User? user = await _auth.loginUserWithEmailAndPassword(
                            _email.text.trim(),
                            _password.text.trim(),
                          );

                          if (user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const dashboard()),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          print("FirebaseAuthException code: ${e.code}");
                          String errorMessage = "Login failed. Please try again.";

                          if (e.code == 'user-not-found') {
                            errorMessage = "No user found with this email.";
                          } else if (e.code == 'wrong-password') {
                            errorMessage = "Incorrect password. Please try again.";
                          } else if (e.code == 'invalid-email') {
                            errorMessage = "Invalid email format.";
                          } else if (e.code == 'user-disabled') {
                            errorMessage = "This user account has been disabled.";
                          }
                          else if (e.code == 'invalid-credential') {
                            errorMessage = "Incorrect email or password. Please try again.";
                          }

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text(
                                  "Login Error",
                                  style: TextStyle(color: Colors.black),
                                ),
                                content: Text(
                                  errorMessage,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.green,
                                    ),
                                    child: const Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (e) {
                          
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text(
                                  "Unexpected Error",
                                  style: TextStyle(color: Colors.black),
                                ),
                                content: Text(
                                  e.toString(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.green,
                                    ),
                                    child: const Text("OK"),
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
                      const Text(
                        'Don\'t have an account? ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, fontFamily: 'Lora', color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const welcome()),
                          );
                        },
                        child: const Text(
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
