import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ayamocca/utils/utils.dart';
import 'edit_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

int _followersCount = 0;
int _followingCount = 0;

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profileData;
  bool _isLoading = true;
  PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  String _currentUserId = "";

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _currentUserId = user.uid;
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .get();
        setState(() {
          _profileData = snapshot.data() as Map<String, dynamic>?;
          _followersCount = _profileData?['seguidores'] != null
              ? _profileData!['seguidores'].length
              : 0;
          _followingCount = _profileData?['seguidos'] != null
              ? _profileData!['seguidos'].length
              : 0;
          _isLoading = false;
        });
      } else {
        throw Exception('Usuario no autenticado.');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('No se pudieron cargar los datos de perfil.'),
            actions: [
              TextButton(
                child: Text('Cerrar'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 200,
                color: Theme.of(context).colorScheme.inversePrimary,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 75),
                      child: Container(
                        width: 125,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2),
                        ),
                        child: _buildProfileImage(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _profileData != null &&
                                  _profileData!['apodo'] != null &&
                                  _profileData!['apodo'].toString().isNotEmpty
                              ? _profileData!['apodo'][0]
                                      .toString()
                                      .toUpperCase() +
                                  _profileData!['apodo'].toString().substring(1)
                              : '',
                          style: TextStyle(
                              fontSize: 28,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${_profileData != null && _profileData!['nombres'] != null ? _profileData!['nombres'] : ''}${_profileData != null && _profileData!['apellidos'] != null ? _profileData!['apellidos'] : ''}',
                          style: TextStyle(
                            fontSize: 14,
                            //color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.space_dashboard,
                          size: 14,
                          //color: Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Sección: ${_profileData != null && _profileData!['cycle'] != null ? _profileData!['cycle'] : ''}',
                          style: TextStyle(
                            fontSize: 14,
                            //color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.school,
                          size: 14,
                          //color: Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Área: ${_profileData != null && _profileData!['career'] != null ? _profileData!['career'] : ''}',
                          style: TextStyle(
                            fontSize: 14,
                            //color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 14,
                          //color: Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text.rich(
                          TextSpan(
                            text: '${_getFollowersCount()}',
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: ' Seguidores ',
                                style: TextStyle(
                                  fontSize: 14,
                                  //color: Colors.grey
                                ),
                              ),
                              TextSpan(
                                text: '${_getFollowingCount()}',
                                style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: ' Seguidos',
                                style: TextStyle(
                                  fontSize: 14,
                                  //    color: Colors.grey
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(0,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut);
                      },
                      child: Container(
                        width: 120,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _currentIndex == 0
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Publicaciones',
                            style: TextStyle(
                              fontSize: 16,
                              color: _currentIndex == 0
                                  ? Theme.of(context).colorScheme.primary
                                  : TextStyle().color,
                              fontWeight: _currentIndex == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(1,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut);
                      },
                      child: Container(
                        width: 120,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _currentIndex == 1
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Comentarios',
                            style: TextStyle(
                              fontSize: 16,
                              color: _currentIndex == 1
                                  ? Theme.of(context).colorScheme.primary
                                  : TextStyle().color,
                              fontWeight: _currentIndex == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(2,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut);
                      },
                      child: Container(
                        width: 120,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _currentIndex == 2
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Me gusta',
                            style: TextStyle(
                              fontSize: 16,
                              color: _currentIndex == 2
                                  ? Theme.of(context).colorScheme.primary
                                  : TextStyle().color,
                              fontWeight: _currentIndex == 2
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  children: [
                    Container(
                      //color: Color(0xFF0D0A49),
                      child: Center(
                        child:
                            _buildPublicationsOfUser() /*Text(
                          'Publicaciones del usuario',
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )*/
                        ,
                      ),
                    ),
                    Container(
                      //color: Color(0xFF0D0A49),
                      child: Center(
                        child: Text(
                          'Comentarios del usuario',
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      //color: Color(0xFF0D0A49),
                      child: Center(
                        child: Text(
                          'Me gusta del usuario',
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildPublicationsOfUser() {
    return Container(
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('publicacion')
            .orderBy('fechaHora', descending: true)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          final List<QueryDocumentSnapshot> filteredDocuments = documents
              .where((doc) => doc['uid'] == _currentUserId)
              .toList();

          if (filteredDocuments.isEmpty) {
            return Center(
              child: Text('No hay publicaciones para mostrar.'),
            );
          }

          return ListView.builder(
            itemCount: filteredDocuments.length,
            itemBuilder: (context, index) {
              final document = filteredDocuments[index];
              return _buildCardItem(document);
            },
          );
                },
      ),
    );
  }

  Widget _buildCardItem(QueryDocumentSnapshot<Object?> document) {
    final DateTime creationTime =
        (document['fechaHora'] as Timestamp).toDate(); // Get the creation time
    final String timeAgo = Utils.getTimeAgo(creationTime); // Calculate the time ago

    final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    final List<dynamic> likes = data.containsKey('likes') ? data['likes'] : [];
    final bool isLiked =
        _currentUserId != null && likes.contains(_currentUserId);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(document['apodo']),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  timeAgo,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${document['nombres']} ${document['apellidos']}'),
              SizedBox(height: 4),
              Text(document['contenido']),
              SizedBox(height: 4),
              /*Row(
                children: [
                  Icon(Icons.comment),
                  SizedBox(width: 4),
                  //Icon(Icons.favorite),
                  GestureDetector(
                    onTap: () => _handleLike(document.id, isLiked),
                    child: Icon(
                      Icons.favorite,
                      color: isLiked ? Colors.red : Colors.grey,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.bar_chart),
                ],
              ),*/
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildProfileImage() {
    if (_profileData != null && _profileData!['image'] != null) {
      return CachedNetworkImage(
        imageUrl: _profileData!['image'],
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(
          Icons.person,
          size: 50,
        ),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: Text(
          _profileData != null && _profileData!['apodo'] != null
              ? _profileData!['apodo'].toString().toUpperCase()[0]
              : '',
          style: TextStyle(
              fontSize: 24, color: Theme.of(context).colorScheme.primary),
        ),
      );
    }
  }

  int _getFollowersCount() {
    return _followersCount;
  }

  int _getFollowingCount() {
    return _followingCount;
  }
}
