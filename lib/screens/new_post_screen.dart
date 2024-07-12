import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ayamocca/screens/post_screen.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final FocusNode _focusNode = FocusNode();
  String _userCareer = '';
  String _userApodo = '';
  String _userNombres = '';
  String _userApellidos = '';
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    _getUserData();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textFieldController.dispose();
    super.dispose();
  }

  Future<void> _getUserData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('usuarios').doc(userId).get();

      if (userSnapshot.exists) {
        setState(() {
          Map<dynamic, dynamic> userData = userSnapshot.data() as Map<dynamic, dynamic>;

          _userCareer = userData['career'] ?? '';
          _userApodo = FirebaseAuth.instance.currentUser!.displayName ?? '';
          _userNombres = userData['nombres'] ?? '';
          _userApellidos = userData['apellidos'] ?? '';
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> _createPost(String postContent) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String career = _userCareer;
      String apodo = await _getUserApodo(uid);
      String nombres = _userNombres;
      String apellidos = _userApellidos;
      DateTime now = DateTime.now();

      await FirebaseFirestore.instance.collection('publicacion').add({
        'contenido': postContent,
        'uid': uid,
        'apodo': apodo,
        'career': career,
        'nombres': nombres,
        'apellidos': apellidos,
        'fechaHora': now,
        'likes': [],
      });

      print('Publicación creada y almacenada en Firestore correctamente.');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PostScreen()),
      );
    } catch (error) {
      print('Error al crear y almacenar la publicación en Firestore: $error');
    }
  }

  Future<String> _getUserApodo(String uid) async {
    try {
      DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        return userData['apodo'] ?? '';
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        //backgroundColor: Color(0xFF0D0A49),
        body: Stack(
          children: [
            Positioned(
              top: 36,
              left: 12,
              child: IconButton(
                icon: Icon(Icons.close),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              top: 90,
              left: 12,
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/foto_perfil.png'),
              ),
            ),
            Positioned(
              top: 93,
              left: 70,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      onTap: null,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                _userCareer.isNotEmpty ? _userCareer : '',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.primaryContainer
                      ),
                      child: TextField(
                        controller: _textFieldController,
                        focusNode: _focusNode,
                        maxLines: null,
                        style: TextStyle(
                            //color: Colors.white
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Escribe aquí tu post...',
                          hintStyle: TextStyle(
                              //color: Theme.of(context).colorScheme.primaryContainer
                          ),
                          contentPadding: EdgeInsets.all(15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
            Positioned(
              top: 36,
              right: 12,
              child: ElevatedButton(
                onPressed: () {
                  String postContent = _textFieldController.text;
                  _createPost(postContent);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Publicar',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
