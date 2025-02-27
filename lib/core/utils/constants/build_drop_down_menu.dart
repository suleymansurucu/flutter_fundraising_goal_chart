import 'package:flutter/material.dart';

enum CurrencyDropDownList {
  dollar('US Dollar', Icons.attach_money),
  euro('Euro', Icons.euro),
  turkishLira('Turkish Lira', Icons.money_off);

  const CurrencyDropDownList(this.label, this.icon);

  final String label;
  final IconData icon;
}

enum GraphicTypeDropDownList {
  // progressBar('Progress Bar', Icons.battery_4_bar_rounded),
  pieChart('Pie Chart', Icons.change_circle_rounded),
  gaugeChart('Gauge Chart', Icons.network_wifi_3_bar_sharp);

  const GraphicTypeDropDownList(this.label, this.icon);

  final String label;
  final IconData icon;
}

enum YesOrNoDropDownList {
  yes('Yes', Icons.arrow_upward_rounded),
  no('No', Icons.arrow_downward_rounded);

  const YesOrNoDropDownList(this.label, this.icon);

  final String label;
  final IconData icon;
}

class BuildDropDownMenu<T> extends StatefulWidget {
  final T initialValue;
  final ValueChanged<T> onChanged;
  final Color dropdownColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color iconColor;
  final double borderRadius;
  final double? containerWith;

  final List<T> items; // To get enum values as a list.


  const BuildDropDownMenu({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.dropdownColor,
    required this.borderColor,
    required this.focusedBorderColor,
    required this.iconColor,
    required this.items,
    this.borderRadius = 12.0,
    this.containerWith=400.0
  });

  @override
  State<BuildDropDownMenu<T>> createState() => _BuildDropDownMenuState<T>();
}

class _BuildDropDownMenuState<T> extends State<BuildDropDownMenu<T>> {
  late T _selectedItem;

  @override
  void initState() {
    _selectedItem = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.containerWith,
      decoration: BoxDecoration(
        border: Border.all(color: widget.borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: _selectedItem,
          dropdownColor: widget.dropdownColor,
          icon: Icon(Icons.arrow_drop_down, color: widget.iconColor),
          style: TextStyle(color: Colors.black, fontSize: 16),
          onChanged: (T? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedItem = newValue;
              });
              widget.onChanged(newValue);
            }
          },
          items: widget.items.map((T item) {
            if (item is CurrencyDropDownList) {
              return DropdownMenuItem<T>(
                value: item,
                child: Row(
                  children: [
                    Icon(item.icon, color: widget.iconColor),
                    SizedBox(width: 10),
                    Text(item.label),
                  ],
                ),
              );
            } else if (item is YesOrNoDropDownList) {
              return DropdownMenuItem<T>(
                value: item,
                child: Row(
                  children: [
                    Icon(item.icon, color: widget.iconColor),
                    SizedBox(width: 10),
                    Text(item.label),
                  ],
                ),
              );
            } else if (item is GraphicTypeDropDownList) {
              return DropdownMenuItem<T>(
                value: item,
                child: Row(
                  children: [
                    Icon(item.icon, color: widget.iconColor),
                    SizedBox(width: 10),
                    Text(item.label),
                  ],
                ),
              );
            }
            return DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString()), // Default Text
            );
          }).toList(),
        ),
      ),
    );
  }
}
