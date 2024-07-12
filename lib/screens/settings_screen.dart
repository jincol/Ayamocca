import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  void _showDeleteConfirmation(BuildContext context) async {
    var isConfirmed = await showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text("Advertencia"),
        content: Text("¿Estás seguro de que quieres eliminar tu cuenta?"),
        actions: <Widget>[
          BasicDialogAction(
            title: Text("Cancelar"),
            onPressed: () {
              Navigator.pop(context, false); // No confirmado
            },
          ),
          BasicDialogAction(
            title: Text("Eliminar"),
            onPressed: () {
              Navigator.pop(context, true); // Confirmado
            },
          ),
        ],
      ),
    );

    if (isConfirmed) {
      _deleteUserData(context);
    }
  }

  void _deleteUserData(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Eliminar el usuario de Firebase Authentication
      await user.delete();

      // Eliminar los datos del usuario de Firestore
      await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).delete();

      // Navegar a la pantalla de inicio de sesión
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Pantalla de configuración'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showDeleteConfirmation(context),
              child: Text('Eliminar datos del usuario'),
            ),
          ],
        ),
      ),
    );
  }
}
