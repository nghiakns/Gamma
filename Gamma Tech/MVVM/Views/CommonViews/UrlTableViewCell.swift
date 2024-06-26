//
//  UrlTableViewCell.swift
//  WebView
//
//  Created by Kim Nghĩa on 06/03/2023.
//

import UIKit

class UrlTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var iconUrlImageView: UIImageView!
    static let identifier = "UrlTableViewCell"
    static var nib = UINib(nibName: identifier, bundle: nil)
    var didClickEditButton: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        viewCell.layer.borderWidth = 2
        viewCell.layer.borderColor = CGColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1)
        viewCell.layer.cornerRadius = 5
        iconUrlImageView.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editUrlButton(_ sender: Any) {
        didClickEditButton?()
    }

}
