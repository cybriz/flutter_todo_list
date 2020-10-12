import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef OnChangeCallback = void Function(bool checked);

class SquareCheckBox extends StatefulWidget {
  final bool checked;
  final OnChangeCallback onChange;

  SquareCheckBox({@required this.checked, @required this.onChange});
  @override
  _SquareCheckBoxState createState() => _SquareCheckBoxState();
}

class _SquareCheckBoxState extends State<SquareCheckBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        key: Key('checkbox'),
        onTap: () {
          widget.onChange(!widget.checked);
        },
        child: widget.checked
            ? Container(
                height: 14,
                width: 14,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3.0),
                  child: SvgPicture.asset(
                    'assets/images/check.svg',
                    height: 14,
                    width: 14,
                  ),
                ),
              )
            : Container(
                height: 14,
                width: 14,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: Colors.black54,
                  ),
                ),
              ));
  }
}
