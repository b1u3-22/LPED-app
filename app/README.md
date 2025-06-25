# Companion app for LPED
* This application can be used for:
    * Pairing new dice
    * Display the current number on the dice
    * Get and display the battery state

## Structure
1. `lib/components`
    * UI components used throughout the app
2. `lib/model/device`
    * Models for containing information about the die
3. `lib/pages`
    * The two main pages `play` and `devices` page
        * `play` page actively scans for Bluetooth messages and displays the status of all dice and sum of all values. Devices can be hidden or excluded from the sum
        * `devices` page is used for managing existing devices and adding new ones
        
4. `lib/bluetooth.dart`
    * Functions for decoding messages from die
5. `lib/storage.dart`
    * Storage controller for saving and retrieving die information
6. `lib/typography.dart`
    * Text styles

## Compatibility
This app has only been tested on Android