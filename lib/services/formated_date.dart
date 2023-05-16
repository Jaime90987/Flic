import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String getFormatedDate(date) {
  Timestamp timestamp = date;
  DateTime dateTime = timestamp.toDate();
  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
  return formattedDate.toString();
}
