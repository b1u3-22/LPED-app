//
// 	 Author: 			    Jiří Sedlák (xsedla2e)
// 	 Create Time: 		02-05-2025 23:22:19
// 	 Modified time: 	13-05-2025 22:05:15
// 	 Description: 	  This file contains base class for GattResult
//


/// Base class for GATT operations result
abstract class GattResultBase {
  /// Wether the operation was successful
  bool successful;

  GattResultBase({required this.successful});
}