import 'package:architech1/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Firebase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _fireStore = Firestore.instance;
  Future<DocumentSnapshot> getDocumentSnapShot(String uid) async {
    return _fireStore.collection("Users").document(uid).get();
    //TODO BURASI ÖNEMLİ USER1 UID İLE DEĞİŞTİRİLECEK
    //TODO UID LOGİN VEYA REGİSTERDAN SONRA ALINACAK.
  }

  saveData(String uid, DateTime time) {
    var tempDate = DateTime(time.year, time.month);
    var secData = Map<String, bool>();

    if (user.dates.containsKey(tempDate)) {
      var obj = user.dates[tempDate];
      obj[time.day] = true;
      obj.forEach((key, value) {
        secData[key.toString()] = value;
      });
      print(secData);
    } else {
      user.dates[tempDate] = {time.day: true};
      var obj = user.dates[tempDate];
      obj[time.day] = true;
      obj.forEach((key, value) {
        secData[key.toString()] = value;
      });
      print(secData);
    }

    var data = Map<String, dynamic>();
    var key = tempDate.year.toString() + "-" + tempDate.month.toString();
    data[key] = secData;
    _fireStore
        .collection("Users")
        .document(uid)
        .updateData(data)
        .catchError((err) => print(err));
  }

  setDataFromSnapShot(DocumentSnapshot snapShot) {
    var data = snapShot.data;
    var listMount = Map<DateTime, Map<int, bool>>();
    var uid = data["uid"].toString();
    data.forEach((doc, res) {
      var splitedDoc = doc.split("-");

      if (splitedDoc.length == 2) {
        var docString = splitedDoc[0];
        docString += "-";
        docString += splitedDoc[1];
        var tempMap = Map<String, bool>.from(data[docString]);
        var mountMap = Map<int, bool>();
        tempMap.forEach((k, v) {
          mountMap[int.parse(k)] = v;
        });

        var date = DateTime(int.parse(splitedDoc[0]), int.parse(splitedDoc[1]));

        listMount[date] = mountMap;
      }
    });

    user = new User(uid: uid, dates: listMount);
  }

  Future<AuthResult> register(String email, String pw) async {
    return _auth.createUserWithEmailAndPassword(email: email, password: pw);
  }

  Future<AuthResult> login(String email, String pw) async {
    return _auth.signInWithEmailAndPassword(email: email, password: pw);
  }

  Future<void> addUserUidToUsers(AuthResult result) {
    return _fireStore
        .collection("Users")
        .document(result.user.uid)
        .setData({"uid": result.user.uid});
  }

  Future<FirebaseUser> checkUser() {
   return  _auth.currentUser();
  }

  logOut() async{
     _auth.signOut();
  }
}
