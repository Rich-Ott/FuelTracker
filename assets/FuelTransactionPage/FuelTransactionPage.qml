import bb.cascades 1.3
import com.FuelTracker.data 1.0

Page {
    id: fuelTransactionPage
    signal fuelTransactionPageClose()
    titleBar: TitleBar {
        id: updateBar
        title: "Add"
        visibility: ChromeVisibility.Visible
        dismissAction: ActionItem {
            title: "Cancel"
            onTriggered: {
                fuelTransactionPageClose();
            }
        }
        acceptAction: ActionItem {
            title: "Save"
            onTriggered: {
               // fuelTrackerApp.addNewRecord();
                fuelTransactionPageClose();
            }
        }
    }
    Container {
        id: editPane
        property real margins: 40
        property real controlPadding: 10
        topPadding: editPane.margins
        leftPadding: editPane.margins
        rightPadding: editPane.margins
        layout: StackLayout {            
        }
        
        DateTimePicker {
            id: dateField
            title: qsTr("Date:")
            mode: DateTimePickerMode.Date
        }
        
        Container {
            topPadding: editPane.controlPadding
            bottomPadding: editPane.controlPadding
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Label {
                text: qsTr("Distance:")
                verticalAlignment: VerticalAlignment.Center
            }
            TextField {
                id: distanceField
                hintText: qsTr("Enter Distance")
                inputMode: TextFieldInputMode.NumbersAndPunctuation
            }
        }
        
        Container {
            topPadding: editPane.controlPadding
            bottomPadding: editPane.controlPadding
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Label {
                //objectName: quantityLabel
                text: qsTr("Quantity:")
                verticalAlignment: VerticalAlignment.Center
            }
            TextField {
                id: quantityField
                hintText: qsTr("Enter Quantity")
            }
        }
        
        Container {
            topPadding: editPane.controlPadding
            bottomPadding: editPane.controlPadding
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Label {
                text: qsTr("Fuel Economy:")
                verticalAlignment: VerticalAlignment.Center
            }
            TextField {
                id: fuelEconomyField
                hintText: qsTr("Calculated Fuel Economy")
                enabled: false
            }
        }
        
        Container {
            topPadding: editPane.controlPadding
            bottomPadding: editPane.controlPadding
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Label {
                text: qsTr("Odometer:")
                verticalAlignment: VerticalAlignment.Center
            }
            TextField {
                id: odometerField
                hintText: qsTr("Odometer Reading (optional)")
                //inputMode: SystemUiInputMode.NumericKeypad
            }
        }
        
        Container {
            topPadding: editPane.controlPadding
            bottomPadding: editPane.controlPadding
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Label {
                //objectName: pricePerQuantityLabel
                text: qsTr("Price per Quantity:")
                verticalAlignment: VerticalAlignment.Center
            }
            TextField {
                id: pricePerQuantityField
                hintText: qsTr("Enter price (optional)")
            }
        }

        Container {
            topPadding: editPane.controlPadding
            bottomPadding: editPane.controlPadding
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Label {
                text: qsTr("Fuel Cost:")
                verticalAlignment: VerticalAlignment.Center
            }
            TextField {
                id: fuelCostField
                hintText: qsTr("Enter total fuel cost (optional)")
            }
        }
        
        CheckBox {
            id: filledTankField
            text: qsTr("Filled tank?")
            checked:true
        }
        
        Container {
            topPadding: editPane.controlPadding
            bottomPadding: editPane.controlPadding
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Label {
                text: qsTr("Location:")
                verticalAlignment: VerticalAlignment.Center
            }
            TextField {
                id: locationField
                hintText: qsTr("Enter location (optional)")
            }
        }
        
        Container {
            topPadding: editPane.controlPadding
            bottomPadding: editPane.controlPadding
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Label {
                text: qsTr("Pump:")
                verticalAlignment: VerticalAlignment.Center
            }
            TextField {
                id: pumpField
                hintText: qsTr("Enter pump (optional)")
            }
        }
    }
    function newFuelTransaction() {
        // TODO: disable save button and perform any other initialization
        
    }
}
