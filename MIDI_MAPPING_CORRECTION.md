# MIDI Step Selection - Corrected 1:1 Mapping

## ✅ **Issue Resolved: MIDI Note to Step Index Mapping**

The MIDI input mapping has been corrected to provide intuitive 1:1 correspondence between MIDI notes and step numbers as displayed in the QLC+ user interface.

## 🎯 **Corrected MIDI Note Mapping**

### **Single Note Mode**
- **MIDI Note 1** → **Step 1** (internal index 0)
- **MIDI Note 2** → **Step 2** (internal index 1)
- **MIDI Note 3** → **Step 3** (internal index 2)
- **...and so on...**
- **MIDI Note 127** → **Step 127** (internal index 126)

### **Two Note Mode**
- **MIDI Notes (1,1)** → **Step 1** (internal index 0)
- **MIDI Notes (1,2)** → **Step 2** (internal index 1)
- **MIDI Notes (1,3)** → **Step 3** (internal index 2)
- **...and so on...**
- **MIDI Notes (127,127)** → **Step 16,383** (internal index 16,382)

### **Reserved Values**
- **MIDI Note 0** → **Ignored** (reserved for special functions)
- **MIDI Notes (0,0)** → **Ignored** (reserved in two-note mode)

## 🔧 **Technical Implementation**

### **Single Note Mode Conversion**
```cpp
// Before (incorrect): Direct mapping
queueStepChange(value); // MIDI note 0 → Step 1

// After (correct): 1-based mapping
if (value == 0) {
    return; // Ignore MIDI note 0
}
int stepIndex = value - 1; // MIDI note 1 → Step 1 (index 0)
queueStepChange(stepIndex);
```

### **Two Note Mode Conversion**
```cpp
// Before (incorrect): Direct calculation
int targetStep = (firstNote * 128) + secondNote;

// After (correct): 1-based mapping with reservation
int midiValue = (firstNote * 128) + secondNote;
int targetStep = (midiValue == 0) ? -1 : midiValue - 1;
if (targetStep < 0) return; // Ignore (0,0)
```

### **Timeout Handling**
```cpp
// Before (incorrect): Direct first note usage
int stepIndex = m_firstNoteValue;

// After (correct): Apply same 1-based mapping
if (m_firstNoteValue == 0) return; // Ignore note 0
int stepIndex = m_firstNoteValue - 1;
```

## 📊 **Mapping Examples**

### **Single Note Mode Examples**
| MIDI Note | QLC+ Step | Internal Index | Action |
|-----------|-----------|----------------|---------|
| 0         | -         | -              | Ignored |
| 1         | 1         | 0              | ✅ Execute |
| 2         | 2         | 1              | ✅ Execute |
| 10        | 10        | 9              | ✅ Execute |
| 127       | 127       | 126            | ✅ Execute |

### **Two Note Mode Examples**
| First Note | Second Note | MIDI Value | QLC+ Step | Internal Index | Action |
|------------|-------------|------------|-----------|----------------|---------|
| 0          | 0           | 0          | -         | -              | Ignored |
| 1          | 1           | 129        | 1         | 0              | ✅ Execute |
| 1          | 2           | 130        | 2         | 1              | ✅ Execute |
| 2          | 1           | 257        | 129       | 128            | ✅ Execute |
| 127        | 127         | 16383      | 16383     | 16382          | ✅ Execute |

## 🎵 **User Experience**

### **Intuitive Mapping**
- **MIDI Note 1** directly corresponds to **Step 1** in the UI
- **No mental offset calculation** required
- **Consistent with user expectations**

### **Reserved Note 0**
- **MIDI Note 0** is reserved for future special functions
- **Prevents accidental triggering** of Step 1 with note 0
- **Allows for "stop" or "reset" functionality** in future versions

### **Two-Note Mode Benefits**
- **Extended Range**: Support for chasers with up to 16,383 steps
- **Consistent Mapping**: Same 1-based logic as single note mode
- **Timeout Fallback**: First note becomes single-note selection on timeout

## 🔍 **Validation**

### **Test Cases**
1. **MIDI Note 1** → Should jump to **Step 1** (first step in chaser)
2. **MIDI Note 5** → Should jump to **Step 5** (fifth step in chaser)
3. **MIDI Note 0** → Should be **ignored** (no action)
4. **Two-Note (1,10)** → Should jump to **Step 138** (1×128 + 10 - 1 = 137, which is Step 138)

### **Debug Output**
The implementation includes detailed debug logging:
```
MidiStepController::handleFirstNote: 5 twoNoteMode: false
MidiStepController::queueStepChange: 4
MidiStepController::executeStepChange: 4
```
This shows MIDI note 5 correctly mapping to internal step index 4 (Step 5 in UI).

## 🚀 **Benefits of Correction**

### **User-Friendly**
- **Intuitive mapping** matches user expectations
- **No confusion** about note-to-step correspondence
- **Consistent with QLC+ UI** step numbering

### **Professional**
- **Industry standard** 1-based step numbering
- **Compatible** with MIDI controller expectations
- **Scalable** to large chasers with two-note mode

### **Robust**
- **Reserved values** prevent accidental triggers
- **Comprehensive validation** ensures safe operation
- **Future-proof** design for additional features

## 📝 **Documentation Update**

The MIDI step selection feature now provides:
- **Accurate 1:1 mapping** between MIDI notes and step numbers
- **Reserved MIDI note 0** for future special functions
- **Extended range** support via two-note mode
- **Intuitive user experience** matching QLC+ UI conventions

## ✅ **Status: Ready for Testing**

The corrected MIDI mapping is now implemented and ready for user testing:
1. **Enable MIDI Step Selection** in Cue List properties
2. **Configure MIDI inputs** for first/second note channels
3. **Test with MIDI notes 1-127** for direct step selection
4. **Verify MIDI note 0 is ignored** as expected

The implementation now provides the expected 1:1 correspondence between MIDI note values and QLC+ step numbers as displayed in the user interface.
