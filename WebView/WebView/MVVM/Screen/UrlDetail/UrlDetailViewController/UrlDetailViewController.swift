//
//  UrlDetailViewController.swift
//  WebView
//
//  Created by Kim Nghĩa on 08/03/2023.
//


import UIKit
import DropDown

class UrlDetailViewController: UIViewController, didSeclectImage {

    @IBOutlet weak var imageDropDownI: UIImageView!
    @IBOutlet weak var dropDownDomainButton: UIButton!
    @IBOutlet weak var IPView: UIView!
    @IBOutlet weak var IPDomainTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var paramTextfield: UITextField!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var accTextfield: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var dropDownHomeButton: UIButton!
    @IBOutlet weak var imageHome: UIImageView!
    @IBOutlet weak var domainView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var SwitchAutoLoadUrl: UISwitch!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteImage: UIImageView!
    
    var model: [ModelsUrl] = []
    let DropdownDomain = DropDown()
    let DropdownHome = DropDown()
    let urlSevices = ModelSevices()
    var imageIcon: UIImage?
    var index: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        imageDropDownI.setImageColor(color: UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1))
        imageHome.setImageColor(color: UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1))
        configEditController()
    }
    
    func didSeclectImage(image: UIImage) {
        self.iconImage.image = image
        imageIcon = image
    }
    
    private func configure() {
        deleteImage.isHidden = true
        deleteButton.isHidden = true
        addButton.setTitle("Add URL", for: .normal)
        headerView.backgroundColor = ResourceColor.headerView
        DropdownDomain.anchorView = dropDownDomainButton
        DropdownDomain.dataSource = DropdownData.inspectionTimes
        DropdownHome.anchorView = dropDownHomeButton
        DropdownHome.dataSource = DropdownData.homeDropDown
        dropDownDomainButton.layer.borderColor = UIColor.lightGray.cgColor
        dropDownDomainButton.layer.borderWidth = 1
        dropDownDomainButton.layer.cornerRadius = 4
        dropDownDomainButton.layer.masksToBounds = true
        IPView.layer.borderWidth = 1
        IPView.layer.cornerRadius = 25
        IPView.layer.masksToBounds = true
        homeView.layer.borderWidth = 1
        homeView.layer.cornerRadius = 25
        homeView.layer.masksToBounds = true
        addButton.layer.borderWidth = 1
        addButton.layer.cornerRadius = 25
        addButton.layer.masksToBounds = true
        domainView.layer.borderWidth = 1
        domainView.layer.cornerRadius = 25
        domainView.layer.masksToBounds = true
        coradius(textfield: nameTextfield)
        coradius(textfield: paramTextfield)
        coradius(textfield: passTextField)
        coradius(textfield: accTextfield)
        //nguyen
        dropDownDomainButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        DropdownDomain.selectionAction = { [weak self] (index: Int, item: String) in
            self?.dropDownDomainButton.setTitle(item, for: .normal)
            HAUserDefault.saveCountDownIntervalTime(intervalTime: item.getDomain())
        }
        DropdownHome.selectionAction = { [weak self] (index: Int, item: String) in
            self?.dropDownHomeButton.setTitle(item, for: .normal)
            HAUserDefault.saveCountDownIntervalTime(intervalTime: item.getHome())
        }
    }
    
    func configEditController() {
        if let index = self.index {
            addButton.setTitle("Edit URL", for: .normal)
            deleteImage.isHidden = false
            deleteButton.isHidden = false
            IPDomainTextField.text = self.model[index].domain ?? ""
            dropDownDomainButton.setTitle(self.model[index].protocols ?? "-", for: .normal)
            nameTextfield.text = self.model[index].name ?? ""
            accTextfield.text = self.model[index].user ?? ""
            passTextField.text = self.model[index].password ?? ""
            SwitchAutoLoadUrl.isOn = self.model[index].autoLoad ?? false
            dropDownHomeButton.setTitle(self.model[index].autoLoadPage ?? "", for: .normal)
            paramTextfield.text = self.model[index].params ?? ""
            let image = self.model[index].icon ?? ""
            if !image.isEmpty {
                if let data = Data(base64Encoded: self.model[index].icon ?? "", options: .ignoreUnknownCharacters) {
                    iconImage.image = UIImage(data: data)
                } else {
                    iconImage.image = UIImage(named: "logo_gmt")
                }
            } else {
                iconImage.image = UIImage(named: "logo_gmt")
            }
        }
        
    }
    

    func coradius(textfield: UITextField) {
        textfield.layer.borderWidth = 1
        textfield.layer.cornerRadius = 25
        textfield.layer.masksToBounds = true
    }
    
    @IBAction func didTapAddUrl(_ sender: Any) {
        let domainTextField = IPDomainTextField.text?.isEmpty ?? true
        let nameTextField = nameTextfield.text?.isEmpty ?? true
        if deleteButton.isHidden {
            if domainTextField || nameTextField {
                print("fill info")
            } else {
                let data = imageIcon
                let convertImage = data?.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
                let task = ModelsUrl(domain: IPDomainTextField.text, protocols: DropdownDomain.textInputContextIdentifier, name: nameTextfield.text, user: accTextfield.text, password: passTextField.text, icon: convertImage, autoLoad: SwitchAutoLoadUrl.isOn, autoLoadPage: nil, params: paramTextfield.text, url: nil)
                do {
                    try urlSevices.saveTask(task: task)
                    self.navigationController?.popViewController(animated: true)
                } catch let error{
                    print(error)
                }
            }
        } else {
            
        }
        
    }
    
    @IBAction func PodViewHomeTapButton(_ sender: Any) {
        let UIStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let VC = UIStoryBoard.instantiateViewController(withIdentifier: "UrlDetailViewController") as? UrlDetailViewController else { return }
        VC.modalPresentationStyle = .fullScreen
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dropDownHome(_ sender: Any) {
        DropdownHome.show()
    }
    @IBAction func dropDownDomainTapButton(_ sender: Any) {
        DropdownDomain.show()
    }
    
    @IBAction func AlertTapButton(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertIconViewController") as? AlertIconViewController else { return }
        vc.delegate = self
        vc.modalPresentationStyle = .custom
        vc.view.backgroundColor = .clear
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        if let index = self.index {
            let task = model[index]
            do {
                try urlSevices.removeTask(task: task, index: index)
                self.navigationController?.popViewController(animated: true)
            } catch let error{
                print(error)
            }
        }
    }
    
}


extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}