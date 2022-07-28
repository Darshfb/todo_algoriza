import 'package:flutter/material.dart';

class PopMenu extends StatefulWidget {
  const PopMenu({Key? key}) : super(key: key);

  @override
  State<PopMenu> createState() => _PopMenuState();
}
enum Menu { itemOne, itemTwo, itemThree, itemFour }
String _selectedMenu = '';
class _PopMenuState extends State<PopMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
        // Callback that sets the selected popup menu item.
        onSelected: (Menu item) {
          setState((){
            _selectedMenu = item.name;
          });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
              const PopupMenuItem<Menu>(
                value: Menu.itemOne,
                child: Text('Item 1'),
              ),
              const PopupMenuItem<Menu>(
                value: Menu.itemTwo,
                child: Text('Item 2'),
              ),
              const PopupMenuItem<Menu>(
                value: Menu.itemThree,
                child: Text('Item 3'),
              ),
              const PopupMenuItem<Menu>(
                value: Menu.itemFour,
                child: Text('Item 4'),
              ),
            ]);
  }
}
