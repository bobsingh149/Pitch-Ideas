import 'package:flutter/material.dart';
import 'package:pitch/Providers/category.dart';
import 'package:pitch/Screens/userInput.dart';




class CatItem extends StatefulWidget {
  final  id;
  final String title;
  final String url;
  final Function setfav;
  final Category c;
  bool isfavorite;

  CatItem(
      {this.id, this.title, this.url, this.setfav, this.c, this.isfavorite});

  @override
  _CatItemState createState() => _CatItemState();
}

class _CatItemState extends State<CatItem> {
 
  Widget build(BuildContext context) {
      print('categotyItem build method');
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(UserInput.routename,
            arguments: {'edit': false,'cattitle':widget.title,'catid':widget.id});
      },
      splashColor:Colors.red,
          
      child: GridTile(
        child: Image.network(
          widget.url,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Icon(Icons.category),
          title: FittedBox(
              child: Text(
            widget.title,
            style: Theme.of(context).textTheme.bodyText1,
          )),
          trailing: IconButton(
            icon: widget.isfavorite
                ? Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : Icon(Icons.favorite_border),
            onPressed: () {
              setState(() {
                widget.isfavorite = !widget.isfavorite;
                widget.setfav(widget.c);
              });
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: widget.isfavorite
                    ? Text('Selected category added to your favotites')
                    : Text('Selected category removed from your favotites'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    setState(() {
                      widget.isfavorite = !widget.isfavorite;
                      widget.setfav(widget.c);
                    });
                  },
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}
