import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:scoped_model/scoped_model.dart';
import '../database.dart';
import '../models/registration.dart';
import 'package:intl/intl.dart';

class RegistrationModel extends Model {
  FirebaseUser loggedInUser;
  DataBase dataBase;
  final databaseReference = FirebaseDatabase.instance.reference();
  bool isLoading = false;
  bool isAuthenticated = false;
  String name;
  String email;
  List<Team> teams = [];
  List<Team> pendingTeams = [];
  List<Team> todaysList = [];
  List<Team> openRegistrations = [];
  List<Team> webRegistrations = [];

  int amount = 0;
  int no_tpp = 0;
  int no_proj = 0;

  final List<String> listOMails = [
    'vedangnaik007@gmail.com',
    'ikshulaj@gmail.com',
    'subha26chem@gmail.com',
    'sayalishelke5600@gmail.com',
    'akshatachandure23@gmail.com',
  ];
  Future<bool> login() async {
    isLoading = true;
    notifyListeners();
    DataBase _dataBase = DataBase();
    this.dataBase = _dataBase;
    FirebaseUser user = await dataBase.signIn();
    this.loggedInUser = user;
    name = user.providerData[1].displayName.trim().toLowerCase();
    email = user.providerData[1].email.trim();
    this.isAuthenticated = listOMails.contains(email);
    if (!this.isAuthenticated) {
      signOut();
      isLoading = false;
      notifyListeners();
      return false;
    }
    isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> signOut() async {
    isLoading = true;
    notifyListeners();
    dataBase.signOut();
    isAuthenticated = false;
    isLoading = false;
    notifyListeners();
  }

  Future<Null> fetchRegistrations() async {
    isLoading = true;
    notifyListeners();
    teams = [];
    amount = 0;
    no_tpp = 0;
    no_proj = 0;
    databaseReference
        .child("registrations")
        .child("TPP")
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> registrations = snapshot.value;
      for (final key in registrations.keys) {
        Team newTeam = Team(
            altEmail: registrations[key]['altEmail'],
            altPhone: registrations[key]['altPhone'],
            leaderName: registrations[key]['leaderName'],
            leaderEmail: registrations[key]['leaderEmail'],
            leaderPhone: registrations[key]['leaderPhone'],
            teamName: registrations[key]['teamName'],
            memNum: registrations[key]['memNum'],
            paid: registrations[key]['paid'],
            pending: registrations[key]['pending'],
            avalonMember: registrations[key]['avalonMember'],
            number: registrations[key]['number'],
            college: registrations[key]['college'],
            closed: registrations[key]['closed'],
            competition: registrations[key]['competition'],
            category: registrations[key]['category'],
            expected: registrations[key]['expected'],
            timestamp: registrations[key]['timestamp']);
        teams.add(newTeam);
        amount += newTeam.paid;
        no_tpp += 1;
      }
      isLoading = false;
      notifyListeners();
    });

    isLoading = true;
    notifyListeners();
    databaseReference
        .child("registrations")
        .child("PROJ")
        .orderByKey()
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> registrations = snapshot.value;
      for (final key in registrations.keys) {
        Team newTeam = Team(
            altEmail: registrations[key]['altEmail'],
            altPhone: registrations[key]['altPhone'],
            leaderName: registrations[key]['leaderName'],
            leaderEmail: registrations[key]['leaderEmail'],
            leaderPhone: registrations[key]['leaderPhone'],
            teamName: registrations[key]['teamName'],
            memNum: registrations[key]['memNum'],
            paid: registrations[key]['paid'],
            pending: registrations[key]['pending'],
            avalonMember: registrations[key]['avalonMember'],
            number: registrations[key]['number'],
            college: registrations[key]['college'],
            closed: registrations[key]['closed'],
            category: registrations[key]['category'],
            competition: registrations[key]['competition'],
            expected: registrations[key]['expected'],
            timestamp: registrations[key]['timestamp']);
        teams.add(newTeam);
        amount += newTeam.paid;
        no_proj += 1;
      }
      if (teams.isNotEmpty && teams.length > 1) {
        teams.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      }

      isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> pendingRegistrations() async {
    isLoading = true;
    notifyListeners();
    pendingTeams = [];
    amount = 0;
    no_tpp = 0;
    no_proj = 0;
    databaseReference
        .child("registrations")
        .child("TPP")
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> registrations = snapshot.value;
      for (final key in registrations.keys) {
        Team newTeam = Team(
            altEmail: registrations[key]['altEmail'],
            altPhone: registrations[key]['altPhone'],
            leaderName: registrations[key]['leaderName'],
            leaderEmail: registrations[key]['leaderEmail'],
            leaderPhone: registrations[key]['leaderPhone'],
            teamName: registrations[key]['teamName'],
            memNum: registrations[key]['memNum'],
            paid: registrations[key]['paid'],
            pending: registrations[key]['pending'],
            avalonMember: registrations[key]['avalonMember'],
            number: registrations[key]['number'],
            college: registrations[key]['college'],
            closed: registrations[key]['closed'],
            competition: registrations[key]['competition'],
            category: registrations[key]['category'],
            expected: registrations[key]['expected'],
            timestamp: registrations[key]['timestamp']);
        if (!newTeam.closed) {
          pendingTeams.add(newTeam);
          amount += newTeam.paid;
          no_tpp += 1;
        }
      }

      isLoading = false;
      notifyListeners();
    });

    isLoading = true;
    notifyListeners();
    databaseReference
        .child("registrations")
        .child("PROJ")
        .orderByKey()
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> registrations = snapshot.value;
      for (final key in registrations.keys) {
        Team newTeam = Team(
            altEmail: registrations[key]['altEmail'],
            altPhone: registrations[key]['altPhone'],
            leaderName: registrations[key]['leaderName'],
            leaderEmail: registrations[key]['leaderEmail'],
            leaderPhone: registrations[key]['leaderPhone'],
            teamName: registrations[key]['teamName'],
            memNum: registrations[key]['memNum'],
            paid: registrations[key]['paid'],
            pending: registrations[key]['pending'],
            avalonMember: registrations[key]['avalonMember'],
            number: registrations[key]['number'],
            college: registrations[key]['college'],
            closed: registrations[key]['closed'],
            category: registrations[key]['category'],
            competition: registrations[key]['competition'],
            expected: registrations[key]['expected'],
            timestamp: registrations[key]['timestamp']);
        if (!newTeam.closed) {
          pendingTeams.add(newTeam);
          amount += newTeam.paid;
          no_proj += 1;
        }
      }
      if (pendingTeams.isNotEmpty && pendingTeams.length > 1) {
        pendingTeams.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      }
      isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> todaysRegistrations() async {
    isLoading = true;
    notifyListeners();
    todaysList = [];
    amount = 0;
    no_tpp = 0;
    no_proj = 0;
    DateTime todayStamp = DateTime.now();
    var formatter = new DateFormat('MMMMd');
    String today = formatter.format(todayStamp);
    databaseReference
        .child("registrations")
        .child("TPP")
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> registrations = snapshot.value;
      for (final key in registrations.keys) {
        Team newTeam = Team(
            altEmail: registrations[key]['altEmail'],
            altPhone: registrations[key]['altPhone'],
            leaderName: registrations[key]['leaderName'],
            leaderEmail: registrations[key]['leaderEmail'],
            leaderPhone: registrations[key]['leaderPhone'],
            teamName: registrations[key]['teamName'],
            memNum: registrations[key]['memNum'],
            paid: registrations[key]['paid'],
            pending: registrations[key]['pending'],
            avalonMember: registrations[key]['avalonMember'],
            number: registrations[key]['number'],
            college: registrations[key]['college'],
            closed: registrations[key]['closed'],
            competition: registrations[key]['competition'],
            category: registrations[key]['category'],
            expected: registrations[key]['expected'],
            timestamp: registrations[key]['timestamp']);
        DateTime dateStamp =
            DateTime.fromMillisecondsSinceEpoch(newTeam.timestamp);
        var formatter = new DateFormat('MMMMd');
        String date = formatter.format(dateStamp);
        if (date == today) {
          todaysList.add(newTeam);
          amount += newTeam.paid;
          no_tpp += 1;
        }
      }
      isLoading = false;
      notifyListeners();
    });
    isLoading = true;
    notifyListeners();
    databaseReference
        .child("registrations")
        .child("PROJ")
        .orderByKey()
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> registrations = snapshot.value;
      for (final key in registrations.keys) {
        Team newTeam = Team(
            altEmail: registrations[key]['altEmail'],
            altPhone: registrations[key]['altPhone'],
            leaderName: registrations[key]['leaderName'],
            leaderEmail: registrations[key]['leaderEmail'],
            leaderPhone: registrations[key]['leaderPhone'],
            teamName: registrations[key]['teamName'],
            memNum: registrations[key]['memNum'],
            paid: registrations[key]['paid'],
            pending: registrations[key]['pending'],
            avalonMember: registrations[key]['avalonMember'],
            number: registrations[key]['number'],
            college: registrations[key]['college'],
            closed: registrations[key]['closed'],
            category: registrations[key]['category'],
            competition: registrations[key]['competition'],
            expected: registrations[key]['expected'],
            timestamp: registrations[key]['timestamp']);
        DateTime dateStamp =
            DateTime.fromMillisecondsSinceEpoch(newTeam.timestamp);
        var formatter = new DateFormat('MMMMd');
        String date = formatter.format(dateStamp);
        if (date == today) {
          todaysList.add(newTeam);
          amount += newTeam.paid;
          no_proj += 1;
        }
      }
      if (todaysList.isNotEmpty && todaysList.length > 1) {
        todaysList.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      }
      isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> websiteRegistrations() async {
    isLoading = true;
    notifyListeners();
    webRegistrations = [];
    databaseReference.child('users').once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> registrations = snapshot.value;
      for (final key in registrations.keys) {
        Team newTeam = Team(
          teamName: key,
          paid: registrations[key]['paid'],
          avalonMember: registrations[key]['avalonMember'],
          closed: registrations[key]['closed'],
        );
        webRegistrations.add(newTeam);
      }

      isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> closeWebRegistration(String teamName) async {
    isLoading = true;
    notifyListeners();
    databaseReference.child('users').child(teamName).child('closed').set(true);

    isLoading = false;
    notifyListeners();
  }

  Future<Null> closeRegistration(String registrationNo) async {
    isLoading = true;
    notifyListeners();
    String currCat = "PROJ";
    if (registrationNo.contains("T")) {
      currCat = "TPP";
    }
    try {
      databaseReference
          .child("registrations")
          .child(currCat)
          .child(registrationNo)
          .child("closed")
          .set(true);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
