import 'package:avalon_manage/scoped-models/registrations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class RegistrationListPage extends StatefulWidget {
  final RegistrationModel model;
  RegistrationListPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _RegistrationListPageState();
  }
}

class _RegistrationListPageState extends State<RegistrationListPage> {
  @override
  void initState() {
    this.widget.model.fetchRegistrations();
    super.initState();
  }

  Widget _buildRegistrationsList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, RegistrationModel model) {
        Widget content = CircularProgressIndicator();
        if (model.teams.length > 0 && !model.isLoading) {
          content = Container(
              child: ListView.builder(
            itemCount: model.teams.length,
            itemBuilder: (BuildContext context, i) {
              DateTime dateStamp = DateTime.fromMillisecondsSinceEpoch(
                  model.teams[i].timestamp);
              var formatter = new DateFormat('MMMMd');
              String date = formatter.format(dateStamp);            
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.blueGrey,
                  child: GestureDetector(
                    onTap: () {},
                    child: Card(
                        color:
                            model.teams[i].closed ? Colors.cyan : Colors.amber,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                model.teams[i].avalonMember.toUpperCase() +
                                    ": Rs. " +
                                    model.teams[i].paid.toString(),
                                textScaleFactor: 1.6,
                              ),
                              Text(
                                model.teams[i].number,
                                textScaleFactor: 1.4,
                              ),
                              Text(date),
                              Text("Expected amount: " +
                                  model.teams[i].expected.toString()),
                              Text("Pending amount: " +
                                  model.teams[i].pending.toString()),
                              model.isLoading
                                  ? CircularProgressIndicator()
                                  : model.teams[i].closed
                                      ? Text("Amount has been recieved")
                                      : RaisedButton(
                                          color: Colors.red,
                                          child: Text(
                                            "Recieved",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            _showDialog(model, i);
                                          },
                                        )
                            ],
                          ),
                        )),
                  ),
                ),
              );
            },
          ));
        } else if (model.isLoading) {
          content = Center(
            child: CircularProgressIndicator(),
          );
        }
        return RefreshIndicator(
          onRefresh: model.fetchRegistrations,
          child: content,
        );
      },
    );
  }

  void _showDialog(RegistrationModel model, int i) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Please confirm!"),
          content: new Text("Have you recieved Rs." +
              model.teams[i].paid.toString() +
              "\nfrom " +
              model.teams[i].avalonMember +
              "\nagainst the reg. number " +
              model.teams[i].number +
              " ?\nNote: You cannot undo this action"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes, I have!"),
              onPressed: () {
                model.closeRegistration(model.teams[i].number).then((value) {
                  Navigator.pop(context);
                  setState(() {
                    model.teams[i].closed = true;
                  });
                });
              },
            ),
            new FlatButton(
              child: new Text("No, I have not!"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<RegistrationModel>(
      builder: (BuildContext context, Widget child, RegistrationModel model) {
        return Scaffold(
          appBar: AppBar(
            title:
                Text("Registrations [" + model.teams.length.toString() + "]"),
          ),
          body: _buildRegistrationsList(),
          endDrawer: Drawer(
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
                Text("Total: Rs." + model.amount.toString(),textScaleFactor: 2.0,),
                Text("TPP: " + model.no_tpp.toString(),textScaleFactor: 2.0,),
                Text("PROJ: " + model.no_proj.toString(),textScaleFactor: 2.0,),
              ],
            ),
          ),
        );
      },
    );
  }
}
