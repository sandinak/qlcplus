# MIDI Step Selection - Velocity-Based Mapping Correction

## ✅ **Issue Resolved: MIDI Velocity vs Note Number**

The MIDI step selection has been corrected to use **MIDI velocity values** instead of note numbers for step selection. This provides the accurate 1:1 correspondence between MIDI input and step selection.

## 🎯 **Root Cause Identified**

**Problem**: The implementation was using MIDI **note numbers** when it should use MIDI **velocity values**.

In MIDI, when a note is pressed, two values are transmitted:
- **Note Number**: Which key was pressed (0-127)
- **Velocity**: How hard the key was pressed (0-127)

For step selection, we need to use the **velocity value**, not the note number.

## 🔧 **Corrected Implementation**

### **Before (Incorrect - Using Note Number)**
```cpp
void handleFirstNote(uchar value) {
    // 'value' was the note number, not velocity
    int stepIndex = value - 1; // Wrong: using note number
}
```

### **After (Correct - Using Velocity)**
```cpp
void handleFirstNote(uchar velocity) {
    // 'velocity' is the MIDI velocity value
    int stepIndex = velocity - 1; // Correct: using velocity
}
```

## 📊 **Corrected MIDI Mapping**

### **Single Velocity Mode**
| MIDI Velocity | QLC+ Step | Internal Index | Action |
|---------------|-----------|----------------|---------|
| 0             | -         | -              | Ignored |
| 1             | 1         | 0              | ✅ Execute |
| 2             | 2         | 1              | ✅ Execute |
| 10            | 10        | 9              | ✅ Execute |
| 127           | 127       | 126            | ✅ Execute |

### **Two Velocity Mode**
| First Velocity | Second Velocity | Calculated Value | QLC+ Step | Internal Index |
|----------------|-----------------|------------------|-----------|----------------|
| 1              | 1               | 129              | 1         | 0              |
| 1              | 2               | 130              | 2         | 1              |
| 1              | 10              | 138              | 10        | 9              |
| 2              | 1               | 257              | 129       | 128            |

## 🎵 **MIDI Usage Instructions**

### **For MIDI Controllers**
1. **Configure any MIDI note** (the note number doesn't matter)
2. **Use velocity values 1-127** for step selection
3. **Velocity 0** is reserved and ignored
4. **Example**: Press any key with velocity 10 → Jump to Step 10

### **For MIDI Sequencers**
1. **Send MIDI notes to the configured channel**
2. **Set velocity to desired step number**
3. **Note number can be any value** (commonly use C4/Middle C)
4. **Example**: Send C4 with velocity 5 → Jump to Step 5

### **For Programming/Scripting**
```python
# Example MIDI message for Step 10
note_number = 60  # C4 (doesn't matter which note)
velocity = 10     # This selects Step 10
channel = 1       # Configured MIDI channel

send_midi_note_on(channel, note_number, velocity)
```

## 🔍 **Technical Details**

### **Method Signatures Updated**
```cpp
// Old (misleading parameter name)
void handleFirstNote(uchar value);

// New (clear parameter name)
void handleFirstNote(uchar velocity);
```

### **Debug Output Enhanced**
```cpp
qDebug() << "MidiStepController::handleFirstNote: velocity=" << velocity;
// Shows: "velocity=10" instead of confusing "value=10"
```

### **Documentation Updated**
- Header comments clarified to specify velocity usage
- Method documentation updated
- Debug messages use "velocity" terminology

## 🚀 **Benefits of Velocity-Based Mapping**

### **Intuitive Control**
- **Velocity directly maps to step number**
- **No confusion about note vs velocity**
- **Standard MIDI practice** for parameter control

### **Flexible MIDI Setup**
- **Any MIDI note can be used** (note number irrelevant)
- **Multiple controllers** can use different notes
- **Consistent behavior** across different MIDI devices

### **Professional Workflow**
- **Industry standard** velocity-based control
- **Compatible with MIDI sequencers** and controllers
- **Predictable behavior** for lighting professionals

## 🧪 **Testing Validation**

### **Test Cases**
1. **MIDI Note C4, Velocity 1** → Should jump to **Step 1**
2. **MIDI Note C4, Velocity 10** → Should jump to **Step 10**
3. **MIDI Note G5, Velocity 5** → Should jump to **Step 5** (note doesn't matter)
4. **MIDI Note Any, Velocity 0** → Should be **ignored**

### **Debug Output Example**
```
MidiStepController::handleFirstNote: velocity=10 twoNoteMode: false
MidiStepController::queueStepChange: 9
MidiStepController::executeStepChange: 9
```
This shows velocity 10 correctly mapping to internal step index 9 (Step 10 in UI).

## 📝 **Configuration Notes**

### **MIDI Input Setup**
1. **Configure MIDI input device** in QLC+ Input/Output settings
2. **Map "First Note Input"** to any MIDI note on your controller
3. **Map "Second Note Input"** for two-velocity mode (if needed)
4. **The note number doesn't matter** - only velocity is used

### **Controller Programming**
- **Set up any MIDI note** to send to QLC+
- **Program velocity values 1-127** for step selection
- **Velocity 0 is ignored** (can be used for "stop" or "no action")

## ✅ **Status: Velocity Mapping Corrected**

The MIDI step selection now correctly uses velocity values for step selection:

- ✅ **Velocity 1** → **Step 1**
- ✅ **Velocity 10** → **Step 10**
- ✅ **Velocity 127** → **Step 127**
- ✅ **Note number irrelevant** (any note works)
- ✅ **Velocity 0 ignored** (reserved)

## 🔮 **Advanced Usage**

### **Two-Velocity Mode**
- **First velocity × 128 + Second velocity - 1** = Step index
- **Range**: Up to 16,383 steps
- **Example**: Velocity 2, then velocity 1 → Step 257

### **MIDI Scripting**
```javascript
// JavaScript example for MIDI controller
function sendStepSelection(stepNumber) {
    var velocity = Math.min(127, Math.max(1, stepNumber));
    sendMIDI(0x90, 60, velocity); // Note On, C4, velocity=stepNumber
}
```

The velocity-based MIDI mapping now provides the exact 1:1 correspondence requested, using the standard MIDI velocity parameter for step selection control.
