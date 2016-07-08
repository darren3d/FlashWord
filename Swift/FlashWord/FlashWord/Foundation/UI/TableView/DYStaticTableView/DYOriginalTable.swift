//
//  DYOriginalTable.swift
//  FlashWord
//
//  Created by darrenyao on 16/7/9.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYOriginalTable: NSObject {
    var sections: [DYOriginalSection]
    weak var tableView: UITableView?
    var insertIndexPaths: [NSIndexPath]
    var deleteIndexPaths: [NSIndexPath]
    var updateIndexPaths: [NSIndexPath]
    
    init(tableView: UITableView) {
        let numberOfSections = tableView.numberOfSections
        self.sections = [DYOriginalSection]()
        var totalNumberOfRows = 0
        for i in 0 ..< numberOfSections {
            let originalSection = DYOriginalSection()
            let numberOfRows = tableView.numberOfRowsInSection(i)
            totalNumberOfRows += numberOfRows
            originalSection.rows = [DYOriginalRow]()
            for ii in 0 ..< numberOfRows {
                let tableViewRow = DYOriginalRow()
                let path = NSIndexPath(forRow: ii, inSection: i)
                tableViewRow.cell = tableView.dataSource!.tableView(tableView, cellForRowAtIndexPath: path)
                assert(tableViewRow.cell != nil, "cannot be nil")
                tableViewRow.originalIndexPath = path
                originalSection.rows[ii] = tableViewRow
            }
            self.sections[i] = originalSection
        }
        self.insertIndexPaths = [NSIndexPath]()
        self.deleteIndexPaths = [NSIndexPath]()
        self.updateIndexPaths = [NSIndexPath]()
        self.tableView = tableView
        
        super.init()
    }
    
    func originalRowWithIndexPath(indexPath: NSIndexPath) -> DYOriginalRow {
        let oSection = self.sections[indexPath.section]
        let oRow = oSection.rows[indexPath.row]
        return oRow
    }
    
    func vissibleOriginalRowWithIndexPath(indexPath: NSIndexPath) -> DYOriginalRow? {
        let oSection = self.sections[indexPath.section]
        var vissibleIndex = -1
        for i in 0 ..< oSection.rows.count {
            let oRow = oSection.rows[i]
            if !oRow.hidden {
                vissibleIndex += 1
            }
            if indexPath.row == vissibleIndex {
                return oRow
            }
        }
        return nil
    }
    
    func originalRowWithTableViewCell(cell: UITableViewCell) -> DYOriginalRow? {
        for i in 0 ..< self.sections.count {
            let os = self.sections[i]
            for ii in 0 ..< os.rows.count {
                if os.rows[ii].cell == cell {
                    return os.rows[ii]
                }
            }
        }
        return nil
    }
    
    func indexPathForInsertingOriginalRow(originalRow: DYOriginalRow) -> NSIndexPath {
        let originalIndexPath = originalRow.originalIndexPath!
        let oSection = self.sections[originalIndexPath.section]
        var vissibleIndex = -1
        for i in 0 ..< originalIndexPath.row {
            let oRow = oSection.rows[i]
            if !oRow.hidden {
                vissibleIndex += 1
            }
        }
        return NSIndexPath(forRow: vissibleIndex + 1, inSection: originalIndexPath.section)
    }
    
    func indexPathForDeletingOriginalRow(originalRow: DYOriginalRow) -> NSIndexPath {
        let originalIndexPath = originalRow.originalIndexPath!
        let oSection = self.sections[originalIndexPath.section]
        var vissibleIndex = -1
        for i in 0 ..< originalIndexPath.row {
            let oRow = oSection.rows[i]
            if !oRow.hiddenReal {
                vissibleIndex += 1
            }
        }
        return NSIndexPath(forRow:vissibleIndex + 1, inSection:originalIndexPath.section)
    }
    
    func prepareUpdates() {
        self.insertIndexPaths.removeAll()
        self.deleteIndexPaths.removeAll()
        self.updateIndexPaths.removeAll()
        for os: DYOriginalSection in self.sections {
            for or: DYOriginalRow in os.rows {
                if or.batchOperation == DYBatchOperation.Delete {
                    let ip = self.indexPathForDeletingOriginalRow(or)
                    self.deleteIndexPaths.append(ip)
                } else if or.batchOperation == DYBatchOperation.Insert {
                    let ip = self.indexPathForInsertingOriginalRow(or)
                    self.insertIndexPaths.append(ip)
                } else if or.batchOperation == DYBatchOperation.Update {
                    let ip = self.indexPathForInsertingOriginalRow(or)
                    self.updateIndexPaths.append(ip)
                }
            }
        }
        for os: DYOriginalSection in self.sections {
            for or: DYOriginalRow in os.rows {
                or.hiddenReal = or.hiddenPlanned
                or.batchOperation = DYBatchOperation.None
            }
        }
    }
}
