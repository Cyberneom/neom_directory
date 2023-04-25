import 'package:flutter/material.dart';

class BookingFilter { // extends Equatable {

  int numberOfMusicians;
  int numberOfGuests;
  double rating;
  RangeValues priceRange;
  DateTime? period;
  bool rehearsalRoom;
  bool recordStudio;
  bool liveSession;


  BookingFilter({
      this.numberOfMusicians = 5,
      this.numberOfGuests = 2,
      this.rating = 3,
      this.priceRange = const RangeValues(100,5000),
      this.period,
      this.rehearsalRoom = true,
      this.recordStudio = true,
      this.liveSession = true
  });

  //@override
  //List<Object?> get props => [rating];

  // static List<BookingFilter> filters =

}
