import bb.cascades 1.3
import com.FuelTracker.data 1.0

Page {
    id: fuelTransactionPage
    signal fuelTransactionPageClose()
    signal addNewFuelTransaction(int timestamp, int distance, int odometer, int quantity, int economy, int price, int cost, int full, string location, string pump)
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
                // TODO: validate input data
                addNewFuelTransaction(
                    parseInt(dateField.value.getTime() / 1000),
                    parseInt(parseFloat(distanceField.text) * 100),
                    parseInt(parseFloat(odometerField.text) * 100),
                    parseInt(parseFloat(quantityField.text) * 100),
                    parseInt(parseFloat(distanceField.text) / parseFloat(quantityField.text) * 100),
                    parseInt(parseFloat(pricePerQuantityField.text) * 1000),
                    parseInt(parseFloat(fuelCostField.text) * 1000),
                    filledTankField.checked ? 1 : 0,
                    locationField.text,
                    pumpField.text
                );
                fuelTransactionPageClose();
            }
        }
    }
    ScrollView {
        scrollViewProperties.scrollMode: ScrollMode.Vertical
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
                    onTextChanged: {
                        var qty = parseFloat(quantityField.text);
                        var distance = parseFloat(text)
                        fuelEconomyField.text = fuelTransactionPage.calculateFuelEconomy(distance, qty);
                    }
                    onTextChanging: {
                        distanceField.text = fuelTransactionPage.validateNumericInput(text, 2);
                    }
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
                    onTextChanged: {
                        var qty = parseFloat(text);
                        var distance = parseFloat(distanceField.text)
                        fuelEconomyField.text = fuelTransactionPage.calculateFuelEconomy(distance, qty);
                    }
                    onTextChanging: {
                        quantityField.text = fuelTransactionPage.validateNumericInput(text, 2);
                    }
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
    }
    
    // validates numeric input to only accept numbers and
    // decimal places up to "floatScale" decimal places
    function validateNumericInput(text, floatScale) {
        var result = String(text);
        // TODO: replace the decimal point with a
        //       localized version from QLocale 
        var pattern = "[^\\d.]";
        var regex = new RegExp(pattern, "g");
        result = result.replace(regex, "");

        // Only allow a single decimal place
        if(result.split(".").length >= 3) {
            result = result.substring(0, result.length  -1);
        }

        // total floating point precision plus 1 is used
        // to determine the max string length allowed
        var decimalIndex = result.indexOf(".");
        if(decimalIndex != -1) {
            var precision = decimalIndex + floatScale + 1;
            if(precision < result.length) {
                result = result.substring(0, precision);
            }
        }
        return result;
    }
    // returns fuel economy rounded to two decimal places
    function calculateFuelEconomy(distance, quantity) {
        var valuesAreNumeric = (isFinite(distance) && isFinite(quantity));
        if(!valuesAreNumeric || quantity === 0) {
            return 0;
        }
        distance
        return parseFloat(distance / quantity).toFixed(2);
    }
}
