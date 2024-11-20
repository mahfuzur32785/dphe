import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateConverter {
  static String formatDate(DateTime? dateTime) {
    return DateFormat('dd-MMM-yyyy hh:mm a').format(dateTime!);
  }

  static String formatDate1(DateTime dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss-SSS").format(dateTime);
  }

  static String dateFormatStyle2(DateTime? dateTime) {
    String date = DateFormat('dd-MMM-yyyy').format(dateTime!);
    return date;
  }

  static String apiDbDateFormatI(String date) {
    DateFormat df = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ"); //2023-10-19T09:58:52.000000Z
    var dt = df.parse(date);
    return DateFormat("dd-MMM-yyyy").format(dt);
  }

//apiyyyyMMdd to dd-MMM-yyyy
  static String dateFormatFromAPi(String date) {
    DateFormat inputFormat = DateFormat("dd-MMM-yyyy");
    DateFormat outputFormat = DateFormat("yyyy-MM-dd");
    DateTime inputDate = outputFormat.parse(date);

    return inputFormat.format(inputDate);
  }

  static DateTime lvLogicDate(String date) {
    DateFormat inputFormat = DateFormat("dd-MMM-yyyy");
    DateFormat outputFormat = DateFormat("yyyy-MM-dd");
    DateTime inputDate = outputFormat.parse(date);
    var d = inputFormat.format(inputDate);
    var samd = inputFormat.parse(d);
    return samd;
  }

  static String dateToApiResDate(String date) {
    DateFormat inputFormat = DateFormat("dd-MMM-yyyy");
    DateTime inputDate = inputFormat.parse(date);
    DateFormat outputFormat = DateFormat("yyyy-MM-dd");
    return outputFormat.format(inputDate);
  }

//dd-MMM-yyyy to apiyyyyMMdd
  static String dateFromForAPi(String date) {
    DateFormat inputFormat = DateFormat("dd-MMM-yyyy");
    DateFormat outputFormat = DateFormat("yyyy-MM-dd");
    DateTime inputDate = outputFormat.parse(date);

    return inputFormat.format(inputDate);
  }

  static DateTime dateFormatymday(String dateTime) {
    return DateFormat("yyyy-MM-dd").parse(dateTime);
  }

  static String dateFormatymday2(DateTime? dateTime) {
    String date = DateFormat("yyyy-MM-dd").format(dateTime!);
    return date;
  }

  static DateTime convertStringToDateFormat2(String dateTime) {
    return DateFormat("dd-MMM-yyyy").parse(dateTime);
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat('dd-MMM-yyyy hh:mm a').parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String? dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime!, true).toLocal();
  }

  static String timeFromApi(String date) {
    var dt = isoStringToLocalDate(date);
    var time = localTimeToIsoString(dt);
    return time;
  }

  static String localDateTowM(
    DateTime? dateTime,
  ) {
    return DateFormat('MM-yyyy').format(dateTime!);
  }

  static String specDat(String? dateTime) {
    return DateFormat.EEEE().format(isoStringToLocalDate(dateTime!));
  }

  static String isoStringToLocalTimeOnly(String? dateTime) {
    return DateFormat('dd-M-yyyy').format(isoStringToLocalDate(dateTime!));
  }

  static String isoStringToLocalDateOnly(String? dateTime) {
    return DateFormat('dd:MM:yy').format(isoStringToLocalDate(dateTime!));
  }

  static String localDateToIsoString(DateTime? dateTime) {
    return DateFormat('dd-MMM-yyyy').format(dateTime!);
  }

  static String localDateToIsoStringWithoutHighphen(DateTime? dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime!);
  }

  static String localTimeToIsoString(DateTime? dateTime) {
    return DateFormat('hh:mm a').format(dateTime!);
  }

  static String getDateTime(String dateFromServer) {
    dateFromServer = dateFromServer.replaceAll(" ", "");
    dateFromServer = dateFromServer.replaceAll("T", " ");
    return dateFromServer;
  }

  static String formatDateIOS(String date, {bool isTime = false, bool isTimeDate = false}) {
    DateTime dateTime = DateTime.parse(date);
    String dat;
    if (isTime) {
      dat = DateConverter.localTimeToIsoString(dateTime);
    } else if (isTimeDate) {
      dat = DateConverter.formatDate(dateTime);
    } else {
      dat = DateConverter.localDateToIsoString(dateTime);
    }
    return dat;
  }

  static String formatDateIOSWithDay(String? date, {bool isTime = false}) {
    DateTime? dateTime = DateTime.parse(date!);
    String? dat;
    if (isTime) {
      dat = localTimeToIsoString(dateTime);
    } else {
      dat = DateFormat('EEEE, d MMMM,yyyy').format(dateTime);
    }

    return dat;
  }

  static String formatDayofDate(String date, {bool isTime = false}) {
    DateTime dateTime = DateTime.parse(date);
    String dat;
    if (isTime) {
      dat = localTimeToIsoString(dateTime);
    } else {
      dat = DateFormat('dd-MMM-yyyy').format(dateTime);
    }

    return dat;
  }

  static String onlyDay(String? date, {bool isTime = false}) {
    DateTime? dateTime = DateTime.parse(date!);

    String? dat;

    if (isTime) {
      dat = localTimeToIsoString(dateTime);
    } else {
      dat = DateFormat('EEEE').format(dateTime);
    }

    return dat;
  }

  static String? formatDateInTIME(String date, {bool isTime = false, bool isTimeDate = false}) {
    DateTime dateTime = DateTime.parse(date);
    String? dat;
    if (isTime) {
      dat = DateConverter.formatDate(dateTime);
    } else if (isTimeDate) {
      dat = DateFormat('HH:mm:ss').format(dateTime);
    }
    return dat;
  }
}
