import 'package:cxgenie/models/customer.dart';
import 'package:cxgenie/models/message.dart';
import 'package:flutter/material.dart';

/// This method calculates the align that the modal of reactions should have.
/// This is an approximation based on the size of the message and the
/// available space in the screen.
double calculateReactionsHorizontalAlignment(
  Customer? user,
  Message message,
  BoxConstraints constraints,
  double? fontSize,
  Orientation orientation,
) {
  // divFactor is the percentage of the available space that the message takes.
  // When the divFactor is bigger than 0.5 that means that the messages is
  // bigger than 50% of the available space and the modal should have an offset
  // in the direction that the message grows. When the divFactor is smaller
  // than 0.5 then the offset should be to he side opposite of the message
  // growth.
  // In resume, when divFactor > 0.5 then result > 0, when divFactor < 0.5
  // then result < 0.
  var divFactor = 0.5;

  final signal = user?.id == message.sender?.id ? 1 : -1;
  final result = signal * (1 - divFactor * 2.0);

  // Ensure reactions don't get pushed past the edge of the screen.
  //
  // This happens if divFactor is really big. When this happens, we can simply
  // move the model all the way to the end of screen.
  return result.clamp(-1, 1);
}
