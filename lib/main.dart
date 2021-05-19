import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/pages/all_pages.dart';
import 'package:main_flutter_app/pages/search_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/commons.dart';

FirebaseFirestore firestore;
FirebaseAuth firebaseAuth;
FirebaseStorage firebaseStorage;

Future<SharedPreferences> prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  int pageIndex = 0;
  bool isOpenDrawer = false;
  bool isNavigationRailExtended = true;
  User currentUser;

  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    firebaseAuth = FirebaseAuth.instance;
    firebaseAuth.authStateChanges().listen((User user) {
      if (user != null) {
        setState(() {
          widget.currentUser = user;
        });
      }
    });
    firestore = FirebaseFirestore.instance;
    firebaseStorage = FirebaseStorage.instance;
  }

  updateCurrentUser() {
    setState(() {
      widget.currentUser = firebaseAuth.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> mainPages =
        getMainPageConfig(context, firestore, firebaseStorage);

    PageController _pageController =
        new PageController(initialPage: widget.pageIndex);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) {
          Size deviceSize = MediaQuery.of(context).size;
          bool isMobileDevice = deviceSize.width <= 600;

          List<Widget> drawerItems = [
            createDrawerHeader(context, this, widget.currentUser),
            ListTile(
              title: Text('ログアウト'),
              onTap: () {
                firebaseAuth.signOut();
                setState(() {
                  widget.currentUser = null;
                });
              },
            ),
          ];
          drawerItems.addAll(mainPages
              .map(
                (e) => ListTile(
                  title: Text(e['pageName'].toString()),
                  onTap: () {
                    setState(
                      () {
                        widget.pageIndex = e['pageIndex'];
                        _pageController.jumpToPage(e['pageIndex']);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              )
              .toList());

          return Scaffold(
            appBar: AppBar(
              leading: isMobileDevice
                  ? null
                  : IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        setState(() {
                          widget.isNavigationRailExtended =
                              !widget.isNavigationRailExtended;
                        });
                      },
                    ),
              title: Text(mainPages[widget.pageIndex]['pageName'] as String),
              actions: [
                IconButton(
                  icon: Hero(
                    child: Icon(Icons.search),
                    tag: 'search_view',
                  ),
                  onPressed: () {
                    showSearch(context: context, delegate: SearchView());
                  },
                )
              ],
            ),
            drawer: isMobileDevice
                ? Drawer(
                    child: ListView(
                      children: drawerItems,
                    ),
                  )
                : null,
            backgroundColor: Colors.white,
            body: isMobileDevice
                ? PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: mainPages
                        .map((e) => e['pageWidget'] as Widget)
                        .toList(),
                  )
                : Row(
                    children: [
                      NavigationRail(
                        leading: createDrawerHeader(
                            context, this, widget.currentUser),
                        backgroundColor: Colors.grey[50],
                        extended: widget.isNavigationRailExtended,
                        elevation: 3.0,
                        destinations: mainPages
                            .map(
                              (e) => NavigationRailDestination(
                                icon: Icon(e['pageIcon'] as IconData),
                                label: Text(e['pageName'] as String),
                              ),
                            )
                            .toList(),
                        onDestinationSelected: (int index) {
                          setState(() {
                            widget.pageIndex = index;
                            _pageController.jumpToPage(index);
                          });
                        },
                        selectedIndex: widget.pageIndex,
                      ),
                      Expanded(
                        child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _pageController,
                          children: mainPages
                              .map((e) => e['pageWidget'] as Widget)
                              .toList(),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

DrawerHeader createDrawerHeader(
  BuildContext context,
  MyAppState parent,
  User currentUser,
) {
  return DrawerHeader(
    child: Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: currentUser != null
              ? GestureDetector(
                  child: Image.network(
                    currentUser.photoURL != null
                        ? currentUser.photoURL
                        : 'https://firebasestorage.googleapis.com/v0/b/mainflutterproject.appspot.com/o/cd_jackets%2Fjacket_sc_0004.jpg?alt=media&token=91986472-7b84-40e6-9079-ac54be8ef3e9',
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                      builder: (BuildContext context) => AccountPage(
                        firebaseAuth: firebaseAuth,
                      ),
                    ))
                        .then(
                      (value) {
                        parent.setState(() {
                          parent.widget.currentUser = firebaseAuth.currentUser;
                        });
                      },
                    );
                  },
                )
              : IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return LoginPage(
                            firebaseAuth: firebaseAuth,
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}
