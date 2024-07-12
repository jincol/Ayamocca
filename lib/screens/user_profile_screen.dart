import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/utils.dart';

class UserProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final String userId;

  const UserProfileScreen({required this.userData, required this.userId});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String currentUserId;
  late PageController _pageController;
  int _currentIndex = 0;
  bool _isLoadingSetFolling = true;

  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /*Future<void> getCurrentUserId() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        currentUserId = currentUser.uid;
      });
    }
  }*/
  Future<void> getCurrentUserId() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        currentUserId = currentUser.uid;
      });
      DocumentReference currentUserRef =
          _firestore.collection('usuarios').doc(currentUserId);
      DocumentSnapshot currentUserSnapshot = await currentUserRef.get();
      List<dynamic> currentUserSeguidos = currentUserSnapshot['seguidos'] ?? [];
      setState(() {
        _isFollowing = currentUserSeguidos.contains(widget.userId);
      });
    }
    setState(() {
      _isLoadingSetFolling = false;
    });
  }

  Future<void> _addToSeguidosSeguidores() async {
    setState(() {
      _isLoadingSetFolling = true;
    });

    if (currentUserId.isNotEmpty) {
      DocumentReference currentUserRef =
          _firestore.collection('usuarios').doc(currentUserId);
      DocumentReference visitedUserRef =
          _firestore.collection('usuarios').doc(widget.userId);

      DocumentSnapshot currentUserSnapshot = await currentUserRef.get();
      DocumentSnapshot visitedUserSnapshot = await visitedUserRef.get();

      List<dynamic> currentUserSeguidos = currentUserSnapshot['seguidos'] ?? [];
      List<dynamic> visitedUserSeguidores =
          visitedUserSnapshot['seguidores'] ?? [];

      if (!_isFollowing) {
        currentUserSeguidos.add(widget.userId);
        visitedUserSeguidores.add(currentUserId);

        await currentUserRef.update({'seguidos': currentUserSeguidos});
        await visitedUserRef.update({'seguidores': visitedUserSeguidores});

        setState(() {
          _isFollowing = true;
          widget.userData?['seguidos'] = currentUserSeguidos;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Usuario añadido a Seguidos y Seguidores.'),
        ));
      } else {
        currentUserSeguidos.remove(widget.userId);
        visitedUserSeguidores.remove(currentUserId);

        await currentUserRef.update({'seguidos': currentUserSeguidos});
        await visitedUserRef.update({'seguidores': visitedUserSeguidores});

        setState(() {
          _isFollowing = false;
          widget.userData?['seguidos'] = currentUserSeguidos;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Usuario eliminado de Seguidos y Seguidores.'),
        ));
      }

      /*

      if (!currentUserSeguidos.contains(widget.userId)) {
        currentUserSeguidos.add(widget.userId);
        visitedUserSeguidores.add(currentUserId);

        await currentUserRef.update({'seguidos': currentUserSeguidos});
        await visitedUserRef.update({'seguidores': visitedUserSeguidores});

        setState(() {
          widget.userData?['seguidos'] = currentUserSeguidos;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Usuario añadido a Seguidos y Seguidores.'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
          Text('El usuario ya se encuentra en Seguidos y Seguidores.'),
        ));
      }

       */
    }
    setState(() {
      _isLoadingSetFolling = false;
    });
  }

  Widget _buildProfileImage() {
    // Verificar si la imagen de perfil está disponible
    if (widget.userData!['profileImage'] != null) {
      // Si la imagen está disponible, mostrarla
      return CircleAvatar(
        backgroundImage: NetworkImage(widget.userData!['profileImage']),
      );
    } else {
      // Si no hay imagen de perfil, mostrar la primera letra del apodo
      String apodo = widget.userData!['apodo'] ?? '';
      String initial = apodo.isNotEmpty ? apodo[0].toUpperCase() : '';
      return CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          initial,
          style: TextStyle(fontSize: 32, color: Theme.of(context).colorScheme.primary),
        ),
      );
    }
  }

  Widget _buildPanel(String text) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userData == null || currentUserId.isEmpty) {
      // Puedes mostrar un indicador de carga o un mensaje de error aquí
      return CircularProgressIndicator();
    }

    List<dynamic>? seguidores = widget.userData!['seguidores'];
    List<dynamic>? seguidos = widget.userData!['seguidos'];
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
                          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                        ),
                        child: _buildProfileImage(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.userData!['apodo'] ?? '',
                          style: TextStyle(fontSize: 28,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${widget.userData!['nombres'] ?? ''}${widget.userData!['apellidos'] ?? ''}',
                          style: TextStyle(fontSize: 14,
                              //color: Colors.blueGrey
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
                          'Sección: ${widget.userData!['cycle'] ?? ''}',
                          style: TextStyle(fontSize: 14,
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
                          'Área: ${widget.userData!['career'] ?? ''}',
                          style: TextStyle(fontSize: 14,
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
                            text: seguidores?.length.toString() ?? '0',
                            style: TextStyle(fontSize: 14,
                                color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold
                            ),
                            children: [
                              TextSpan(
                                text: ' Seguidores ',
                                style:
                                    TextStyle(fontSize: 14,
                                        color: TextStyle().color
                                    ),
                              ),
                              TextSpan(
                                text: seguidos?.length.toString() ?? '0',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              TextSpan(
                                text: ' Seguidos',
                                style:
                                    TextStyle(fontSize: 14,
                                        //color: Colors.grey
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
                              color: _currentIndex == 0 ? Theme.of(context).colorScheme.primary : TextStyle().color,
                              fontWeight: _currentIndex == 0 ? FontWeight.bold : FontWeight.normal,

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
                              color: _currentIndex == 1 ? Theme.of(context).colorScheme.primary : TextStyle().color,
                              fontWeight: _currentIndex == 1 ? FontWeight.bold : FontWeight.normal,

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
                              color: _currentIndex == 2 ? Theme.of(context).colorScheme.primary : TextStyle().color,
                              fontWeight: _currentIndex == 2 ? FontWeight.bold : FontWeight.normal,
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
                        child: /*Text(
                          'Publicaciones del usuario',
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )*/_buildPublicationsOfUser(),
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
          Positioned(
            top: 25,
            right: 5,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed:
                    _isLoadingSetFolling ? null : _addToSeguidosSeguidores,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFollowing
                      ? Theme.of(context).colorScheme.tertiary.withGreen(2)
                      : Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  children: [
                    Visibility(
                      visible: !_isLoadingSetFolling,
                      child: Text(
                        _isFollowing ? 'Dejar de seguir' : 'Seguir',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _isLoadingSetFolling,
                      child: const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPublicationsOfUser() {
    String currentUserId = widget.userId;
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
              .where((doc) => doc['uid'] == currentUserId)
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
    String currentUserId = widget.userId;

    final DateTime creationTime =
    (document['fechaHora'] as Timestamp).toDate(); // Get the creation time
    final String timeAgo = Utils.getTimeAgo(creationTime); // Calculate the time ago

    final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    final List<dynamic> likes = data.containsKey('likes') ? data['likes'] : [];
    final bool isLiked =
        currentUserId != null && likes.contains(currentUserId);

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
}
