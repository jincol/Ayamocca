import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ayamocca/screens/welcome_screen.dart';
import 'register1_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        String userNickname = await fetchUserNicknameFromDatabase();
        _navigateToWelcomeScreen(userNickname);
      } catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error de inicio de sesión'),
              content: Text(
                'Hubo un error al iniciar sesión. Por favor, verifica tus credenciales.',
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

  Future<String> fetchUserNicknameFromDatabase() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
    String userNickname = snapshot['apodo'];
    return userNickname;
  }

  void _navigateToWelcomeScreen(String userNickname) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => WelcomeScreen(userNickname: userNickname)),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userNickname = await fetchUserNicknameFromDatabase();
      _navigateToWelcomeScreen(userNickname);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        /*decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),*/
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary, // Color del borde
                      width: 2, // Ancho del borde
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50, // Radio del avatar
                    backgroundColor: Colors.transparent, // Fondo transparente
                    child: ClipOval(
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.cover,
                        width: 100,
                        // Tamaño de la imagen igual al radio del avatar
                        height: 100,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            filled: false,
                            fillColor: Colors.transparent,
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingresa tu email';
                            }
                            return null;
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
                            filled: false,
                            fillColor: Colors.transparent,
                          ),
                          obscureText: true,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingresa tu contraseña';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 32.0),
                      SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _login(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            /*shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),*/
                          ),
                          child: Text(
                            'Iniciar Sesión',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen1()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5))
                        ),
                        child: Text(
                          'Registrarse',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: 'demo@gmail.com',
                              password: 'aataaata',
                            );
                            String userNickname =
                                await fetchUserNicknameFromDatabase();
                            _navigateToWelcomeScreen(userNickname);
                          } catch (error) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error de inicio de sesión'),
                                  content: Text(
                                    'Hubo un error al iniciar sesión. Por favor, verifica tus credenciales.',
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
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                          /*shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),*/
                        ),
                        child: Text(
                          'Invitado/Demo',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
