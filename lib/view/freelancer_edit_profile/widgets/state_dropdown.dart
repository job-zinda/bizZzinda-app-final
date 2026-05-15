import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';

class StateDropdownWidgetUi extends StatelessWidget {
  String? selected;
  String hinttext;
  List list;
  String type;
  StateDropdownWidgetUi({
    super.key,
    required this.selected,
    required this.hinttext,
    required this.list,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    print("job---$selected");
    return SizedBox(
      // height: 60.0,
      child: DropdownButtonFormField(
          validator: (val) {
            if (val == null || val == "") {
              return "Please Select $type";
            }
            return null;
          },
          dropdownColor: PColors.black,
          decoration: InputDecoration(
            iconColor: PColors.seed,
            fillColor: PColors.black,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            hintStyle: TextStyle(
                fontSize: 15,
                color: PColors.whiteOff,
                // fontFamily: PFonts.plusJakartaSans,
                fontWeight: FontWeight.w500),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(color: PColors.whiteOff, width: 0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(color: PColors.whiteOff, width: 0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(color: PColors.whiteOff, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(color: PColors.red, width: 1),
            ),
          ),
          hint: Text(
            hinttext,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: PColors.white,
            ),
          ),
          isDense: true,
          isExpanded: true,
          style: TextStyle(
              color: PColors.white, fontSize: 16, fontWeight: FontWeight.w600),
          value: selected,
          onChanged: (val) {
           
          },
          // value: widget.selected,
          items: list
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList()),
    );
  }
}
