//
//  SearchWordController.swift
//  FlashWord
//
//  Created by darrenyao on 2016/10/7.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit
import AVOSCloud
import ReactiveCocoa

enum SearchStatus {
    case None
    case History
    case Results
}

class SearchWordController: DYViewController {
    var  searchBar : UISearchBar!
    
    @IBOutlet weak var viewNoResults : UIView!;
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var collectionLayout : UICollectionViewFlowLayout!
    
    var searchStatus = SearchStatus.History
    var historyVM : SearchWordHistoryVM!
    var resultVM : SearchWordResultVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        historyVM = SearchWordHistoryVM(sections: [], data: nil)
        resultVM = SearchWordResultVM(sections: [], data: nil)
        
        setupNavigationBar()
        
        collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0)
        collectionLayout.itemSize = CGSize(width: self.view.bounds.size.width, height: 120)
    }

    override func viewFirstDidAppear() {
        super.viewFirstDidAppear()
        
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    
    func setupNavigationBar() {
        if self.navigationController?.viewControllers.count <= 1 {
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.leftBarButtonItems = nil;
        }
        
        setupSearchBar()
        
        self.navigationItem.titleView = searchBar
    }
    
    func setupSearchBar() {
        let width = self.view.bounds.size.width;
        
        searchBar = UISearchBar(frame:CGRect(x: 0, y: 0, width: width-44, height:30))
        searchBar.delegate = self
        searchBar.placeholder = "搜索单词"
    }
}

extension SearchWordController : UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.length <= 0 {
            if searchStatus != SearchStatus.History {
                searchStatus = SearchStatus.History
                
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let text = searchBar.text
        if text?.length > 0 {
            searchStatus = SearchStatus.Results
            
            
        } else {
            searchStatus = SearchStatus.History
            
        }
    }
}

extension SearchWordController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if searchStatus == SearchStatus.Results {
            return resultVM.numberOfSectionsInCollectionView(collectionView)
        } else if searchStatus == SearchStatus.History {
            return historyVM.numberOfSectionsInCollectionView(collectionView)
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchStatus == SearchStatus.Results {
            return resultVM.collectionView(collectionView, numberOfItemsInSection: section)
        } else if searchStatus == SearchStatus.History {
            return historyVM.collectionView(collectionView, numberOfItemsInSection: section)
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell!
        if searchStatus == SearchStatus.Results {
            cell = resultVM.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        } else if searchStatus == SearchStatus.History {
            cell = historyVM.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        } else {
            cell = UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if searchStatus == SearchStatus.Results {
            return resultVM.collectionView(collectionView, willDisplayCell: cell, forItemAtIndexPath: indexPath)
        } else if searchStatus == SearchStatus.History {
            return historyVM.collectionView(collectionView, willDisplayCell: cell, forItemAtIndexPath: indexPath)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if searchStatus == SearchStatus.Results {
            resultVM.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
        } else if searchStatus == SearchStatus.History {
            historyVM.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if searchStatus == SearchStatus.Results {
            return resultVM.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: indexPath)
        } else if searchStatus == SearchStatus.History {
            return historyVM.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: indexPath)
        } else {
            return CGSizeZero
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if searchStatus == SearchStatus.Results {
            return resultVM.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAtIndex: section)
        } else if searchStatus == SearchStatus.History {
            return historyVM.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAtIndex: section)
        } else {
            return UIEdgeInsetsZero
        }
    }
}

extension SearchWordController : URLNavigable {
    static func urlNavigableViewController(URL: URLConvertible, values: [String : AnyObject])  -> UIViewController? {
        let viewController = UIStoryboard(name: "FlashWord", bundle: nil)
            .instantiateViewControllerWithIdentifier("SearchWordController")
        guard let bookDetailController = viewController as? SearchWordController else {
            return nil
        }
        
        bookDetailController.hidesBottomBarWhenPushed = true
        return bookDetailController
    }
}
