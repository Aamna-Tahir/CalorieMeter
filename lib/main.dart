import 'package:calorieMeter/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'notification_service.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: const FirebaseOptions(
        apiKey: "AIzaSyAi8N903H-GRt_mahBZ6-J-mSBhwe18m7U",
        authDomain: "caloriemeterai.firebaseapp.com",
        projectId: "caloriemeterai",
        storageBucket: "caloriemeterai.firebasestorage.app",
        messagingSenderId: "557658843205",
        appId: "1:557658843205:web:d2cffb0                                                                          91977b946c01b2c"
    ));
  }
  else{
    await Firebase.initializeApp();
  }
  tz.initializeTimeZones();
  await initializeNotifications();
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Lora',

      ),
      
      home: SplashScreen(),
    );
  }
}

