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

import bb.cascades 1.2
import "FuelTransactionPage"

Page {
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
                        imageSpaceReserved: false
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
                GroupDataModel {
                    id: transactionModel
                    objectName: "transactionModel"
                    grouping: ItemGrouping.ByFirstChar
                    sortingKeys: [""]
                    onItemAdded: {
                        if (addShown) {
                            transactionList.clearSelection();
                            transactionList.select(indexPath);
                            transactionList.scrollToItem(indexPath, ScrollAnimation.Default);
                        }
                    }
                    onItemRemoved: {
                        var lastIndexPath = last();
                    }
                    onItemUpdated: {
                        var chosenItem = data(indexPath);
                        currentItem = chosenItem;
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
                        add.newTransaction();
                    }
                }
            ]
        }
    }
    actions: [
        ActionItem {
            title: "Add"
            imageSource: "asset:///images/add.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                addSheet.open();
                addShown = true;
            }
        }
    ]
}
