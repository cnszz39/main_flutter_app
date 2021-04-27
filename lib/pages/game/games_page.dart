import 'package:flutter/material.dart';
import 'package:main_flutter_app/common/commons.dart';

class GamesPage extends StatefulWidget {
  List<GameMenuItem> menuInfos = gameMenuItems();

  @override
  GamesPageState createState() => new GamesPageState();
}

class GamesPageState extends State<GamesPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
      child: SingleChildScrollView(
        child: ExpansionPanelList(
          expansionCallback: (int panelIndex, bool isExpanded) => {
            setState(() {
              widget.menuInfos[panelIndex].isExpanded = !isExpanded;
            })
          },
          children: widget.menuInfos
              .map(
                (gameMenuItem) => ExpansionPanel(
                  canTapOnHeader: true,
                  isExpanded: gameMenuItem.isExpanded,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return Text(gameMenuItem.title);
                  },
                  body: Align(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      children: gameMenuItem.games
                          .map(
                            (gameItem) => SizedBox(
                              width: 256.0,
                              child: ListTile(
                                leading: gameItem.gameJacket != null
                                    ? gameItem.gameJacket
                                    : null,
                                title: Text(gameItem.gameTitle),
                                subtitle: Text(gameItem.gameDescription),
                                onTap: () {},
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

ExpansionPanel gameListChild() => ExpansionPanel(
      isExpanded: false,
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Text('header');
      },
      body: Text('test'),
    );

// class GameListChild extends StatelessWidget {
//   final String strTitle;
//   final IconData leadingIcon;
//   final List<Map<String, dynamic>> childInfos;

//   const GameListChild({
//     @required this.strTitle,
//     this.leadingIcon,
//     this.childInfos,
//   }) : assert(strTitle != null);

//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       leading: leadingIcon != null ? Icon(leadingIcon) : Icon(Icons.games),
//       title: Text(strTitle),
//       children: childInfos
//           .map(
//             (gameInfo) => SizedBox(
//               child: Card(
//                 child: Row(
//                   children: [
//                     Image.asset(
//                       'images/jacket_sc_0004.jpg',
//                       width: 128.0,
//                       height: 128.0,
//                     ),
//                     Text(gameInfo['gameTitle']),
//                   ],
//                 ),
//               ),
//             ),
//           )
//           .toList(),
//     );
//   }
// }
