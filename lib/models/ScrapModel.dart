import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:scrap/function/authentication/AuthenService.dart';

class ScrapModel extends Equatable {
  final String text;
  final String writer;
  final DateTime litteredTime;
  final LatLng position;
  final String geoHash;
  final String writerUid;
  final String scrapId;
  final String scrapRegion;
  final ScrapTransaction transaction;

  ScrapModel(
      {this.text,
      this.litteredTime,
      this.position,
      this.geoHash,
      this.scrapId,
      this.scrapRegion,
      this.writer,
      this.writerUid,
      this.transaction});

  @override
  List<Object> get props => [
        text,
        litteredTime,
        position,
        scrapId,
        scrapRegion,
        writer,
        writerUid,
        transaction
      ];

  DocumentReference get path {
    var date = DateFormat('yyyyMMdd').format(this.litteredTime);
    var docPath =
        'Scraps/${this.scrapRegion}/$date/${this.litteredTime.hour}/ScrapDailys-${this.scrapRegion}/${this.scrapId}';
    return fireStore.document(docPath);
  }

  Map<String, dynamic> get toJSON {
    var location = {'geohash': this.geoHash, 'geopoint': this.position};
    var scrap = {
      'text': this.text,
      'writer': this.writer,
      'timeStamp': this.litteredTime
    };
    return {
      'id': this.scrapId,
      'region': this.scrapRegion,
      'uid': this.writerUid,
      'scrap': scrap,
      'position': location
    };
  }

  factory ScrapModel.fromJSON(Map<String, dynamic> json,
      {@required ScrapTransaction transaction}) {
    var scrap = json['scrap'];
    var position = json['position']['geopoint'];
    return ScrapModel(
        text: scrap['text'],
        writer: scrap['writer'],
        litteredTime: scrap['timeStamp'].toDate(),
        scrapId: json['id'],
        writerUid: json['uid'],
        scrapRegion: json['region'],
        transaction: transaction,
        geoHash: json['position']['geohash'],
        position: LatLng(position.latitude, position.longitude));
  }
}

class ScrapTransaction extends Equatable {
  final int like;
  final int picked;
  final int comment;
  final double point;

  ScrapTransaction({this.comment, this.like, this.picked, this.point});

  @override
  List<Object> get props => [like, picked, comment, point];

  factory ScrapTransaction.fromJSON(Map<dynamic, dynamic> json) =>
      ScrapTransaction(
          like: json['CPN'].abs(),
          picked: json['PPN'].abs(),
          comment: json['comment'].abs(),
          point: json['point'].toDouble());
}