# MIDI Step Selection Implementation Test Guide

## Overview
This document provides testing instructions for the newly implemented MIDI-controlled chase step selection functionality in QLC+.

## Features Implemented

### 1. Core Functionality
- **Direct MIDI step selection**: Jump to specific chase steps via MIDI input
- **Two-note protocol**: Support for up to 16,384 steps using sequential MIDI notes
- **Timeout mechanism**: Configurable timeout for two-note protocol (default 500ms)
- **Fade preservation**: Maintains chase fade in/out behavior when jumping steps

### 2. User Interface
- **Traditional UI**: New "MIDI Cue" tab in Cue List Properties dialog
- **QML UI**: New "MIDI Step Selection" section in properties
- **Configuration options**: Enable/disable, two-note mode, timeout settings
- **Input mapping**: Separate MIDI input configuration for first and second notes

### 3. XML Serialization
- **Project saving**: MIDI step selection settings saved in QLC+ project files
- **Project loading**: Settings restored when opening projects
- **Backward compatibility**: Existing projects continue to work normally

## Testing Instructions

### Basic Setup
1. Create a new QLC+ project
2. Create a Chaser function with multiple steps (at least 10 steps for testing)
3. Add a Cue List widget to Virtual Console
4. Attach the Chaser to the Cue List widget

### Single-Note Mode Testing
1. Right-click the Cue List widget → Properties
2. Go to "MIDI Cue" tab (traditional UI) or find "MIDI Step Selection" section (QML UI)
3. Check "Enable MIDI step selection"
4. Leave "Two-note mode" unchecked
5. Configure "First Note Input" to a MIDI controller
6. Click OK to save settings

**Test Cases:**
- Send MIDI note 0: Should jump to step 1
- Send MIDI note 5: Should jump to step 6
- Send MIDI note 127: Should jump to step 128 (if available)
- Test with chase running and stopped

### Two-Note Mode Testing
1. Enable "Two-note mode (up to 16,384 steps)"
2. Configure both "First Note Input" and "Second Note Input"
3. Set timeout to 1000ms for easier testing

**Test Cases:**
- Send first note (value 1), then second note (value 0): Should jump to step 128
- Send first note (value 2), then second note (value 5): Should jump to step 261 (2×128+5)
- Send first note, wait for timeout: Should jump to first note value directly
- Send first note, then invalid second note: Should handle gracefully

### Edge Cases
- **Invalid step numbers**: Test with step numbers beyond chase length
- **Rapid MIDI input**: Send multiple notes quickly
- **Chase state changes**: Test while starting/stopping chase
- **Project save/load**: Verify settings persist across sessions

### Expected Behavior
- **Immediate response**: Step selection should be instantaneous
- **Visual feedback**: Current step should update in UI
- **Fade preservation**: Chase should maintain fade in/out settings
- **Error handling**: Invalid inputs should not crash the application

## Implementation Details

### Files Modified
- `qmlui/virtualconsole/vccuelist.h/.cpp` - QML UI implementation
- `ui/src/virtualconsole/vccuelist.h/.cpp` - Traditional UI implementation  
- `ui/src/virtualconsole/vccuelistproperties.h/.cpp/.ui` - Properties dialog
- `qmlui/qml/virtualconsole/VCCueListProperties.qml` - QML properties

### Key Methods
- `jumpToStep(int stepIndex)` - Core step jumping functionality
- `processMidiStepSelection(quint8 id, uchar value)` - MIDI input processing
- `slotMidiStepTimeout()` - Two-note protocol timeout handling

### MIDI Protocol
- **Single note**: Direct step = MIDI note value
- **Two notes**: Target step = (First Note × 128) + Second Note Velocity
- **Maximum range**: 16,384 steps (128 × 128)

## Troubleshooting

### Common Issues
1. **No response to MIDI**: Check MIDI input configuration and device connection
2. **Wrong step selection**: Verify MIDI note values and protocol mode
3. **Timeout issues**: Adjust timeout value in properties
4. **UI not updating**: Ensure chase is properly attached to cue list

### Debug Information
- Check QLC+ console output for MIDI input messages
- Verify chase function has sufficient steps for testing
- Confirm MIDI device is properly configured in QLC+ input/output settings

## Performance Notes
- MIDI step selection adds minimal overhead to existing functionality
- Two-note protocol uses a single timer per cue list widget
- XML serialization impact is negligible for typical project sizes
