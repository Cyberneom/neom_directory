import 'package:flutter/material.dart';

class CustomSliderWidget extends StatefulWidget {
  const CustomSliderWidget({Key? key}) : super(key: key);


  @override
  CustomSliderWidgetState createState() => CustomSliderWidgetState();

}

class CustomSliderWidgetState extends State<CustomSliderWidget>{
  var _maxWidth=0.0;
  var _width=0.0;
  var _value =0.0;
  var _booked =false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context,constraint){
          _maxWidth=constraint.maxWidth;
          return Container(
            decoration: BoxDecoration(
                color: _booked ?   const Color(0xff3366cc) :   const Color(0xff39ca30),
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                border: Border.all(
                  color: _booked ?   const Color(0xff3366cc): const Color(0xff39ca30),width: 3,
                )
            ),
            height: 60,
            child: Stack(
              children: <Widget>[
                Center(
                    child: Text(
                        _booked ? " réservé ": "Glisser pour réserver",style: const TextStyle(fontSize: 20),),
                    ),
                AnimatedContainer(

                  duration: const Duration(milliseconds: 100,),
                  width: _width<= 55 ? 55 :_width,
                  child: Row(
                    children: <Widget>[
                      const Expanded(
                        child: SizedBox(),
                      ),
                      GestureDetector(
                        onVerticalDragUpdate: _onDrag ,
                        onVerticalDragEnd: _onDragEnd,
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child: const Icon(Icons.keyboard_arrow_right,
                            color: Colors.grey,),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  void _onDragEnd(DragEndDetails details) {
    setState(() {
      if(_value>.9 ){
        _value =  1;
        //Navigator.push(context,  MaterialPageRoute(builder: (context) => GigHostProfile()),);
      }
      else {
        _value = 0;
      }
      setState(() {
        _width = _maxWidth * _value ;
        _booked = _value>.9;
      });
    });
  }

  void _onDrag(DragUpdateDetails details) {
    setState(() {
      _value = (details.globalPosition.dx) /_maxWidth;
      _width = _maxWidth * _value ;
    });
  }
}
