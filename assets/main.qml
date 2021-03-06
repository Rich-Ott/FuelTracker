/*
 * Copyright (c) 2015 Richard Ott
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.3
import bb.data 1.0
import bb.system 1.2
import "FuelTransactionPage"
import com.FuelTracker.data 1.0

Page {
    id: transactionListPage

    property variant currentItem
    property bool addShown : false

    Container {
        ListView {
            id: transactionList
            objectName: "transactionList"
            
            layout: StackListLayout {        
            }
            
            dataModel: transactionModel
            
            listItemComponents: [
                ListItemComponent {
                    type: "item"

                    CustomListItem {
                        dividerVisible: true
                        highlightAppearance: HighlightAppearance.Frame
                        id: listItem
                        Container {
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }
                            Container {
                                layout: StackLayout {
                                    orientation: LayoutOrientation.TopToBottom
                                }
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: 1
                                }
                                Label {
                                    textStyle.fontSize: FontSize.PercentageValue
                                    textStyle.fontSizeValue: 135.0
                                    textStyle.fontStyle: FontStyle.Italic
                                    // 1 is the value of the Qt::ISODate DateFormat which
                                    // is apparently not available from Cascades
                                    text: Qt.formatDate(new Date(ListItemData.Date * 1000), 1)
                                }
                                Label {
                                    topMargin: 0
                                    verticalAlignment: VerticalAlignment.Center
                                    text: (ListItemData.Distance / 100.0).toString()
                                }
                            }
                            Label {
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: -1
                                }
                                verticalAlignment: VerticalAlignment.Center
                                textStyle.fontSize: FontSize.PercentageValue
                                textStyle.fontSizeValue: 180.0
                                textStyle.fontWeight: FontWeight.Bold
                                text: (ListItemData.FuelEconomy / 100.0).toString()
                            }
                        }
                        contextActions: [
                            ActionSet {
                                title: qsTr("Transaction") + Retranslate.onLanguageChanged
                                ActionItem {
                                    title: qsTr("Edit") + Retranslate.onLanguageChanged
                                    imageSource: "asset:///images/edit.png"
                                }
                                ActionItem {
                                    title: qsTr("Delete") + Retranslate.onLanguageChanged
                                    imageSource: "asset:///images/delete.png"
                                    onTriggered: {
                                        var m = listItem.ListItem.indexPath
                                        // transactionModel.remove(ListItem.indexPath)
                                    }
                                }
                            }
                        ]
                    }
                }
            ]
            onTriggered: {
                clearSelection()
                select(indexPath)
            }
            onSelectionChanged: {
                // TODO: move this to onTriggered?
                var chosenItem = dataModel.data(indexPath);
                currentItem = chosenItem;
            }
            attachedObjects: [
                FuelTransactionModel {
                    id: transactionModel
                },
                FuelTrackerDataSource {
                    id: fuelTrackerDataSource
                    source: "data/v100.db"
                    query: "SELECT * FROM FuelTransaction ORDER BY Date LIMIT 20"
                    property int loadCounter: 0
                    
                    onDataLoaded: {
                        if(data.length > 0) {
                            transactionModel.insertList(data);
                            var offsetData = {"offset": (20 + 5 * loadCounter)};
                            execute("SELECT * FROM FuelTransaction ORDER BY Date LIMIT 5 OFFSET :offset", offsetData, 0); 
                            loadCounter++;
                        }
                    }
                },
                Sheet {
                    id: addSheet
                    FuelTransactionPage {
                        id: add
                        onFuelTransactionPageClose: {
                            addSheet.close();
                        }
                    }
                    onClosed: {
                        //add.newFuelTransaction();
                    }
                },
                SystemDialog {
                    id: confirmClearDialog
                    title: qsTr("Are you sure?") + Retranslate.onLanguageChanged
                    body: qsTr("This will remove all transactions and cannot be undone. Are you sure you want to do this?") + Retranslate.onLanguageChanged
                    onFinished: {
                        if(confirmClearDialog.result == SystemUiResult.ConfirmButtonSelection) {
                            clearFuelTransactions();
                        }                        
                    }
                }
            ]
            
            onCreationCompleted: {
                fuelTrackerDataSource.load();
            }
            
            shortcuts: [
                SystemShortcut {
                    type: SystemShortcuts.CreateNew
                    onTriggered: {
                        addSheet.open()
                        addShown = true;
                    }
                }
            ]
            accessibility.name: "Transaction List"
            function deleteTransaction(data) {
                data["id"]
            }
            
        }
    }
    actions: [
        ActionItem {
            title: qsTr("Add") + Retranslate.onLanguageChanged
            imageSource: "asset:///images/add.png"
            ActionBar.placement: ActionBarPlacement.Signature
            onTriggered: {
                add.addNewFuelTransaction.connect(addNewFuelTransaction);
                addSheet.open();
                addShown = true;
            }
        },
        ActionItem {
            title: qsTr("Clear") + Retranslate.onLanguageChanged
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                confirmClearDialog.show();
            }
        }
    ]
    
    function deleteFuelTransaction() {
        var itemData = {"id": transactionListPage.currentItem["id"]};
        fuelTrackerDataSource.execute("DELETE FROM FuelTransaction WHERE id=:id", itemData);
        transactionList.dataModel.remove(transactionListPage.currentItem);
    }
    function clearFuelTransactions() {
        fuelTrackerDataSource.execute("DELETE FROM FuelTransaction", null);
        transactionList.dataModel.clear();
    }
    function addNewFuelTransaction(timestamp, distance, odometer, quantity, economy, price, cost, full, location, pump) {
        var itemData = {"Date": timestamp, "Distance": distance, "Odometer": odometer, "Quantity": quantity, "FuelEconomy": economy, "PricePerQuantity": price, "FuelCost": cost, "FilledTank": full, "Location": location, "Pump": pump}
        fuelTrackerDataSource.execute("INSERT INTO FuelTransaction (Date, Distance, Odometer, Quantity, FuelEconomy, PricePerQuantity, FuelCost, FilledTank, Location, Pump) VALUES (:Date, :Distance, :Odometer, :Quantity, :FuelEconomy, :PricePerQuantity, :FuelCost, :FilledTank, :Location, :Pump)", itemData);
        transactionList.dataModel.insert(itemData);
    }    
}
