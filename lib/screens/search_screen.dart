import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_profile_screen.dart';
import 'profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _searchUsers(_searchController.text.toLowerCase());
    });
  }

  void _searchUsers(String searchQuery) {
    if (searchQuery.isEmpty) {
      setState(() {
        _searchResults = [];
      });
    } else {
      FirebaseFirestore.instance
          .collection('usuarios')
          .get()
          .then((QuerySnapshot querySnapshot) {
        List<DocumentSnapshot> results = [];
        querySnapshot.docs.forEach((DocumentSnapshot document) {
          String apodo = document.get('apodo').toLowerCase();
          if (apodo.contains(searchQuery)) {
            results.add(document);
          }
        });
        setState(() {
          _searchResults = results;
        });
      });
    }
  }

  Future<bool> _isCurrentUser(String userId) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.uid == userId;
  }

  Future<void> _navigateToProfileScreen(
      BuildContext context, String userId) async {
    if (await _isCurrentUser(userId)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(),
        ),
      );
    } else {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .get();

      Map<String, dynamic>? userData =
      userSnapshot.data() as Map<String, dynamic>?;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfileScreen(
            userData: userData,
            userId: userId,
          ),
        ),
      );
    }
  }

  Widget _buildUserList() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (BuildContext context, int index) {
        Map<String, dynamic>? userData =
        _searchResults[index].data() as Map<String, dynamic>?;
        String apodo = userData?['apodo'] ?? '';
        String career = userData?['career'] ?? '';
        String userId = _searchResults[index].id;
        String photoUrl = userData?['photoUrl'] ?? '';

        return Card(
          //color: Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              //backgroundColor: Colors.grey[300],
              child: photoUrl.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: photoUrl,
                placeholder: (context, url) =>
                    CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Icon(Icons.person),
              )
                  : Text(
                apodo.substring(0, 1).toUpperCase(),
                //style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              apodo,
              //style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              career,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              _navigateToProfileScreen(context, userId);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double positionValue = 0.3; // Cambiar el valor aquí (ejemplo: 0.3 para posicionamiento en un 30% de la altura disponible)

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: _searchController,
                //style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar en UCLink',
                  //hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FractionallySizedBox(
                alignment: Alignment(0.0, positionValue),
                heightFactor: 1.05,
                child: _buildUserList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
