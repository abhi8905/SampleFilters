//
//  FilterVC.swift
//  SampleFilters
//
//  Created by Abhinav Jha on 21/06/23.
//

import UIKit

enum Periods: String{
    case oneMonth = "30"
    case oneWeek = "7"
    case oneDay = "1"
}
enum Sections: String{
    case mostViewed = "mostviewed"
    case mostShared = "mostshared"
    case mostEmailed = "mostemailed"
}

protocol FilterVCDelegate: AnyObject {
    func filterVCDidCancel()
    func filterVCDidChange(params: (Sections,Periods))
}


class FilterVC: UIViewController,UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var sectionsStackView: UIStackView!
    @IBOutlet weak var periodsStackView: UIStackView!
    @IBOutlet weak var mostViewedBtn: UIButton!
    @IBOutlet weak var mostSharedBtn: UIButton!
    @IBOutlet weak var mostEmailedBtn: UIButton!
    @IBOutlet weak var oneMonthBtn: UIButton!
    @IBOutlet weak var oneWeekBtn: UIButton!
    @IBOutlet weak var oneDayBtn: UIButton!
    var existingParams: (Sections,Periods)?
    var sectionFilter: Sections = .mostEmailed {
        didSet {
            viewIfLoaded?.setNeedsLayout()
        }
    }
    var periodFilter: Periods = .oneDay {
        didSet {
            viewIfLoaded?.setNeedsLayout()
        }
    }
    var isSectionExpanded = false
    var isPeriodExpanded = false
    var paramsDidChange: Bool {
        guard let existingParams = existingParams else {
            return true
        }
        return existingParams != (sectionFilter,periodFilter)
    }
    weak var delegate: FilterVCDelegate?

    class func instance() -> FilterVC? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "FilterVC") as? FilterVC else {
            return nil
        }
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.presentationController?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        applyBtn.isEnabled = paramsDidChange
        isModalInPresentation = paramsDidChange
    }
    
    @IBAction func sectionsFilterTapped(_ sender: UIButton) {
        let btnArray = [mostSharedBtn,mostViewedBtn,mostEmailedBtn]
        set(button: sender, selectionFrom: btnArray)
        switch sender.tag {
        case 1:
            // Change to Most Emailed
            sectionFilter = .mostEmailed
        case 2:
            // Change to Most Shared
            sectionFilter = .mostShared
        case 3:
            // Change to Most Viewed
            sectionFilter = .mostViewed
        default:
            print("Unknown Section")
            return
        }
    }
    
    @IBAction func periodsFilterTapped(_ sender: UIButton) {
        let btnArray = [oneMonthBtn,oneWeekBtn,oneDayBtn]
        set(button: sender, selectionFrom: btnArray)
        switch sender.tag {
        case 1:
            // Change to One Day
            periodFilter = .oneDay
        case 2:
            // Change to One Week
            periodFilter = .oneWeek
        case 3:
            // Change to One Month
            periodFilter = .oneMonth
        default:
            print("Unknown Period")
            return
        }
    }
    
    @IBAction func applyBtnTapped(_ sender: Any) {
        self.delegate?.filterVCDidChange(params: (self.sectionFilter,self.periodFilter))
    }
    @IBAction func sectionsFilterExpand(_ sender: UIButton) {
        sectionsStackView.isHidden = isSectionExpanded
        sender.setImage(isSectionExpanded ? UIImage(systemName: "plus") : UIImage(systemName: "minus"), for: .normal)
        isSectionExpanded.toggle()
    }
    
    @IBAction func closeFilterTapped(_ sender: Any) {
        if paramsDidChange{
            confirmCancel()
        }else{
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func periodsFilterExpand(_ sender: UIButton) {
        periodsStackView.isHidden = isPeriodExpanded
        sender.setImage(isPeriodExpanded ? UIImage(systemName: "plus") : UIImage(systemName: "minus"), for: .normal)
        isPeriodExpanded.toggle()
    }
    
    
    func set(button: UIButton?, selectionFrom array: [UIButton?] ) {
        guard let button = button else {
            return
        }
        array.forEach {
            if $0?.tag == button.tag{
                $0?.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            }else{
                $0?.setImage(UIImage(systemName: "circle"), for: .normal)
                }
            }
        }
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        confirmCancel()
    }

    
    func confirmCancel() {
        // Present a UIAlertController as an action sheet to have the user confirm losing any
        // recent changes.
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Only ask if the user wants to save if they attempt to pull to dismiss, not if they tap Cancel.
        if paramsDidChange {
            alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
                guard let self = self else{
                    return
                }
                self.delegate?.filterVCDidChange(params: (self.sectionFilter,self.periodFilter))
            })
        }
        
        alert.addAction(UIAlertAction(title: "Discard Changes", style: .destructive) { _ in
            self.delegate?.filterVCDidCancel()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // If presenting the alert controller as a popover, point the popover at the Cancel button.
//        alert.popoverPresentationController?.barButtonItem = cancelBtn
        
        present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
