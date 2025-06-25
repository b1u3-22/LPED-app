//
// 	 Author: 			    Jiří Sedlák (xsedla2e)
// 	 Create Time: 		02-05-2025 23:26:16
// 	 Modified time: 	13-05-2025 22:02:39
// 	 Description: 	  This file contains enum with available update actions
//


/// Enum with available update actions for the update characteristic
enum GattUpdateAction { 
  diceDefinitionAdd,    // Add new dice profile
  diceDefinitionDelete, // Delete existing profile
  diceDefinitionUpdate, // Update existing profile
  sideDefinitionAdd,    // Add new side to an existing profile
  sideDefinitionDelete, // Delete existing side from an existing profile
  sideDefinitionUpdate  // Update existing side from an existing profile
}
