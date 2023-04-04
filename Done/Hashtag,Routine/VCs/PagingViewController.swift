//
//  PagingViewController.swift
//  Done
//
//  Created by 안현정 on 2022/03/11.
//

import UIKit
import PagingKit

class PagingViewController: UIViewController {
    
    
    //MARK: - Properties

    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    
    static var viewController: (UIColor) -> UIViewController = { (color) in
       let vc = UIViewController()
        vc.view.backgroundColor = color
        return vc
    }
    
    
    var dataSource = [(menu: String, content: UIViewController)]() {
        didSet {
            menuViewController.reloadData()
            contentViewController.reloadData()
        }
    }
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuViewController?.register(nib: UINib(nibName: "MenuCell", bundle: nil), forCellWithReuseIdentifier: "MenuCell")
        menuViewController?.registerFocusView(nib: UINib(nibName: "FocusView", bundle: nil))
        
        menuViewController.reloadData()
        contentViewController.reloadData()
        
        menuViewController.cellAlignment = .center
        
        dataSource = makeDataSource()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PagingMenuViewController {
            menuViewController = vc
            menuViewController.dataSource = self
            menuViewController.delegate = self

        } else if let vc = segue.destination as? PagingContentViewController {
            contentViewController = vc
            contentViewController.dataSource = self
            contentViewController.delegate = self

        }
    }
    
    
    fileprivate func makeDataSource() ->  [(menu: String, content: UIViewController)] {
        let myMenuArray = ["해시태그", "루틴"]
        
        return myMenuArray.map {
            let title = $0
            
            switch title {
            case "해시태그" :
                let vc = UIStoryboard(name: "TagRoutineVC", bundle: nil).instantiateViewController(identifier: "HashtagViewController") as! HashtagViewController
                return (menu: title, content: vc)
            case "루틴" :
                let vc = UIStoryboard(name: "TagRoutineVC", bundle: nil).instantiateViewController(identifier: "RoutineViewController") as! RoutineViewController
                return (menu: title, content: vc)
            default:
                let vc = UIStoryboard(name: "TagRoutineVC", bundle: nil).instantiateViewController(identifier: "RoutineViewController") as! RoutineViewController
                return (menu: title, content: vc)
            }
        }
    }
    
}
    
    //MARK: - PagingMenuViewControllerDataSource


 extension PagingViewController: PagingMenuViewControllerDataSource {
     func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
         return dataSource.count
     }
     
     func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
         return viewController.view.bounds.width / CGFloat(dataSource.count)
     }
     
     func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
         let cell = viewController.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: index) as! MenuCell
         cell.titleLabel.text = dataSource[index].menu
         return cell
     }
 }
    
    
    //MARK: - PagingContentViewControllerDataSource
    
    extension PagingViewController: PagingContentViewControllerDataSource {
        func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
            return dataSource.count
        }
        
        func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
            return dataSource[index].content
        }
    }
    

extension PagingViewController: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
    }
}

extension PagingViewController: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuViewController.scroll(index: index, percent: percent, animated: false)
    }
}


