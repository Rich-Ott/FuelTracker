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
                    StandardListItem {
                        id: transactionItem
                        title: {
                            ListItemData.toString()
                        }
                    }
                }
            ]
            onTriggered: {
                select(indexPath)
            }
            onSelectionChanged: {
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
                        add.newFuelTransaction();
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
        }
    }
    actions: [
        ActionItem {
            title: qsTr("Add") + Retranslate.onLanguageChanged
            imageSource: "asset:///images/add.png"
            ActionBar.placement: ActionBarPlacement.Signature
            onTriggered: {
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
}
