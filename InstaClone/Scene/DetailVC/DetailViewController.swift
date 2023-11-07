//
//  DetailViewController.swift
//  InstaClone
//
//  Created by Barış Aydemir on 2.11.2023.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var userPpImg: UIImageView!
    @IBOutlet weak var userPostImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userCommentLbl: UILabel!
    var photo:Photo?
    override func viewDidLoad() {
        super.viewDidLoad()

        ppCornerRadius()
        //userPpImg.layer.cornerRadius = 35
        if let k = photo {
            userNameLbl.text = k.ownername
            userCommentLbl.text = k.title
            
            NetworkManager.shared.fetchImage(with: k.buddyIconURL) { data in
                self.userPpImg.image = UIImage(data: data)
            }
            NetworkManager.shared.fetchImage(with: k.urlN) { data in
                self.userPostImg.image = UIImage(data: data)
            }
        }
    }
    
    private func ppCornerRadius() {
        var height = userPpImg.frame.size.height
        userPpImg.layer.cornerRadius = height/2
    }
    
}
