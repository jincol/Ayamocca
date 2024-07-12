import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ayamocca/screens/welcome_screen.dart';
import 'login_screen.dart';
import 'register1_screen.dart';

class RegisterScreen3 extends StatefulWidget {
  final Map<String, dynamic> userData;

  RegisterScreen3({required this.userData});

  @override
  _RegisterScreen3State createState() => _RegisterScreen3State();
}

class _RegisterScreen3State extends State<RegisterScreen3> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _emailFieldTouched = false;
  bool _emailExists = false;
  bool _nicknameExists = false;

  final List<String> validDomains = ['gmail.com', 'hotmail.com', 'ucvvirtual.edu.pe'];

  bool _validateEmail(String email) {
    RegExp validDomains = RegExp(r"@(gmail\.com|hotmail\.com|ucvvirtual\.edu\.pe)$");
    return validDomains.hasMatch(email);
  }

  Future<bool> _checkEmailExists(String email) async {
    setState(() {
      _emailFieldTouched = true;
    });

    if (_validateEmail(email)) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('correo', isEqualTo: email)
          .get();

      bool exists = snapshot.docs.isNotEmpty;

      setState(() {
        _emailExists = exists;
      });

      return exists;
    } else {
      setState(() {
        _emailExists = false;
      });

      return false;
    }
  }

  Future<bool> _checkNicknameExists(String nickname) async {
    if (nickname.isNotEmpty) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('apodo', isEqualTo: nickname)
          .get();

      bool exists = snapshot.docs.isNotEmpty;

      setState(() {
        _nicknameExists = exists;
      });

      return exists;
    } else {
      setState(() {
        _nicknameExists = false;
      });

      return false;
    }
  }

  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        FirebaseAuth auth = FirebaseAuth.instance;
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        String uid = userCredential.user!.uid;

        // Agregar los campos seguidores y seguidos
        widget.userData['seguidores'] = [];
        widget.userData['seguidos'] = [];

        // Guardar los datos del usuario en Firestore utilizando el UID como ID del documento
        widget.userData['apodo'] = _nicknameController.text;
        widget.userData['correo'] = _emailController.text;
        widget.userData.remove('password');
        await FirebaseFirestore.instance.collection('usuarios').doc(uid).set(widget.userData);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registro exitoso'),
              content: Text('El registro se ha completado correctamente.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error de registro'),
              content: Text(
                'Hubo un error al registrar. Por favor, verifica los datos ingresados.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _navigateToWelcomeScreen(String userNickname) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen(userNickname: userNickname)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
       /* decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),*/
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text("Registro",
                  style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Theme.of(context).colorScheme.primary)
              ),
              SizedBox(height: 10),
              EasyStepper(
                activeStep: 2,
                //lineLength: 70,
                steps: [
                  EasyStep(
                    icon: Icon(Icons.account_circle),
                    title: 'Datos',
                  ),
                  EasyStep(
                    icon: Icon(Icons.business),
                    title: 'Área',
                  ),
                  EasyStep(
                    icon: Icon(Icons.payment),
                    title: 'Finalizar',
                  ),
                ],
                onStepReached: (index) {
                  setState(() {
                    //activeStep = index;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 50),
                    Container(
                      width: 350,
                      child: TextFormField(
                        controller: _nicknameController,
                        decoration: InputDecoration(
                          labelText: 'Apodo',
                          filled: true,
                          fillColor: Colors.transparent,
                          suffixIcon: _nicknameController.text.isNotEmpty
                              ? _nicknameExists
                              ? Icon(Icons.close, color: Colors.red)
                              : Icon(Icons.check, color: Colors.green)
                              : null,
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa tu apodo';
                          }
                          if (_nicknameExists) {
                            return 'El apodo ya está registrado';
                          }
                          return null;
                        },
                        onChanged: (String value) {
                          setState(() {
                            _nicknameExists = false;
                          });
                          _checkNicknameExists(value);
                        },
                      ),
                    ),

                    SizedBox(height: 16.0),
                    Container(
                      width: 350,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Correo Electrónico',
                          filled: true,
                          fillColor: Colors.transparent,
                          suffixIcon: _emailFieldTouched
                              ? _validateEmail(_emailController.text)
                              ? _emailExists
                              ? Icon(Icons.close, color: Colors.red)
                              : Icon(Icons.check, color: Colors.green)
                              : Icon(Icons.close, color: Colors.red)
                              : null,
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa tu correo electrónico';
                          }
                          if (!_validateEmail(value)) {
                            return 'El dominio del correo no es válido.';
                          }
                          if (_emailExists) {
                            return 'El correo ya está registrado.';
                          }
                          return null;
                        },
                        onChanged: (String value) {
                          setState(() {
                            _emailFieldTouched = true;
                          });
                          _checkEmailExists(value);
                        },
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      width: 350,
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        obscureText: true,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa tu contraseña';
                          }
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: () => _register(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        minimumSize: Size(350, 60),
                      ),
                      child: Text(
                        'Registrar',
                        style: TextStyle(fontSize: 18.0,
                            color: Theme.of(context).colorScheme.surface),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text('¿Ya tienes una cuenta? Inicia sesión aquí', style:
                      TextStyle(fontSize: 14.0, color:
                      Theme.of(context).colorScheme.secondary
                      )
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
