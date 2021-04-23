import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/search_view.dart';

import 'common/commons.dart';

FirebaseFirestore firestore;
FirebaseAuth firebaseAuth;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  int pageIndex = 0;
  bool isOpenDrawer = false;
  bool isNavigationRailExtended = true;
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    firestore = FirebaseFirestore.instance;
    firebaseAuth = FirebaseAuth.instance;
    // firebaseAuth.signInAnonymously();

    List<Map<String, dynamic>> mainPages = getMainPageConfig(context);
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
                      children: mainPages
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
                          .toList(),
                    ),
                  )
                : null,
            backgroundColor: Colors.white,
            body: isMobileDevice
                ? PageView(
                    controller: _pageController,
                    children: mainPages
                        .map((e) => e['pageWidget'] as Widget)
                        .toList(),
                  )
                : Row(
                    children: [
                      NavigationRail(
                        extended: widget.isNavigationRailExtended,
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
