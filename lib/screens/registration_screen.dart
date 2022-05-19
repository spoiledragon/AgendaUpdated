// ignore_for_file: avoid_print, prefer_const_constructors

import "package:flutter/material.dart";
import "package:http/http.dart";

class RegistrarionScreen extends StatefulWidget {
  const RegistrarionScreen({Key? key}) : super(key: key);

  @override
  State<RegistrarionScreen> createState() => _RegistrarionScreenState();
}

class _RegistrarionScreenState extends State<RegistrarionScreen> {
  final _formKey = GlobalKey<FormState>();
  final userEditingController = TextEditingController();
  final codeEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();
  //Funcion de Registro
  void singIn() async {
    try {
      bool emailValid = RegExp("[a-z]+.+@+alumnos.udg.mx")
          .hasMatch(emailEditingController.text);
      if (emailValid) {
        var url =
            "https://thelmaxd.000webhostapp.com/Agendapp/signin.php?username=" +
                userEditingController.text +
                "&password=" +
                passwordEditingController.text +
                "&email=" +
                emailEditingController.text +
                "&code=" +
                codeEditingController.text;

        //print(url);
        Response response = await get(Uri.parse(url));
        print(response.body);
        if (response.body == "1") {
          //Aqui es que si jalo
          _showToast(context, "Registrado con exito");
          Navigator.of(context).pop();
          //Si se ha registrado hay que mostrar algo
        }
        if (response.body == "0") {
          _showToast(context, "Codigo Ya registrado");
        }
        if (response.body == "2") {
          _showToast(context, "Registrado sin exito");
        }
      }else{
        
        _showToast(context, "Ingresa un Correo Valido");
      }
      //https://thelmaxd.000webhostapp.com/Agendapp/signin.php?username=krystalpaws&password=patitas123&email=krystal.dragoness@gmail.com&code=213203106
    } catch (e) {
      print(e);
    }
  }

  void _showToast(BuildContext context, mensaje) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(mensaje),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
//User field
    final userField = TextFormField(
      autofocus: false,
      controller: userEditingController,
      keyboardType: TextInputType.emailAddress,
      //validator: (){},
      onSaved: (value) {
        userEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "UserName",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
//Code field
    final codeField = TextFormField(
      autofocus: false,
      controller: codeEditingController,
      keyboardType: TextInputType.number,
      //validator: (){},
      onSaved: (value) {
        codeEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.code),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Code",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

//email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      //validator: (){},
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
//password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      keyboardType: TextInputType.emailAddress,
      //validator: (){},
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      obscureText: true,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
//password field2
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      keyboardType: TextInputType.emailAddress,
      //validator: (){},
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      obscureText: true,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

//boton
    final registerButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.black,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          singIn();
        },
        child: Text(
          "Register",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    //lo que se renderiza

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              //para mover que tan grande lo queremos
              padding: const EdgeInsets.fromLTRB(400, 100, 400, 100),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    userField,
                    SizedBox(height: 20),
                    codeField,
                    SizedBox(height: 20),
                    emailField,
                    SizedBox(height: 20),
                    passwordField,
                    SizedBox(height: 20),
                    confirmPasswordField,
                    SizedBox(height: 20),
                    registerButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
