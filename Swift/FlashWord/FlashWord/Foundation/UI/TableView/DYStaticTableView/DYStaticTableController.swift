//
//  DYStaticTableController.swift
//  FlashWord
//
//  Created by darrenyao on 16/7/9.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class DYStaticTableController: UITableViewController {
    var viewModel : DYViewModel?
    
    deinit {
    }
    
    var hideSectionsWithHiddenRows = false
    var animateSectionHeaders = false
    var insertTableViewRowAnimation = UITableViewRowAnimation.Right
    var deleteTableViewRowAnimation = UITableViewRowAnimation.Left
    var reloadTableViewRowAnimation = UITableViewRowAnimation.Middle
    lazy var originalTable: DYOriginalTable? = nil
    
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
        
        originalTable = DYOriginalTable(tableView: self.tableView)
    }
    
    func updateCell(cell: UITableViewCell) {
        guard let originalTable = originalTable else {
            return
        }
        
        let row = originalTable.originalRowWithTableViewCell(cell)
        row?.update()
    }
    
    func updateCells(cells: [UITableViewCell]) {
        for cell: UITableViewCell in cells {
            self.updateCell(cell)
        }
    }
    
    func cell(cell: UITableViewCell, setHidden hidden: Bool) {
        guard let originalTable = originalTable else {
            return
        }
        
        let row = originalTable.originalRowWithTableViewCell(cell)
        row?.hidden = hidden
    }
    
    func cells(cells: [UITableViewCell], setHidden hidden: Bool) {
        for cell: UITableViewCell in cells {
            self.cell(cell, setHidden: hidden)
        }
    }
    
    func cell(cell: UITableViewCell, setHeight height: CGFloat) {
        guard let originalTable = originalTable else {
            return
        }
        
        let row = originalTable.originalRowWithTableViewCell(cell)
        row?.height = height
    }
    
    func cells(cells: [UITableViewCell], setHeight height: CGFloat) {
        for cell: UITableViewCell in cells {
            self.cell(cell, setHeight: height)
        }
    }
    
    func cellIsHidden(cell: UITableViewCell) -> Bool {
        guard let originalTable = originalTable else {
            return false
        }
        
        guard let row = originalTable.originalRowWithTableViewCell(cell) else {
            return false
        }
        return row.hidden
    }
    
    func reloadDataAnimated(animated: Bool) {
        guard let originalTable = originalTable else {
            return
        }
        
        originalTable.prepareUpdates()
        if !animated {
            self.tableView.reloadData()
        } else {
            if self.animateSectionHeaders {
                for indexPath: NSIndexPath in originalTable.deleteIndexPaths {
                    let cell = self.tableView.cellForRowAtIndexPath(indexPath)
                    cell?.layer.zPosition = -2
                    self.tableView.headerViewForSection(indexPath.section)?.layer.zPosition = -1
                }
            }
            self.tableView.beginUpdates()
            self.tableView.reloadRowsAtIndexPaths(originalTable.updateIndexPaths, withRowAnimation: self.reloadTableViewRowAnimation)
            self.tableView.insertRowsAtIndexPaths(originalTable.insertIndexPaths, withRowAnimation: self.insertTableViewRowAnimation)
            self.tableView.deleteRowsAtIndexPaths(originalTable.deleteIndexPaths, withRowAnimation: self.deleteTableViewRowAnimation)
            self.tableView.endUpdates()
            if !self.animateSectionHeaders {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let originalTable = originalTable else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
        
        return originalTable.sections[section].numberOfVissibleRows()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let originalTable = originalTable else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
        
        let or = originalTable.vissibleOriginalRowWithIndexPath(indexPath)
        assert(or!.cell != nil, "Cannot be nil")
        return or!.cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard let originalTable = originalTable
            else {
                return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
        
        guard let originalRow = originalTable.vissibleOriginalRowWithIndexPath(indexPath)
            else {
                return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
        
        if originalRow.height != CGFloat.max {
            return originalRow.height
        }
        
        guard let originalIndexPath = originalRow.originalIndexPath
            else {
                return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
        
        return super.tableView(tableView, heightForRowAtIndexPath: originalIndexPath)
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
        guard let originalTable = originalTable else {
            return height
        }
        
        if !self.hideSectionsWithHiddenRows {
            return height
        }
        let os = originalTable.sections[section]
        if os.numberOfVissibleRows() == 0 {
            return CGFloat.min
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
