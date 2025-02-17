import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:calorieMeter/login.dart';
import 'package:calorieMeter/dashboard.dart';
import 'package:calorieMeter/auth_service.dart';
class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
  final _auth = AuthService();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword=TextEditingController();
  final _contact=TextEditingController();
  bool isChecked = false; // Checkbox state
  bool _obscurePassword = true; // For the Password field
  bool _obscureConfirmPassword = true; // For the Confirm Password field

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            // Add dynamic padding so the keyboard doesn't overflow
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Image(
                          height: 140,
                          width: 90,
                          image: AssetImage('assets/logoIcon.png'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 20), // Adjust value as needed
                      child: const Text(
                        'Let’s Create Your Account!',
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Lora',
                          color: Colors.black,
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Already Registered? ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Lora',
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const login(), // Your login screen
                                ),
                              );
                            },
                            child: const Text(
                              'Login',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Lora',
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.green,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Name Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _name,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
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
                      prefixIcon:
                      const Icon(Icons.person, size: 20, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Email Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
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
                      prefixIcon: const Icon(Icons.email_outlined,
                          size: 20, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Password Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _password,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
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
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 25,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Confirm Password Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _confirmPassword,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Confirm your password',
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
                const SizedBox(height: 15),

                // Contact Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _contact,
                    decoration: InputDecoration(
                      hintText: 'Enter your contact',
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
                      prefixIcon: const Icon(Icons.phone,
                          size: 20, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Checkbox
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? newValue) {
                          setState(() {
                            isChecked = newValue!;
                          });
                        },
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                      ),
                      const Expanded(
                        child: Text(
                          'By continuing, you agree with our Terms & Conditions and Privacy Policy.',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lora',
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // Signup Button
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
                   onPressed: _signup,

                    child: const Text(
                      'Signup',
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Lora',
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
  goToHome(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => dashboard()),
  );

  _signup() async {
    final user =
    await _auth.createUserWithEmailAndPassword(_email.text, _password.text);
    if (user != null) {
      log("User Created Succesfully");
      goToHome(context);
    }
  }
}
