import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<void> createUser(UserCredential userCredential, String username) async{
  await FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set({
    'email': userCredential.user!.email,
    'username': username,
    'name': "None",
    'phone': "None",
    'gender': "None",
    'birthdate': "None",
    'profileImageURL': "",
    'ongoingQuests': [],
    'completedQuests': [],
    'prizesBought': [],
    'distanceWalked': 0,
    'points': 0,
    'totalPoints': 0
  });
}

Future<DocumentSnapshot> getUserDetails() async {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  return await FirebaseFirestore.instance.collection("Users").doc(currentUser!.email).get();
}

Future<void> updateUserData({String? name, String? phone, String? gender, String? birthdate, String? profileImageURL}) async {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    final Map<String, dynamic> updatedData = {};

    if (name != null) updatedData['name'] = name;
    if (phone != null) updatedData['phone'] = phone;
    if (gender != null) updatedData['gender'] = gender;
    if (birthdate != null) updatedData['birthdate'] = birthdate;
    if (profileImageURL != null) updatedData['profileImageURL'] = profileImageURL;

    if(updatedData.isNotEmpty){
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser.email)
          .update(updatedData);
    }
  }
}

Future<void> updateUserPoints(int points) async {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  final Map<String, dynamic> updatedData = {};
  final data = (await getUserDetails()).data() as Map<String, dynamic>;
  updatedData['points'] = data['points'] + points;

  if (currentUser != null) {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser.email)
        .update(updatedData);
  }
}

Future<DocumentSnapshot> getQuestDetails(String questID) async {
  return await FirebaseFirestore.instance.collection("Quests").doc(questID).get();
}

Future<QuerySnapshot<Map<String, dynamic>>> getAllQuests() async {
  return await FirebaseFirestore.instance.collection('Quests').get();
}

Future<QuerySnapshot<Map<String, dynamic>>> getAllPrizes() async {
  return await FirebaseFirestore.instance.collection('Prizes').get();
}

Future<DocumentSnapshot> getPrizeDetails(String prizeID) async {
  return await FirebaseFirestore.instance.collection("Prizes").doc(prizeID).get();
}

Future<void> addUserPrize(String prizeID) async{
  final User? currentUser = FirebaseAuth.instance.currentUser;

  await FirebaseFirestore.instance.collection('Users').doc(currentUser!.email).update({
    'prizesBought': FieldValue.arrayUnion([prizeID]),
  });
}

Future<void> addOngoingQuest(String questID) async{
  final User? currentUser = FirebaseAuth.instance.currentUser;

  await FirebaseFirestore.instance.collection('Users').doc(currentUser!.email).update({
    'ongoingQuests': FieldValue.arrayUnion([questID]),
  });
}

Future<void> removeOngoingQuest(String questID) async{
  final User? currentUser = FirebaseAuth.instance.currentUser;

  await FirebaseFirestore.instance.collection('Users').doc(currentUser!.email).update({
    'ongoingQuests': FieldValue.arrayRemove([questID]),
  });
}

Future<void> completeQuest(String questID) async{
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final doc = await getUserDetails();
  final data = doc.data() as Map<String, dynamic>;
  final quest = await getQuestDetails(questID);
  final questData = quest.data() as Map<String, dynamic>;

  if(data['ongoingQuests'].contains(questID)){
    await FirebaseFirestore.instance.collection('Users').doc(currentUser!.email).update({
      'ongoingQuests': FieldValue.arrayRemove([questID]),
      'completedQuests': FieldValue.arrayUnion([questID]),
      'points' : (data['points'] ?? 0) + questData['points'],
      'totalPoints' : (data['totalPoints'] ?? 0) + questData['points'],
    });
  }
}

Future<bool> isOngoing(String questID) async {
  final doc = await getUserDetails();
  final data = doc.data() as Map<String, dynamic>;

  return data['ongoingQuests'].contains(questID);
}

Future<bool> isCompleted(String questID) async {
  final doc = await getUserDetails();
  final data = doc.data() as Map<String, dynamic>;

  return data['completedQuests'].contains(questID);
}





Future<void> addQuest(String questName, String smallDescription, String description, int points, String imageURL) async{
  await FirebaseFirestore.instance.collection("Quests").doc().set({
    'questName': questName,
    'smallDescription': smallDescription,
    'description': description,
    'points': points,
    'imageURL': imageURL,
  });
}

Future<void> addMissingUserFields() async {
  final QuerySnapshot<Map<String, dynamic>> users = await FirebaseFirestore.instance.collection('Users').get();

  for (var doc in users.docs) {
    final Map<String, dynamic> updatedData = {};

    if (doc.data()['birthdate'] == null) updatedData['birthdate'] = "None";
    if (doc.data()['completedQuests'] == null) updatedData['completedQuests'] = [];
    if (doc.data()['gender'] == null) updatedData['gender'] = "None";
    if (doc.data()['name'] == null) updatedData['name'] = "None";
    if (doc.data()['ongoingQuests'] == null) updatedData['ongoingQuests'] = [];
    if (doc.data()['phone'] == null) updatedData['phone'] = "None";
    if (doc.data()['points'] == null) updatedData['points'] = 0;
    if (doc.data()['profileImageURL'] == null) updatedData['profileImageURL'] = "";
    if (doc.data()['totalPoints'] == null) updatedData['totalPoints'] = 0;
    if (doc.data()['distanceWalked'] == null) updatedData['distanceWalked'] = 0;
    if (doc.data()['prizesBought'] == null) updatedData['prizesBought'] = [];

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(doc.id)
        .update(updatedData);
  }
}