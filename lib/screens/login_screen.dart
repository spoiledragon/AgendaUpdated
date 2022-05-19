// ignore_for_file: avoid_print, prefer_const_constructors, non_constant_identifier_names, unnecessary_null_comparison

import 'package:agendapp/clases/user_class.dart';
import 'package:agendapp/screens/home_page.dart';
import 'package:agendapp/screens/registration_screen.dart';
import 'dart:convert';
import "package:flutter/material.dart";
import 'package:http/http.dart';
import "package:shared_preferences/shared_preferences.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

//--------------------------------------------------------

//--------------------------------------------------------
//editing controllers
class _LoginScreenState extends State<LoginScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();
  //editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  void _showToast(BuildContext context, msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  Future<void> save_data(String text, String text2) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("mail", text);
    await pref.setString("password", text2);
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    get_data();
  }

  late String email;
  late String password;
  Future<void> get_data() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    email = pref.getString("mail")!;
    password = pref.getString("password")!;

    if (email != null || email != "") {
      emailController.text = email;
      passwordController.text = password;
    }
  }

  @override
  Widget build(BuildContext context) {
    //funciones de ingreso

    void login() async {
      try {
        var url =
            "https://thelmaxd.000webhostapp.com/Agendapp/login.php?email=" +
                emailController.text +
                "&pass=" +
                passwordController.text;
        Response response = await get(Uri.parse(url));
        //aqui sacamos los datos y los metemos a un array
        var user_Response = json.decode(response.body);
        //definimos la lista
        List<User> Usuarios = [];
        //recorremos el arreglo en el caso de que haya mas de uno
        for (var responsejson in user_Response) {
          Usuarios.add(User.fromJson(responsejson));
        }
        print(Usuarios[0].id);
        //print("Esta data");
        if (Usuarios[0].error == "69") {
          //shared preferenes aqui
          save_data(emailController.text, passwordController.text);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(Usuarios[0].id)));
          _showToast(context, "Logeado con Exito");
        } else {
          _showToast(context, "Login Incorrecto");
        }
      } catch (e) {
        print(e);
      }
    }

    //fields
    //------------------------------------------------------
    //email field
    final emailField = TextFormField(
      autofocus: false,

      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      //validator: (){},
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.email),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          labelText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          )),
    );

    //------------------------------------------------------
    //Password  field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      //validator: (){},
      onSaved: (value) {
        passwordController.text = value!;
      },
      obscureText: true,
      textInputAction: TextInputAction.next,

      decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          labelText: "Password",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: Colors.white,
                width: 2,
              ))),
    );
    //------------------------------------------------------
    //boton
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.black,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          login();
        },
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    //-----------------------------------------------------
    //render
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            //para mover que tan grande lo queremos
            padding: const EdgeInsets.fromLTRB(400, 100, 400, 100),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 100,
                      child: SizedBox(
                          width: 400,
                          height: 400,
                          child: ClipOval(
                            child: Image.asset(
                              "assets/este.png",
                              fit: BoxFit.cover,
                            ),
                          ))),
                  SizedBox(height: 45),
                  emailField,
                  SizedBox(height: 20),
                  passwordField,
                  SizedBox(height: 30),
                  loginButton,
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("No tienes Cuenta?  "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrarionScreen()));
                        },
                        child: Text(
                          "Registrate",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.blue),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
