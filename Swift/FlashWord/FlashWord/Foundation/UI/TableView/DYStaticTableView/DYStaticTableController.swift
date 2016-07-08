//
//  DYStaticTableController.swift
//  FlashWord
//
//  Created by darrenyao on 16/7/9.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYStaticTableController: UITableViewController {
    var hideSectionsWithHiddenRows = false
    var animateSectionHeaders = false
    var insertTableViewRowAnimation = UITableViewRowAnimation.Right
    var deleteTableViewRowAnimation = UITableViewRowAnimation.Left
    var reloadTableViewRowAnimation = UITableViewRowAnimation.Middle
    lazy var originalTable: DYOriginalTable = {
        let originalTable = DYOriginalTable(tableView: self.tableView)
        return originalTable
    }()
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.insertTableViewRowAnimation = UITableViewRowAnimation.Right
        self.deleteTableViewRowAnimation = UITableViewRowAnimation.Left
        self.reloadTableViewRowAnimation = UITableViewRowAnimation.Middle
        
    }
    
    func updateCell(cell: UITableViewCell) {
        let row = self.originalTable.originalRowWithTableViewCell(cell)
        row?.update()
    }
    
    func updateCells(cells: [UITableViewCell]) {
        for cell: UITableViewCell in cells {
            self.updateCell(cell)
        }
    }
    
    func cell(cell: UITableViewCell, setHidden hidden: Bool) {
        let row = self.originalTable.originalRowWithTableViewCell(cell)
        row?.hidden = hidden
    }
    
    func cells(cells: [UITableViewCell], setHidden hidden: Bool) {
        for cell: UITableViewCell in cells {
            self.cell(cell, setHidden: hidden)
        }
    }
    
    func cell(cell: UITableViewCell, setHeight height: CGFloat) {
        let row = self.originalTable.originalRowWithTableViewCell(cell)
        row?.height = height
    }
    
    func cells(cells: [UITableViewCell], setHeight height: CGFloat) {
        for cell: UITableViewCell in cells {
            self.cell(cell, setHeight: height)
        }
    }
    
    func cellIsHidden(cell: UITableViewCell) -> Bool {
        guard let row = self.originalTable.originalRowWithTableViewCell(cell) else {
            return true
        }
        return row.hidden
    }
    
    func reloadDataAnimated(animated: Bool) {
        self.originalTable.prepareUpdates()
        if !animated {
            self.tableView.reloadData()
        } else {
            if self.animateSectionHeaders {
                for indexPath: NSIndexPath in self.originalTable.deleteIndexPaths {
                    let cell = self.tableView.cellForRowAtIndexPath(indexPath)
                    cell?.layer.zPosition = -2
                    self.tableView.headerViewForSection(indexPath.section)?.layer.zPosition = -1
                }
            }
            self.tableView.beginUpdates()
            self.tableView.reloadRowsAtIndexPaths(self.originalTable.updateIndexPaths, withRowAnimation: self.reloadTableViewRowAnimation)
            self.tableView.insertRowsAtIndexPaths(self.originalTable.insertIndexPaths, withRowAnimation: self.insertTableViewRowAnimation)
            self.tableView.deleteRowsAtIndexPaths(self.originalTable.deleteIndexPaths, withRowAnimation: self.deleteTableViewRowAnimation)
            self.tableView.endUpdates()
            if !self.animateSectionHeaders {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if self.originalTable == nil {
        //            return super.tableView(tableView, numberOfRowsInSection: section)
        //        }
        return self.originalTable.sections[section].numberOfVissibleRows()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        if self.originalTable == nil {
        //            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        //        }
        let or = self.originalTable.vissibleOriginalRowWithIndexPath(indexPath)
        assert(or!.cell != nil, "CANNOT BE NULL")
        return or!.cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //        if self.originalTable != nil {
        //            var or = self.originalTable.vissibleOriginalRowWithIndexPath(indexPath)
        //            if or.height != CGFLOAT_MAX {
        //                return or.height
        //            }
        //            indexPath = or.originalIndexPath
        //        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = super.tableView(tableView, heightForHeaderInSection: section)
        return self.headerFooterHeightForSection(section, originalHeight: height)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        if tableView.dataSource!.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return ""
        } else {
            let title = super.tableView(tableView, titleForHeaderInSection: section)
            return title ?? ""
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let height = super.tableView(tableView, heightForFooterInSection: section)
        return self.headerFooterHeightForSection(section, originalHeight: height)
    }
    
    func headerFooterHeightForSection(section: Int, originalHeight height: CGFloat) -> CGFloat {
        //        if self.originalTable == nil {
        //            return height
        //        }
        if !self.hideSectionsWithHiddenRows {
            return height
        }
        let os = self.originalTable.sections[section]
        if os.numberOfVissibleRows() == 0 {
            return CGFloat.max
        } else {
            return height
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String {
        if tableView.dataSource!.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return ""
        } else {
            let title = super.tableView(tableView, titleForFooterInSection: section)
            return title ?? ""
        }
    }
}
