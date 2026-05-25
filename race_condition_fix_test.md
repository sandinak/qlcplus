# Race Condition Fix Test Guide

## Issue Analysis

The segmentation fault appears to be related to **rapid chase selection changes** causing race conditions in the VCCueList playback index management. This is a threading issue where multiple threads are accessing and modifying the playback state simultaneously.

## Root Cause Identified

**Threading Race Condition**: The `setPlaybackIndex` method can be called from multiple threads:
1. **UI Thread**: User clicking next/previous buttons rapidly
2. **Master Timer Thread**: Chase runner updating current step via `slotCurrentStepChanged`
3. **Signal/Slot System**: Qt's signal emission can happen across threads

## Fix Implemented

### **1. Mutex Protection**
- Added `QMutex m_playbackMutex` to VCCueList class
- Protected `setPlaybackIndex()` with `QMutexLocker`
- Protected `playbackIndex()` getter for thread-safe reads

### **2. Comprehensive Debug Logging**
- Added detailed logging to all playback-related methods
- Thread ID tracking to identify which thread is causing issues
- Mutex acquisition/release logging

### **3. Critical Section Protection**
```cpp
void VCCueList::setPlaybackIndex(int playbackIndex)
{
    QMutexLocker locker(&m_playbackMutex);  // Thread-safe access
    // ... rest of method
}
```

## Testing Protocol

### **Step 1: Basic Functionality Test**
1. Launch QLC+ with debug output enabled
2. Create a Chaser with 10+ steps
3. Add Cue List widget and attach chaser
4. Test normal next/previous navigation (should work without crashes)

### **Step 2: Rapid Change Test**
1. **Manual Rapid Clicking**: Click next/previous buttons rapidly
2. **Keyboard Shortcuts**: Use keyboard shortcuts for rapid navigation
3. **Running Chase**: Start chase and rapidly change steps while running

### **Step 3: Debug Output Analysis**
Look for these debug messages in the console:

**Normal Operation:**
```
VCCueList::setPlaybackIndex: ENTRY - this=0x... thread=0x... playbackIndex=5
VCCueList::setPlaybackIndex: Acquired mutex lock
VCCueList::setPlaybackIndex: Setting playback index from 4 to 5
VCCueList::setPlaybackIndex: EXIT - releasing mutex lock
```

**Race Condition Detection:**
```
VCCueList::setPlaybackIndex: ENTRY - this=0x... thread=0x123...
VCCueList::setPlaybackIndex: ENTRY - this=0x... thread=0x456...  // Different thread!
```

**Thread Blocking (Good):**
```
VCCueList::setPlaybackIndex: Acquired mutex lock  // First thread
// Second thread waits here until first completes
VCCueList::setPlaybackIndex: Acquired mutex lock  // Second thread
```

### **Step 4: Stress Testing**
1. **Automated Rapid Changes**: Use external MIDI controller for rapid step changes
2. **Multiple Cue Lists**: Test with multiple cue list widgets simultaneously
3. **Chase State Changes**: Rapidly start/stop chase while changing steps

## Expected Results

### **If Fix is Successful:**
- ✅ No segmentation faults during rapid step changes
- ✅ Debug output shows proper mutex acquisition/release
- ✅ Thread-safe access to playback index
- ✅ Smooth operation even under stress testing

### **If Issues Persist:**
- ❌ Segfaults still occur → Need deeper investigation
- ❌ Deadlocks occur → Mutex implementation issue
- ❌ Performance degradation → Mutex contention

## Advanced Debugging

### **Enable Qt Debug Output**
```bash
# Run with full debug output
QT_LOGGING_RULES="*.debug=true" qlcplus

# Or specific categories
QT_LOGGING_RULES="qt.qml.debug=true;qt.core.debug=true" qlcplus
```

### **Memory Debugging (if available)**
```bash
# Address Sanitizer
ASAN_OPTIONS=abort_on_error=1 qlcplus

# Valgrind (Linux/macOS with Valgrind installed)
valgrind --tool=memcheck --leak-check=full qlcplus
```

### **Thread Analysis**
Look for patterns in debug output:
- Same thread ID for all calls = No threading issue
- Different thread IDs = Threading issue confirmed
- Mutex blocking = Fix working correctly

## Performance Monitoring

### **Mutex Contention Check**
- Monitor for delays between "ENTRY" and "Acquired mutex lock"
- Long delays indicate high contention
- May need to optimize critical section size

### **Signal Emission Frequency**
- Count `playbackIndexChanged` and `nextStepIndexChanged` emissions
- High frequency may indicate unnecessary updates
- Consider debouncing rapid changes

## Next Steps Based on Results

### **If Segfault is Fixed:**
1. ✅ Race condition was the root cause
2. Re-enable MIDI step selection functionality
3. Apply similar mutex protection to other rapid-change scenarios
4. Optimize mutex usage for performance

### **If Segfault Persists:**
1. ❌ Issue is deeper than race conditions
2. Investigate memory corruption in Qt object lifecycle
3. Check for use-after-free in signal/slot connections
4. Consider object destruction timing issues

## Current Status

- ✅ Mutex protection implemented
- ✅ Debug logging added
- ✅ Build completed successfully
- ⏳ Ready for race condition testing

The application should now handle rapid chase selection changes without segfaults. Test thoroughly and monitor debug output to confirm the fix.
