import 'package:flutter/material.dart';
import 'package:pitch/Providers/chatcontacts.dart';
import 'package:pitch/Widgets/ConatctItem.dart';
import 'package:pitch/Widgets/drawer.dart';
import 'package:provider/provider.dart';

class ContactScreen extends StatefulWidget {
  static const routname = '/conntacts';
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  Contactsdata contactsdata;
  bool isloading = false;
  bool isinit = true;
  bool isinvcontacts;
  String ideaid;
  String title;
  bool nodata = false;

  @override
  void didChangeDependencies() {
    if (isinit) {
      setState(() {
        isloading = true;
      });
      contactsdata = Provider.of<Contactsdata>(context);
      final data =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      if (data != null) {
        isinvcontacts = data['inv'];
        ideaid = data['ideaid'];
        title = data['title'];
      }
      print('isinv $isinvcontacts');
      if (isinvcontacts == true) {
        contactsdata.getinvcontacts(ideaid).then((value) {
          if (!contactsdata.invcontacts.containsKey(ideaid)) nodata = true;
          setState(() {
            isloading = false;
          });
        });
      } else if (isinvcontacts == false) {
        contactsdata.getMyInvestment().then((value) {
          if (contactsdata.myinvestment.isEmpty) nodata = true;
          setState(() {
            isloading = false;
          });
        });
      } else {
        contactsdata.getcontacts().then((value) {
          if (contactsdata.contacts.isEmpty) nodata = true;
          setState(() {
            isloading = false;
          });
        }).catchError((error) {
          setState(() {
            isloading = false;
          });

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('No Internet Connection')));
        });
      }
    }
    isinit = false;
    super.didChangeDependencies();
  }

  Widget getlist() {
    print('isinvcontacts $isinvcontacts');
    if (isinvcontacts == true) {
      final invlist = contactsdata.invcontacts[ideaid];
      return ListView.builder(

          physics: BouncingScrollPhysics(),
          itemCount: invlist.length,
          itemBuilder: (ctx, idx) {
            return ContactItem(
              contactid: invlist[idx].userid,
              name: invlist[idx].name,
              url: invlist[idx].url,
              gender: invlist[idx].gender,
              age: invlist[idx].age.toString(),
              country: invlist[idx].country,
              profession: invlist[idx].profession,
            );
          });
    } else if (isinvcontacts == false) {
      final myinvlist = contactsdata.myinvestment;
      return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: myinvlist.length,
          itemBuilder: (ctx, idx) {
            return ContactItem(
              contactid: myinvlist[idx].userid,
              name: myinvlist[idx].name,
              url: myinvlist[idx].url,
              gender: myinvlist[idx].gender,
              age: myinvlist[idx].age.toString(),
              country: myinvlist[idx].country,
              profession: myinvlist[idx].profession,
            );
          });
    } else {
      final teamcontacts = contactsdata.contacts;
      return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: teamcontacts.length,
          itemBuilder: (ctx, idx) {
            return ContactItem(
              contactid: teamcontacts[idx].userid,
              name: teamcontacts[idx].name,
              url: teamcontacts[idx].url,
              gender: teamcontacts[idx].gender,
              age: teamcontacts[idx].age.toString(),
              country: teamcontacts[idx].country,
              profession: teamcontacts[idx].profession,
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      drawer: Drawers(),
      body: isloading
          ? Center(child: CircularProgressIndicator())
          : nodata
              ? Center(
                  child: Text('You don\'t have any Connections yet'),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 9,
                    ),
                    Expanded(
                      child: getlist(),
                    ),
                  ],
                ),
    );
  }
}
