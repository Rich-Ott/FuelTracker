import bb.cascades 1.3

GroupDataModel {
    id: transactionModel
    objectName: "transactionModel"

    onItemAdded: {
        if (transactionListPage.addShown) {
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
}