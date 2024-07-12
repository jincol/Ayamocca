import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProfileScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  Future<void> _selectImage(BuildContext context) async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      await _uploadImage(imageFile);
      // Aquí puedes realizar otras operaciones con la imagen, como mostrarla en la interfaz de usuario.
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      final firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance.ref().child('profile_images/${DateTime.now().millisecondsSinceEpoch}');
      final firebase_storage.UploadTask uploadTask = storageRef.putFile(imageFile);
      final firebase_storage.TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => null);
      final String downloadURL = await storageSnapshot.ref.getDownloadURL();
      // La imagen se ha subido correctamente a Firebase Storage y puedes acceder a su URL de descarga.
      print('URL de la imagen: $downloadURL');
    } catch (e) {
      // Ocurrió un error al subir la imagen.
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _selectImage(context),
          child: Text('Seleccionar imagen'),
        ),
      ),
    );
  }
}
