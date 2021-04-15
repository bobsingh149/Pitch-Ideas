import 'package:flutter/material.dart';
import 'package:pitch/Providers/ideas.dart';
import 'package:provider/provider.dart';

class Target extends StatefulWidget {
  static const String routename = '/target';
  //String id;
  //Target(this.id);
  @override
  _TargetState createState() => _TargetState();
}

class _TargetState extends State<Target> {
  bool init = true;
  bool isloading = false;
  UserIdeas userIdeas;
  TargetData targetData = new TargetData();
  String id;
  @override
  void didChangeDependencies() {
    if (init) {
      userIdeas = Provider.of<UserIdeas>(context);

      final args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

      id = args['id'];

      setState(() {
        isloading = true;
      });

      userIdeas.gettargetdata(id, false).then((value) {
        targetData = value;
        setState(() {
          isloading = false;
        });
      });
    }
    init = false;
    super.didChangeDependencies();
  }

  Widget titlecontainer(String title) {
    return Container(
      color: Colors.white30,
      alignment: Alignment.center,
      child: Text(
        '$title wise distribution',
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }

  List<Widget> getData(Map<String, double> dataMap) {
    List<Widget> widgets = [];
 print('data $dataMap');
    dataMap.forEach((key, value) {
      widgets.add(Column(
        children: [
          ListTile(
            leading: Text(key),
            title: Text(value.toString() + '%'),
          ),
          SizedBox(
            height: 35,
          ),
        ],
      ));
    });

    return widgets;
  }

  String agegrp(String grp) {
    if (grp == '1') {
      return 'Children 0-12';
    } else if (grp == '2') {
      return 'Teenagers 13-21';
    } else if (grp == '3') {
      return 'Young Adults 22-35';
    } else if (grp == '4') {
      return 'Miidle Aged 35-64';
    } else  {
      return 'Elderly 65 and above';
    }
  }

  List<Widget> getage(Map<String, double> dataMap) {
    List<Widget> widgets = [];
    print('age $dataMap');
    dataMap.forEach((key, value) {
      widgets.add(Column(
        children: [
          ListTile(
            leading: Text(agegrp(key)),
            title: Text(value.toString() + '%'),
          ),
          SizedBox(
            height: 35,
          ),
        ],
      ));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Your Target Audience '),
      ),
     // backgroundColor: Colors.white70,
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await userIdeas.gettargetdata(id, true);
              },
              child: Column(
                children: [
                  Expanded(
                    child: ListView(children: [
                    
                      titlecontainer('Age'),
                      ...getage(targetData.agegrp),
                      titlecontainer('Gender'),
                      ...getData(targetData.gender),
                      titlecontainer('Profession'),
                      ...getData(targetData.profession),
                        titlecontainer('Country'),
                      ...getData(targetData.country),
                    ]),
                  ),
                  Container(
                    height: 40,
                    width: double.infinity,
                    color: Colors.grey,
                    child: Text('Swipe down to see more insights',style: Theme.of(context).textTheme.bodyText1,))
                ],
              ),
            ),
    );
  }
}
