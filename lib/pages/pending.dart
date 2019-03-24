import 'package:avalon_manage/scoped-models/registrations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class PendingListPage extends StatefulWidget {
  final RegistrationModel model;
  PendingListPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _PendingListPageState();
  }
}

class _PendingListPageState extends State<PendingListPage> {
  @override
  void initState() {
    this.widget.model.pendingRegistrations();
    super.initState();
  }

  Widget _buildRegistrationsList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, RegistrationModel model) {
        Widget content = CircularProgressIndicator();
        if (model.pendingTeams.length > 0 && !model.isLoading) {
          content = Container(
              child: ListView.builder(
            itemCount: model.pendingTeams.length,
            itemBuilder: (BuildContext context, i) {
              DateTime dateStamp = DateTime.fromMillisecondsSinceEpoch(
                  model.pendingTeams[i].timestamp);
              var formatter = new DateFormat('MMMMd');
              String date = formatter.format(dateStamp);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.blueGrey,
                  child: Card(
                      color:
                          //model.pendingTeams[i].closed ? Colors.cyan :
                          Colors.amber,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              model.pendingTeams[i].avalonMember.toUpperCase() +
                                  ": Rs. " +
                                  model.pendingTeams[i].paid.toString(),
                              textScaleFactor: 1.6,
                            ),
                            Text(
                              model.pendingTeams[i].number,
                              textScaleFactor: 1.4,
                            ),
                            Text(date),
                            Text("Expected amount: " +
                                model.pendingTeams[i].expected.toString()),
                            Text("Pending amount: " +
                                model.pendingTeams[i].pending.toString()),
                            model.isLoading
                                ? CircularProgressIndicator()
                                : model.pendingTeams[i].closed
                                    ? Text("Amount has been recieved")
                                    : RaisedButton(
                                        color: Colors.red,
                                        child: Text(
                                          "Recieved",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          _showDialog(model, i);
                                        },
                                      )
                          ],
                        ),
                      )),
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
          onRefresh: model.pendingRegistrations,
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
              model.pendingTeams[i].paid.toString() +
              "\nfrom " +
              model.pendingTeams[i].avalonMember +
              "\nagainst the reg. number " +
              model.pendingTeams[i].number +
              " ?\nNote: You cannot undo this action"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes, I have!"),
              onPressed: () {
                model
                    .closeRegistration(model.pendingTeams[i].number)
                    .then((value) {
                  Navigator.pop(context);
                  setState(() {
                    model.pendingTeams[i].closed = true;
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
            title: Text("Pending [" +
                model.pendingTeams.length.toString() +
                "]"),
          ),
          body: _buildRegistrationsList(),
          endDrawer: Drawer(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Text(
                  "Total: Rs." + model.amount.toString(),
                  textScaleFactor: 2.0,
                ),
                Text(
                  "TPP: " + model.no_tpp.toString(),
                  textScaleFactor: 2.0,
                ),
                Text(
                  "PROJ: " + model.no_proj.toString(),
                  textScaleFactor: 2.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
