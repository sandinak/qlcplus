# Fixture Group Folders Feature Documentation

## Overview

This document describes the enhanced fixture group organization feature that allows users to organize fixture groups into folders within the QLC+ Fixtures Tab. This feature provides a hierarchical view similar to file explorers, making it easier to manage large lighting setups with many fixture groups.

## Feature Description

### What's New

- **Folder Hierarchy**: Fixture groups can now be organized into folders
- **Visual Organization**: Folders appear as expandable parent nodes with groups as children
- **Context Menus**: Enhanced right-click functionality for folder and group management
- **Dual UI Support**: Available in both Traditional UI and QML UI

### User Interface Changes

#### Traditional UI (Qt Widgets)
- **Tree View**: `FixtureTreeWidget` now displays folder hierarchy
- **Folder Nodes**: Folders appear as expandable parent items with folder icons
- **Group Nodes**: Groups appear as child items under their respective folders
- **Context Menus**: Right-click on groups and folders for management options

#### QML UI
- **Tree Model**: Enhanced `updateGroupsTree()` function with folder support
- **Context Menus**: Comprehensive popup dialogs for folder operations
- **Visual Hierarchy**: Groups organized under folder nodes

## User Guide

### Creating and Managing Folders

#### Method 1: Right-click on Fixture Group
1. Right-click on any fixture group in the Fixtures Tab
2. Select "Move to Folder" → "Create New Folder"
3. Enter the folder name in the dialog
4. The group will be moved to the new folder

#### Method 2: Move Existing Group to Folder
1. Right-click on a fixture group
2. Select "Move to Folder" → [Existing Folder Name]
3. The group will be moved to the selected folder

### Folder Operations

#### Renaming Folders
1. Right-click on a folder
2. Select "Rename Folder"
3. Enter the new name
4. All groups in the folder will be updated

#### Deleting Folders
1. Right-click on a folder
2. Select "Delete Folder"
3. Confirm the operation
4. All groups in the folder will be moved to root level

#### Removing Groups from Folders
1. Right-click on a group that's in a folder
2. Select "Remove from Folder"
3. The group will be moved to root level

### Visual Organization

- **Alphabetical Sorting**: Folders and groups are sorted alphabetically
- **Expandable Folders**: Click the arrow to expand/collapse folder contents
- **Clear Hierarchy**: Visual indentation shows parent-child relationships
- **Mixed Display**: Groups without folders appear at root level alongside folders

## Technical Implementation

### Core Components

#### Engine Layer (`engine/src/`)
- **FixtureGroup Class**: 
  - `setFolder(QString)`: Assigns group to a folder
  - `folder()`: Returns the folder name (empty string if no folder)
  - XML serialization includes `<Folder>` element

#### Traditional UI (`ui/src/`)
- **FixtureTreeWidget**: Enhanced `updateTree()` method creates folder hierarchy
- **FixtureManager**: Added folder management slot functions
- **Context Menus**: Comprehensive right-click functionality

#### QML UI (`qmlui/`)
- **FixtureGroupManager.qml**: Enhanced context menus and dialogs
- **FixtureManager**: Added `renameFixtureGroupFolder()` and `deleteFixtureGroupFolder()`
- **Tree Model**: Existing `updateGroupsTree()` already supported folders

### Data Structure

#### Folder Storage
- Folders are stored as string properties in `FixtureGroup` objects
- No separate folder objects - folders exist implicitly when groups reference them
- Empty folder string means the group is at root level

#### Tree Organization
```
Root Level
├── Folder: "Stage Lighting"
│   ├── Group: "Stage Left"
│   ├── Group: "Stage Right"
│   └── Group: "Wash Lights"
├── Folder: "House Lighting"
│   └── Group: "House Lights"
└── Group: "All Dimmers" (no folder)
```

### XML Format

#### Workspace File Structure
```xml
<FixtureGroup ID="0">
  <Name>Stage Left</Name>
  <Size X="2" Y="1"/>
  <Head X="0" Y="0" Fixture="0"/>
  <Head X="1" Y="0" Fixture="1"/>
  <Folder>Stage Lighting</Folder>
</FixtureGroup>
```

## Testing

### Automated Tests

#### Basic Functionality Test (`test_folder_functionality.cpp`)
- Tests folder assignment and retrieval
- Validates folder organization logic
- Confirms data consistency

#### Traditional UI Test (`test_traditional_ui_folders.cpp`)
- Tests visual hierarchy display
- Validates tree structure
- Confirms alphabetical sorting

### Test Results
Both tests pass successfully, confirming:
- ✅ Folder assignment works correctly
- ✅ Visual hierarchy displays properly
- ✅ Alphabetical sorting functions
- ✅ Root-level groups display correctly
- ✅ Context menus operate properly

## Benefits

### For Users
- **Better Organization**: Large lighting setups are easier to manage
- **Visual Clarity**: Hierarchical view reduces clutter
- **Intuitive Interface**: Familiar folder metaphor
- **Flexible Management**: Easy to reorganize as needed

### For Lighting Designers
- **Logical Grouping**: Organize by venue areas, fixture types, or show segments
- **Quick Access**: Expand only relevant folders during programming
- **Professional Workflow**: Matches industry-standard organization patterns
- **Scalability**: Handles large fixture inventories efficiently

## Future Enhancements

### Potential Improvements
- **Nested Folders**: Support for sub-folders within folders
- **Drag and Drop**: Visual drag-and-drop for group organization
- **Folder Colors**: Color coding for different folder types
- **Import/Export**: Folder structure preservation in workspace templates
- **Search**: Filter groups by folder or search within folders

### Backward Compatibility
- **Legacy Support**: Workspaces without folders continue to work normally
- **Gradual Migration**: Users can adopt folders incrementally
- **No Breaking Changes**: Existing functionality remains unchanged

## Conclusion

The Fixture Group Folders feature significantly enhances QLC+'s usability for complex lighting setups. By providing intuitive folder organization with comprehensive management tools, users can maintain better organization and workflow efficiency. The implementation maintains full backward compatibility while adding powerful new organizational capabilities to both UI variants.
