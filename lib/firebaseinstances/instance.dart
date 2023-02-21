import 'package:cloud_firestore/cloud_firestore.dart';
class Instances{
  static CollectionReference userInstance = FirebaseFirestore.instance.collection("Users");
  static CollectionReference requestInstance = FirebaseFirestore.instance.collection("Requests");
  static CollectionReference receivedInstance = FirebaseFirestore.instance.collection("received");
   static CollectionReference notificationsInstance = FirebaseFirestore.instance.collection("notifications");
}