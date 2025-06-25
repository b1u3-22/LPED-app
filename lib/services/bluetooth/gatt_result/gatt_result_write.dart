//
// 	 Author: 					Jiří Sedlák (xsedla2e)
// 	 Create Time: 		02-05-2025 23:25:16
// 	 Modified time: 	13-05-2025 22:09:02
// 	 Description: 		This file contains class that is used as a return type in the base GATT write function
//

import 'package:app/services/bluetooth/gatt_result/gatt_result_base.dart';

/// Gatt result class that is used as the return type from base GATT write operation
class GattResultWrite extends GattResultBase {

  GattResultWrite({required super.successful});
}