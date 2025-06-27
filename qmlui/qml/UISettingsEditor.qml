/*
  Q Light Controller Plus
  PopupUISettings.qml

  Copyright (c) Massimo Callegari

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0.txt

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.qlcplus.classes 1.0
import "."

Rectangle
{
    id: editorRoot
    anchors.fill: parent
    color: "transparent"

    property real origItemHeight: { origItemHeight = UISettings.listItemHeight }
    property real origIconMedium: { origIconMedium = UISettings.iconSizeMedium }
    property real origTextSizeDefault: { origTextSizeDefault = UISettings.textSizeDefault}
    property real origIconDefault: {origIconDefault = UISettings.iconSizeDefault}

    onVisibleChanged:
    {
        origItemHeight = UISettings.listItemHeight
        origIconMedium = UISettings.iconSizeMedium
        origTextSizeDefault = UISettings.textSizeDefault
        sfRestore.origScaleFactor = qlcplus.uiScaleFactor
    }

    CustomPopupDialog
    {
        id: messagePopup
        title: qsTr("Information")
        standardButtons: Dialog.Ok
    }

    ColorTool
    {
        id: colorTool
        parent: editorRoot
        x: editorRoot.width - width - 10
        y: 10
        z: 99

        property Item rectItem
        property Item selectedItem

        onColorChanged:
        {
            if (rectItem)
                rectItem.color = Qt.rgba(red, green, blue, 1.0)
            if (selectedItem)
                selectedItem.updateColor(Qt.rgba(red, green, blue, 1.0))
        }
        onClose:
        {
            rectItem = null
            selectedItem = null
        }
    }

    Component
    {
        id: colorSelector

        RowLayout
        {
            height: origIconMedium

            property color origColor
            property Item pItem

            function init(item, original, col)
            {
                pItem = item
                origColor = original
                colorRect.color = col
            }

            Rectangle
            {
                id: colorRect
                height: origIconMedium
                width: height * 4
                border.color: csMouseArea.containsMouse ? "white" : "gray"
                border.width: 2

                MouseArea
                {
                    id: csMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:
                    {
                        colorTool.rectItem = colorRect
                        colorTool.selectedItem = pItem
                        colorTool.visible = true
                    }
                }
            }

            IconButton
            {
                width: origIconMedium
                height: width
                imgSource: "qrc:/undo.svg"
                tooltip: qsTr("Reset to default")

                onClicked:
                {
                    pItem.updateColor(origColor)
                    colorRect.color = origColor
                }
            }
        }
    }

    GridLayout
    {
        id: editorGrid
        columnSpacing: origIconMedium
        rowSpacing: 10
        columns: 4
        z: 1

        // Row 1
        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("Scaling factor")
        }
        RowLayout
        {
            Slider
            {
                id: sfSlider
                orientation: Qt.Horizontal
                from: 0.3
                to: 2
                value: UISettings.scalingFactor
                wheelEnabled: true
                onMoved: uiManager.setModified("scalingFactor", value)
            }

            RobotoText
            {
                height: origItemHeight
                fontSize: origTextSizeDefault
                label: sfSlider.value.toFixed(2) + "x"
            }

            IconButton
            {
                id: sfRestore
                width: origIconMedium
                height: width
                imgSource: "qrc:/undo.svg"
                tooltip: qsTr("Reset to default")

                property real origScaleFactor

                onClicked: uiManager.setModified("scalingFactor", 1.0)
            }
        }

        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("UI language")
        }
        CustomComboBox
        {
            Layout.fillWidth: true
            height: origItemHeight
            textRole: ""
            model: uiManager.languagesList()
            currentIndex: uiManager.currentLanguageIndex()
            onCurrentTextChanged: uiManager.setModified("language", currentText)
        }

        // Row 2
        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("Default item size")
        }
        RowLayout
        {
            Slider
            {
                id: itemSizeSlider
                orientation: Qt.Horizontal
                from: 25
                to: 100
                value: UISettings.listItemHeight
                wheelEnabled: true
                onMoved: uiManager.setModified("listItemHeight", value)
            }

            RobotoText
            {
                height: origItemHeight
                fontSize: origTextSizeDefault
                label: itemSizeSlider.value.toFixed(0) + "px"
            }

            IconButton
            {
                width: origIconMedium
                height: width
                imgSource: "qrc:/undo.svg"
                tooltip: qsTr("Reset to default")
                onClicked: uiManager.setModified("listItemHeight", origItemHeight)
            }
        }

        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("Default font size")
        }
        RowLayout
        {
            Slider
            {
                id: fontSizeSlider
                orientation: Qt.Horizontal
                from: 7
                to: 25
                value: UISettings.textSizeDefault
                wheelEnabled: true
                onMoved: uiManager.setModified("textSizeDefault", value)
            }

            RobotoText
            {
                height: origItemHeight
                fontSize: origTextSizeDefault
                label: fontSizeSlider.value.toFixed(0) + "pt"
            }

            IconButton
            {
                width: origIconMedium
                height: width
                imgSource: "qrc:/undo.svg"
                tooltip: qsTr("Reset to default")
                onClicked: uiManager.setModified("textSizeDefault", origTextSizeDefault)
            }
        }

        // Row 3
        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("Default icon size")
        }
        RowLayout
        {
            Slider
            {
                id: iconSizeSlider
                orientation: Qt.Horizontal
                from: 24
                to: 100
                value: UISettings.iconSizeDefault
                wheelEnabled: true
                onMoved: uiManager.setModified("iconSizeDefault", value)
            }

            RobotoText
            {
                height: origItemHeight
                fontSize: origTextSizeDefault
                label: iconSizeSlider.value.toFixed(0) + "px"
            }

            IconButton
            {
                width: origIconMedium
                height: width
                imgSource: "qrc:/undo.svg"
                tooltip: qsTr("Reset to default")
                onClicked: uiManager.setModified("iconSizeDefault", origIconDefault)
            }
        }

        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("Multipage mode")
        }
        CustomCheckBox
        {
            implicitWidth: origIconMedium
            implicitHeight: origIconMedium
            checked: uiManager.multiPageMode()
            onToggled: uiManager.setModified("multiPageMode", checked)
        }

        // Colors section
        Rectangle
        {
            Layout.columnSpan: 4
            Layout.fillWidth: true
            height: 2
            color: UISettings.bgLight
        }

        RobotoText
        {
            Layout.columnSpan: 4
            height: origItemHeight
            fontSize: origTextSizeDefault * 1.2
            label: qsTr("Colors")
            color: UISettings.sectionHeader
        }

        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("Bright text")
        }
        Loader
        {
            property string kName: "fgMain"
            sourceComponent: colorSelector
            onLoaded: item.init(this, uiManager.getDefault(kName),
                                      uiManager.getModified(kName))

            function updateColor(col)
            {
                uiManager.setModified(kName, col)
            }
        }

        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("Bright background")
        }
        Loader
        {
            property string kName: "bgLight"
            sourceComponent: colorSelector
            onLoaded: item.init(this, uiManager.getDefault(kName),
                                      uiManager.getModified(kName))

            function updateColor(col)
            {
                uiManager.setModified(kName, col)
            }
        }

        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("Medium text")
        }
        Loader
        {
            property string kName: "fgMedium"
            sourceComponent: colorSelector
            onLoaded: item.init(this, uiManager.getDefault(kName),
                                      uiManager.getModified(kName))

            function updateColor(col)
            {
                uiManager.setModified(kName, col)
            }
        }

        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("Medium background")
        }
        Loader
        {
            property string kName: "bgMedium"
            sourceComponent: colorSelector
            onLoaded: item.init(this, uiManager.getDefault(kName),
                                      uiManager.getModified(kName))

            function updateColor(col)
            {
                uiManager.setModified(kName, col)
            }
        }

        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("Dark text")
        }
        Loader
        {
            property string kName: "fgLight"
            sourceComponent: colorSelector
            onLoaded: item.init(this, uiManager.getDefault(kName),
                                      uiManager.getModified(kName))

            function updateColor(col)
            {
                uiManager.setModified(kName, col)
            }
        }

        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("Dark background")
        }
        Loader
        {
            property string kName: "bgMain"
            sourceComponent: colorSelector
            onLoaded: item.init(this, uiManager.getDefault(kName),
                                      uiManager.getModified(kName))

            function updateColor(col)
            {
                uiManager.setModified(kName, col)
            }
        }

        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("Highlight")
        }
        Loader
        {
            property string kName: "highlight"
            sourceComponent: colorSelector
            onLoaded: item.init(this, uiManager.getDefault(kName),
                                      uiManager.getModified(kName))

            function updateColor(col)
            {
                uiManager.setModified(kName, col)
            }
        }

        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("Highlight pressed")
        }
        Loader
        {
            property string kName: "highlightPressed"
            sourceComponent: colorSelector
            onLoaded: item.init(this, uiManager.getDefault(kName),
                                      uiManager.getModified(kName))

            function updateColor(col)
            {
                uiManager.setModified(kName, col)
            }
        }

        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("Hover")
        }
        Loader
        {
            property string kName: "hover"
            sourceComponent: colorSelector
            onLoaded: item.init(this, uiManager.getDefault(kName),
                                      uiManager.getModified(kName))

            function updateColor(col)
            {
                uiManager.setModified(kName, col)
            }
        }

        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("Selection")
        }
        Loader
        {
            property string kName: "selection"
            sourceComponent: colorSelector
            onLoaded: item.init(this, uiManager.getDefault(kName),
                                      uiManager.getModified(kName))

            function updateColor(col)
            {
                uiManager.setModified(kName, col)
            }
        }

        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("Active drop area")
        }
        Loader
        {
            property string kName: "activeDropArea"
            sourceComponent: colorSelector
            onLoaded: item.init(this, uiManager.getDefault(kName),
                                      uiManager.getModified(kName))

            function updateColor(col)
            {
                uiManager.setModified(kName, col)
            }
        }

        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("Item dark border")
        }
        Loader
        {
            property string kName: "borderColorDark"
            sourceComponent: colorSelector
            onLoaded: item.init(this, uiManager.getDefault(kName),
                                      uiManager.getModified(kName))

            function updateColor(col)
            {
                uiManager.setModified(kName, col)
            }
        }

        // Autosave settings section
        Rectangle
        {
            Layout.columnSpan: 4
            Layout.fillWidth: true
            height: 2
            color: UISettings.bgLight
        }

        RobotoText
        {
            Layout.columnSpan: 4
            height: origItemHeight
            fontSize: origTextSizeDefault * 1.2
            label: qsTr("Autosave Settings")
            color: UISettings.sectionHeader
        }

        // Autosave enabled
        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("Enable autosave")
        }
        CustomCheckBox
        {
            implicitWidth: origIconMedium
            implicitHeight: origIconMedium
            checked: uiManager.autosaveEnabled()
            onToggled: uiManager.setAutosaveEnabled(checked)
        }

        // Autosave interval
        RobotoText
        {
            height: origItemHeight
            fontSize: origTextSizeDefault
            label: qsTr("Autosave interval (minutes)")
        }
        CustomSpinBox
        {
            Layout.fillWidth: true
            from: 1
            to: 60
            value: uiManager.autosaveInterval()
            onValueChanged: uiManager.setAutosaveInterval(value)
        }

        // Save button
        Rectangle
        {
            Layout.columnSpan: 4
            Layout.fillWidth: true
            height: 2
            color: UISettings.bgLight
        }

        GenericButton
        {
            Layout.columnSpan: 4
            Layout.alignment: Qt.AlignHCenter
            width: origIconMedium * 10
            height: origIconDefault
            fontSize: origTextSizeDefault
            label: qsTr("Save to file")
            onClicked:
            {
                var fPath = uiManager.userConfFilepath()
                if (uiManager.saveSettings() === true)
                {
                    messagePopup.title = qsTr("Operation completed")
                    messagePopup.message = qsTr("File successfully saved to:" + "<br>" + fPath)
                }
                else
                {
                    messagePopup.title = qsTr("Error")
                    messagePopup.message = qsTr("Unable to save file:" + "<br>" + fPath)
                }
                messagePopup.open()
            }

            Image
            {
                x: parent.width * 0.05
                anchors.verticalCenter: parent.verticalCenter
                width: parent.height * 0.75
                height: width
                source: "qrc:/filesave.svg"
                sourceSize: Qt.size(width, height)
            }
        }
    }
}
