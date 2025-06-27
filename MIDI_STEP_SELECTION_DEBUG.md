# MIDI Step Selection Debug Guide

## Segmentation Fault Troubleshooting

The segmentation fault has been addressed with the following safety improvements:

### 1. **Memory Management Fixes**
- **Timer Parent**: Fixed `m_midiStepTimer` to have proper parent (`this`) in constructor
- **Null Pointer Checks**: Added comprehensive null pointer checks for timer and chaser
- **Bounds Checking**: Enhanced step index validation with detailed logging

### 2. **Safety Checks Added**

#### **jumpToStep() Method**
```cpp
void VCCueList::jumpToStep(int stepIndex)
{
    Chaser *ch = chaser();
    if (ch == nullptr)
    {
        qWarning() << "VCCueList::jumpToStep: No chaser attached";
        return;
    }
    
    if (stepIndex < 0 || stepIndex >= ch->stepsCount())
    {
        qWarning() << "VCCueList::jumpToStep: Invalid step index" << stepIndex << "for chaser with" << ch->stepsCount() << "steps";
        return;
    }
    // ... rest of method
}
```

#### **processMidiStepSelection() Method**
```cpp
void VCCueList::processMidiStepSelection(quint8 id, uchar value)
{
    if (!m_midiStepSelectionEnabled)
        return;

    // Safety check: ensure we have a valid chaser
    Chaser *ch = chaser();
    if (ch == nullptr)
    {
        qWarning() << "VCCueList::processMidiStepSelection: No chaser attached";
        return;
    }

    // Timer null checks
    if (m_midiStepTimer)
        m_midiStepTimer->start(m_midiTimeout);
    // ... rest of method
}
```

### 3. **Debug Testing Steps**

#### **Step 1: Basic Setup Test**
1. Launch QLC+ with debug output enabled
2. Create a new project
3. Add a simple Chaser with 5-10 steps
4. Add a Cue List widget to Virtual Console
5. Attach the Chaser to the Cue List

#### **Step 2: Properties Dialog Test**
1. Right-click Cue List widget → Properties
2. Navigate to "MIDI Cue" tab (traditional UI) or "MIDI Step Selection" section (QML UI)
3. Check "Enable MIDI step selection"
4. Leave "Two-note mode" unchecked initially
5. Click OK to save

#### **Step 3: MIDI Input Test**
1. Configure a MIDI input device in QLC+ Input/Output settings
2. Return to Cue List Properties → MIDI Cue tab
3. Configure "First Note Input" to your MIDI device
4. Test with simple MIDI note values (0-4 for a 5-step chaser)

#### **Step 4: Monitor Debug Output**
Watch for these debug messages:
- `VCCueList::jumpToStep: No chaser attached` (should not appear if chaser is properly attached)
- `VCCueList::jumpToStep: Invalid step index X for chaser with Y steps` (indicates bounds issues)
- `VCCueList::slotMidiStepTimeout: Two-note timeout, using first note value X` (for two-note mode)

### 4. **Common Issues and Solutions**

#### **Issue: Segfault on MIDI Input**
**Likely Cause**: Chaser not properly attached or invalid step index
**Solution**: Ensure chaser is attached before enabling MIDI step selection

#### **Issue: No Response to MIDI**
**Likely Cause**: MIDI input not configured or external controls not registered
**Solution**: Check MIDI device configuration and input mapping

#### **Issue: Timer-Related Crashes**
**Likely Cause**: Timer accessed after object destruction
**Solution**: Timer now has proper parent and null checks

### 5. **Debugging Commands**

#### **Enable Debug Output**
```bash
# Run QLC+ with debug output
qlcplus --debug

# Or with specific debug categories
QT_LOGGING_RULES="*.debug=true" qlcplus
```

#### **Check for Memory Issues**
```bash
# Run with Address Sanitizer (if available)
ASAN_OPTIONS=abort_on_error=1 qlcplus

# Run with Valgrind (Linux/macOS)
valgrind --tool=memcheck --leak-check=full qlcplus
```

### 6. **Safe Testing Protocol**

1. **Start Simple**: Test with single-note mode first
2. **Small Chasers**: Use chasers with 5-10 steps initially
3. **Valid Ranges**: Only send MIDI notes within chaser step count
4. **Attach First**: Always attach chaser before enabling MIDI step selection
5. **Check Logs**: Monitor debug output for warnings

### 7. **Rollback Plan**

If issues persist, the MIDI step selection can be disabled by:
1. Setting `m_midiStepSelectionEnabled = false` in constructor
2. Commenting out the external control registration
3. Removing the MIDI tab from properties dialogs

The safety checks should prevent segfaults, but if they occur, the debug output will help identify the exact cause.
