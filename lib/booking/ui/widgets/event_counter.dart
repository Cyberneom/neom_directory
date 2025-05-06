import 'package:flutter/material.dart';
typedef CounterChangeCallback = void Function(num value);

class EventCounter extends StatelessWidget {

  final CounterChangeCallback onChanged;
  const EventCounter({
    super.key,
    required num initialValue,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    required this.decimalPlaces,
    required this.color,
    this.textStyle,
    this.step = 1,
    this.buttonSize = 25,
  })  : assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        selectedValue = initialValue;
  ///min value user can pick
  final num minValue;
  ///max value user can pick
  final num maxValue;
  /// decimal places required by the counter
  final int decimalPlaces;
  ///Currently selected integer value
  final num selectedValue;
  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final num step;
  /// indicates the color of fab used for increment and decrement
  final Color color;
  /// text syle
  final TextStyle? textStyle;
  final double buttonSize;


  void _incrementCounter() {
    if (selectedValue + step <= maxValue) {
      onChanged((selectedValue + step));
    }
  }


  void _decrementCounter() {
    if (selectedValue - step >= minValue) {
      onChanged((selectedValue - step));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: FloatingActionButton(
              heroTag: null,
              onPressed: _decrementCounter,
              elevation: 2,
              tooltip: 'Decrement',
              backgroundColor: color,
              child: const Icon(Icons.remove),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4.0),
            child: Text(
                '${num.parse((selectedValue).toStringAsFixed(decimalPlaces))}',
                style: textStyle
            ),
          ),
          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: FloatingActionButton(
              heroTag: null,
              onPressed: _incrementCounter,
              elevation: 2,
              tooltip: 'Increment',
              backgroundColor: color,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
