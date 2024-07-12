import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ayamocca/screens/login_screen.dart';
import 'package:ayamocca/screens/new_post_screen.dart';
import 'package:intl/intl.dart';
import 'package:ayamocca/screens/profile_screen.dart';
import 'package:ayamocca/screens/search_screen.dart';
import 'package:ayamocca/screens/settings_screen.dart';
import 'package:ayamocca/theme.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with AutomaticKeepAliveClientMixin {
  String _userNickname = '';
  String _userCareer = '';
  String? _userEmail = "";
  String _userNombres = '';
  String _userApellidos = '';
  int _currentIndex = 0;
  String? _currentUserId = null;

  PageController _pageController = PageController(initialPage: 0);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _navigateToProfileScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
  }

  void _navigateToSettingsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    _currentUserId = user?.uid;
    _userEmail = user?.email;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(_currentUserId)
          .get();
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        setState(() {
          _userNickname = data['apodo'] ?? '';
          _userCareer = data['career'] ?? '';
          _userNombres = data['nombres'] ?? '';
          _userApellidos = data['apellidos'] ?? '';
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onBottomNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color(0xFF0D0A49),
        centerTitle: true,
        title: Text(
          _userCareer, // Mostrar la carrera del usuario
          style: TextStyle(
            fontSize: 20,
            // color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
              // color: Theme.of(context).colorScheme.primaryContainer,
              ),
          Column(
            children: [
              Container(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _onBottomNavItemTapped(0);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                color: _currentIndex == 0
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            'Areas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: _currentIndex == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _currentIndex == 0
                                  ? Theme.of(context).colorScheme.primary
                                  : TextStyle().color,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _onBottomNavItemTapped(1);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            //color: Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                color: _currentIndex == 1
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            'Siguiendo',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: _currentIndex == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _currentIndex == 1
                                  ? Theme.of(context).colorScheme.primary
                                  : TextStyle().color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildPageView(),
              ),
            ],
          ),
          Positioned(
            bottom: 30.0,
            right: 30.0,
            child: Transform.scale(
              scale: 1.2,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewPostScreen()),
                  );
                },
                //backgroundColor: Color(0xFFF30119),
                child: Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.25),
          child: Column(
            children: [
              Container(
                //color: Colors.red,
                child: UserAccountsDrawerHeader(
                  accountName: Text(
                    _userNickname.isNotEmpty
                        ? (_userNickname[0].toUpperCase() +
                            _userNickname.substring(1))
                        : "",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(
                    _userEmail != null ? _userEmail! : "",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    child: Text(
                      _userNickname.isNotEmpty
                          ? _userNickname[0].toUpperCase()
                          : '',
                      style: TextStyle(
                          //color: Colors.white,
                          fontSize: 20),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  //color: Colors.white,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.person,
                          //color: Colors.red,
                        ),
                        title: Text(
                          'Perfil',
                          style: TextStyle(
                            //color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: _navigateToProfileScreen,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.settings,
                          //color: Colors.red,
                        ),
                        title: Text(
                          'Configuración',
                          style: TextStyle(
                            //color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: _navigateToSettingsScreen,
                      ),
                      Expanded(child: SizedBox()),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          //color: Colors.red,
                        ),
                        title: Text(
                          'Cerrar Sesión',
                          style: TextStyle(
                            //color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () async {
                          await _signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.message,
                //color: Colors.black
              ),
              onPressed: () {
                // TODO: Handle messages button tap
              },
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                //color: Colors.black
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.home,
                //color: Colors.black
              ),
              onPressed: () {
                // TODO: Handle home button tap
              },
            ),
            IconButton(
              icon: Icon(
                Icons.notifications,
                //color: Colors.black
              ),
              onPressed: () {
                // TODO: Handle notifications button tap
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      itemCount: 2, // Número total de páginas (paneles)
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _buildCarreraPage();
        } else {
          return _buildSiguiendoPage();
        }
      },
    );
  }

  Widget _buildCarreraPage() {
    super.build(context);
    return AutomaticKeepAlive(
      child: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('publicacion')
              .orderBy('fechaHora', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
              final String currentUserCareer =
                  _userCareer.toLowerCase(); // Get the user's career

              final List<QueryDocumentSnapshot> filteredDocuments = documents
                  .where(
                      (doc) => doc['career'].toLowerCase() == currentUserCareer)
                  .toList();
              return ListView.builder(
                itemCount: filteredDocuments.length,
                itemBuilder: (BuildContext context, int index) {
                  final document = filteredDocuments[index];

                  return _buildCardItem(document);
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildCardItem(QueryDocumentSnapshot<Object?> document) {
    final DateTime creationTime =
        (document['fechaHora'] as Timestamp).toDate(); // Get the creation time
    final String timeAgo = _getTimeAgo(creationTime); // Calculate the time ago

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
              Row(
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
                  Text(
                    likes.length.toString(),
                    style: TextStyle(
                      color: isLiked ? Colors.red : Colors.grey,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.bar_chart),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLike(String postId, bool isLiked) async {
    if (_currentUserId == null) return;

    print("post id $postId isLiked $isLiked");
    final postRef =
        FirebaseFirestore.instance.collection('publicacion').doc(postId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(postRef);
      if (!snapshot.exists) return;

      final data = snapshot.data() ?? {};
      final Set<dynamic> likes = Set<dynamic>.from(data['likes'] ?? []);

      if (isLiked) {
        likes.remove(_currentUserId);
      } else {
        likes.add(_currentUserId);
      }

      transaction.update(postRef, {'likes': likes.toList()});
      //transaction.set(postRef, {'likes': likes});
    });
  }

  Widget _buildSiguiendoPage() {
    super.build(context);
    return AutomaticKeepAlive(
      child: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('publicacion')
              .orderBy('fechaHora', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

              if (_currentUserId != null) {
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(_currentUserId)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      final Map<String, dynamic>? userData =
                          snapshot.data!.data() as Map<String, dynamic>?;

                      if (userData != null) {
                        final List<dynamic> followingList =
                            userData['seguidos'] ?? [];

                        final List<QueryDocumentSnapshot> filteredDocuments =
                            documents
                                .where(
                                    (doc) => followingList.contains(doc['uid']))
                                .toList();

                        return ListView.builder(
                          itemCount: filteredDocuments.length,
                          itemBuilder: (BuildContext context, int index) {
                            final document = filteredDocuments[index];
                            final DateTime creationTime =
                                (document['fechaHora'] as Timestamp).toDate();
                            final String timeAgo = _getTimeAgo(creationTime);

                            return _buildCardItem(
                                document); /*Card(
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
                                    Row(
                                      children: [
                                        Icon(Icons.comment),
                                        SizedBox(width: 4),
                                        Icon(Icons.favorite),
                                        SizedBox(width: 4),
                                        Icon(Icons.bar_chart),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                            );*/
                          },
                        );
                      } else {
                        return Text('No user data found.');
                      }
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                );
              } else {
                return Text('User not authenticated.');
              }
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d';
    } else {
      final formatter = DateFormat('dd/MM/yyyy');
      return '${formatter.format(time)}';
    }
  }

  Future<void> _refreshPosts() async {
    // Realizar una nueva consulta a Firestore para obtener las publicaciones actualizadas
    // y actualizar los datos en la pantalla
    setState(() {});
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Failed to sign out: $e');
    }
  }
}
