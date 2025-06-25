//
// 	 Author: 			    Jiří Sedlák (xsedla2e)
// 	 Create Time: 		02-05-2025 23:24:17
// 	 Modified time: 	13-05-2025 22:06:52
// 	 Description: 	  This file contains gatt result class, which is used as a return type in base GATT read function
//

import 'package:app/services/bluetooth/gatt_result/gatt_result_base.dart';

/// This class is used as a return type from the base GATT read function
class GattResultRead extends GattResultBase {
  /// Read data, can be empty if [successful] is false
  List<int> data; 

  GattResultRead({required super.successful, required this.data});
}