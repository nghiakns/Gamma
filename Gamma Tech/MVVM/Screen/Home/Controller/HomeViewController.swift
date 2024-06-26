//
//  ViewController.swift
//  WebView
//
//  Created by Kim Nghĩa on 22/02/2023.
//

import UIKit
import WebKit
class HomeViewController: UIViewController, WKUIDelegate, AlertCallBack {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var homeTitle: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var addImage: UIImageView!
    
    var invicator = UIActivityIndicatorView()
    var viewModel = HomeViewModels()
    var taskSevices = ModelSevices()
    var tasks:[ModelsUrl] = []
    var message: String = ""
    var isShowAlert: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        configTableView()
        autoLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableview.delegate = self
        tableview.dataSource = self
        do{
            tasks = try taskSevices.getTask()
            tableview.reloadData()
        } catch let error{
            print(error.localizedDescription)
        }
        if !isShowAlert {
            let alert = UIAlertController()
            alert.showAlert(title: ResourceText.commonAlert.localizedString(), message: message, buttonAction: ResourceText.commonClose.localizedString(), controller: self)
            isShowAlert = !isShowAlert
        }
    }
    
    func showAlert(message: String, isShow: Bool) {
        self.message = message
        self.isShowAlert = isShow
    }
    
    func autoLoad() {
        let autoLoad = tasks.first(where: { $0.autoLoad == true})
        if autoLoad != nil {
            guard let url = autoLoad?.url else { return }
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webview") as? WebviewViewController else { return }
            vc.urlString = url
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func config() {
        headerView.backgroundColor = ResourceColor.headerView
        homeTitle.text = ResourceText.homeTitle.localizedString()
        homeTitle.textColor = .white
        invicator.center = view.center
        invicator.style = UIActivityIndicatorView.Style.large
        invicator.color = .black
        view.addSubview(invicator)
    }
    
    func configTableView() {
        tableview.register(UrlTableViewCell.nib, forCellReuseIdentifier: UrlTableViewCell.identifier)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        do{
            tasks = try taskSevices.getTask()
            tableview.reloadData()
        } catch let error{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func infoButton(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "alert") as? AlertViewController else { return }
        vc.modalPresentationStyle = .custom
        vc.view.backgroundColor = .clear
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func settingButton(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "setting") as? SettingViewController else { return }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addButton(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UrlDetailViewController") as? UrlDetailViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UrlTableViewCell.identifier, for: indexPath) as? UrlTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.name.text = tasks[indexPath.row].name
        let image = tasks[indexPath.row].icon ?? ""
        if !image.isEmpty {
            if let decodedData = Data(base64Encoded: image, options: .ignoreUnknownCharacters) {
                cell.iconUrlImageView.image = UIImage(data: decodedData)
            } else {
                cell.iconUrlImageView.image = UIImage(named: "logo_gmt")
            }
        } else {
            cell.iconUrlImageView.image = UIImage(named: "logo_gmt")
        }
        cell.didClickEditButton = {
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UrlDetailViewController") as? UrlDetailViewController else { return }
            vc.model = self.tasks
            vc.index = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = tasks[indexPath.row].url else { return }
        self.invicator.startAnimating()
        let username = tasks[indexPath.row].user ?? ""
        let password = tasks[indexPath.row].password ?? ""
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webview") as? WebviewViewController else { return }
        vc.userName = username
        vc.passWord = password
        vc.urlString = url
        self.invicator.stopAnimating()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

