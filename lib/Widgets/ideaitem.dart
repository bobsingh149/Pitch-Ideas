import 'package:flutter/material.dart';
import 'package:pitch/Screens/userInput.dart';

class IdeaItem extends StatefulWidget {
  final id;
  final title;
  final about;
  final img;
  final Function del;

  IdeaItem({this.id, this.title, this.about, this.img, this.del});

  @override
  _IdeaItemState createState() => _IdeaItemState();
}

class _IdeaItemState extends State<IdeaItem> {
  bool isloading = false;

  Future<void> delete(bool f) async {
    print(widget.id.runtimeType);
    print('id: ${widget.id}');

    if (f) {
      setState(() {
        isloading = true;
      });
    }
    await widget.del(widget.id);
    if (f) {
      setState(() {
        isloading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);

    return Dismissible(
      key: ValueKey(widget.id),
      onDismissed: (_) {
        delete(false);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red[400],
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 100,
        ),
      ),
      child: Container(
        color: isloading ? Colors.red : Colors.green,
        height: mediaquery.size.height * 0.5,
        alignment: Alignment.center,
        child: isloading
            ? CircularProgressIndicator(
                backgroundColor: Colors.white,
              )
            : Column(
                children: [
                  Container(
                      height: 200,
                      child: Image.network(
                        widget.img,
                        fit: BoxFit.cover,
                      )),
                  Container(
                    height: mediaquery.size.height * 0.2,
                    margin: EdgeInsets.all(7),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Color.fromRGBO(60, 75, 130, 1),
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.amber,
                    ),

                    //height: mediaquery.size.height*0.1,
                    //  color: Colors.green,

                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(widget.img),
                      ),
                      title:
                          //FittedBox(child:
                          Text(
                        widget.title,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      //),
                      subtitle:
                          //FittedBox(
                          //child:
                          Text(
                        widget.about,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      //),
                      trailing: Container(
                        width: 100,
                        child: Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        UserInput.routename,
                                        arguments: {
                                          'edit': true,
                                          'id': widget.id,
                                        });
                                  }),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => delete(true),
                                color: Color.fromRGBO(220, 0, 0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );

    /*return Container(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(title),
          Text(about),
          Image.network(
            img,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );*/
  }
}
