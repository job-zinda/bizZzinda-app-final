import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/model/profession_model.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class DropdownWidgetUi extends StatelessWidget {
  String? selected;
  String hinttext;
  List<ProfessionModel> list;
  String type;
  DropdownWidgetUi({
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
          dropdownColor: PColors.white,
          decoration: InputDecoration(
            iconColor: PColors.seed,
            fillColor: Colors.purple.shade50,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            hintStyle: TextStyle(
                fontSize: 15,
                color: Color(0xFF8A4FFF),
                // fontFamily: PFonts.plusJakartaSans,
                fontWeight: FontWeight.w500),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(color: Color(0xFF8A4FFF), width: 0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(color: Color(0xFF8A4FFF), width: 0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(color: Color(0xFF8A4FFF), width: 1),
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
              color: Color(0xFF8A4FFF),
            ),
          ),
          isDense: true,
          isExpanded: true,
          style: TextStyle(
              color: Color(0xFF8A4FFF), fontSize: 16, fontWeight: FontWeight.w600),
          value: selected,
          onChanged: (val) {
            if (val != null) {
              context.read<ProfileViewModel>().updateSelectedProfession(val);
            }
          },
          // value: widget.selected,
          items: list
              .map(
                (e) => DropdownMenuItem(
                  value: e.sId,
                  child: Text(e.name.toString()),
                ),
              )
              .toList()),
    );
  }
}
