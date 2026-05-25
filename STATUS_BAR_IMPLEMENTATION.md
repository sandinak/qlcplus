# QLC+ Status Bar Implementation

## Overview

I have successfully implemented a status bar at the bottom of both QLC+ applications (main/qlcplus and qmlui/qlcplus-qml) that displays three key pieces of information:

1. **Program Status** - Shows the current state of the application (Ready, Loading, etc.)
2. **Autosave Status** - Shows the autosave state (Ready, Disabled, or last saved time)
3. **Operating Mode** - Shows whether the application is in Edit or Operate mode

## Files Modified

### QML UI Backend Changes (C++)

1. **qmlui/app.h**
   - Added three new Q_PROPERTY declarations:
     - `QString operatingMode` - Exposes the current operating mode to QML
     - `QString autosaveStatus` - Exposes the autosave status to QML  
     - `QString programStatus` - Exposes the program status to QML
   - Added corresponding signal declarations for property change notifications
   - Added method declarations for the property getters

2. **qmlui/app.cpp**
   - Implemented the three property getter methods:
     - `operatingMode()` - Returns "Edit" or "Operate" based on Doc::mode()
     - `autosaveStatus()` - Returns autosave status based on AutoSaveManager state
     - `programStatus()` - Returns "Loading" or "Ready" based on document load state
   - Added signal connections to emit property change notifications when:
     - Document mode changes (Design/Operate)
     - Document load status changes
     - Autosave operations complete
   - Created and initialized the AutoSaveManager instance

### Main Application Backend Changes (C++)

3. **ui/src/app.h**
   - Added three new method declarations:
     - `QString operatingMode()` - Returns the current operating mode as a string
     - `QString autosaveStatus()` - Returns the autosave status as a string
     - `QString programStatus()` - Returns the program status as a string
   - Added `updateStatusBar()` private slot for updating status display
   - Added `initStatusBar()` private method declaration
   - Added status bar label member variables (QLabel pointers)

4. **ui/src/app.cpp**
   - Implemented the three status property methods with appropriate logic
   - Added `initStatusBar()` method to create and configure status bar labels
   - Added `updateStatusBar()` method to refresh all status displays
   - Modified `slotModeChanged()` to call `updateStatusBar()`
   - Modified `slotDocModified()` to call `updateStatusBar()`
   - Added signal connections for autosave completion updates
   - Initialized status bar labels in constructor
   - Added status bar initialization call in `init()` method

### QML UI Frontend Changes (QML)

5. **qmlui/qml/StatusBar.qml** (New File)
   - Created a reusable status bar component
   - Displays three status sections with appropriate color coding:
     - Program Status: Orange for "Loading", white for "Ready"
     - Autosave Status: Green for "Ready", red for "Disabled", white for time stamps
     - Operating Mode: Blue for "Edit", green for "Operate"
   - Includes a document modified indicator with an icon and "Modified" text
   - Uses proper spacing, separators, and responsive layout

6. **qmlui/qml/MainView.qml**
   - Added the StatusBar component at the bottom of the main view
   - Adjusted the main content area height to accommodate the status bar
   - Status bar is anchored to the bottom and spans the full width

## Features

### Program Status
- **Ready**: Application is fully loaded and ready for use
- **Loading**: Application is in the process of loading a workspace or initializing

### Autosave Status  
- **Ready**: Autosave is enabled and ready to save changes
- **Disabled**: Autosave is disabled in settings
- **Time-based**: Shows "Saved Xm ago" or "Saved Xh ago" for recent saves

### Operating Mode
- **Edit**: Application is in design mode, allowing editing of fixtures, functions, etc.
- **Operate**: Application is in operate mode, running shows and controlling lights

### Document Modified Indicator
- Shows an orange warning icon and "Modified" text when the document has unsaved changes
- Hidden when the document is saved

## Visual Design

The status bar uses a dark theme consistent with QLC+'s UI:
- Background: Medium gray (#404040) with light gray border
- Text: White with bold labels
- Color coding for status values to provide quick visual feedback
- Proper spacing and separators between sections
- Right-aligned document modified indicator

## Testing

### QML UI Testing
A test application (`test_statusbar.qml`) was created to demonstrate the QML status bar functionality:
- Simulates all status changes with a timer
- Shows color transitions and text updates
- Demonstrates the complete status bar behavior

### Main Application Testing
A test program (`test_main_statusbar.cpp`) was created to verify the main application status bar:
- Creates a QLC+ App instance with status bar
- Demonstrates mode switching and status updates
- Shows console output of status changes
- Can be built with the provided `test_statusbar.pro` file

### Build Process
The main application was rebuilt after updating the UI library to ensure the status bar is included:
```bash
cd ui/src && qmake && make -j4  # Build updated UI library
cd ../../main && qmake && make -j4  # Rebuild main application with new library
```

## Integration

The status bar is fully integrated into both QLC+ applications and will automatically:
- Update when switching between Edit and Operate modes
- Show autosave status changes
- Indicate document modification state
- Display loading states during workspace operations

## Future Enhancements

Potential improvements could include:
- Click handlers for status sections (e.g., click autosave status to open settings)
- Additional status indicators (network status, universe status, etc.)
- Tooltips with detailed information
- Animation transitions for status changes
