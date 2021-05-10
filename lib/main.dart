import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/pages/search_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/commons.dart';

FirebaseFirestore firestore;
FirebaseAuth firebaseAuth;
User currentUser;
Future<SharedPreferences> prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  int pageIndex = 2;
  bool isOpenDrawer = false;
  bool isNavigationRailExtended = true;

  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    firebaseAuth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;

    // currentUser = firebaseAuth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    currentUser = firebaseAuth.currentUser;

    List<Map<String, dynamic>> mainPages = getMainPageConfig(context, firestore);
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
            createDrawerHeader(context, this, currentUser)
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
                        leading: createDrawerHeader(context, this, currentUser),
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
              ? Image.network(currentUser.photoURL)
              : IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    showLoginDialog(context);
                  }),
        ),
      ],
    ),
  );
}

void showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text('ログイン'),
        children: [
          ElevatedButton(
              onPressed: () {
                GoogleAuthProvider googleAuthProvider =
                    new GoogleAuthProvider();
                googleAuthProvider.addScope(
                    'https://www.googleapis.com/auth/contacts.readonly');
                firebaseAuth
                    .signInWithPopup(googleAuthProvider)
                    .then((value) => {print(value.toString())})
                    .onError((error, stackTrace) =>
                        {print('Login error, ${error.toString()}')});
              },
              child: Text('login')),
        ],
      );
    },
  );
}
