import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String getFormattedDate(dynamic date) {
  Timestamp timestamp = date as Timestamp;
  DateTime dateTime = timestamp.toDate();
  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
  return formattedDate;
}
