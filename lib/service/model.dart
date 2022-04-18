import 'package:flutter/foundation.dart';
import 'package:charts_flutter/flutter.dart' as charts;
class Amount {
  final String commisionName;
   var Commission;
  
  final charts.Color barColor;

  Amount(
    {
      @required this.commisionName,
      @required this.Commission,
      
      @required this.barColor
    }
  );
}