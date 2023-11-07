//
//  HomeTableViewCell2.swift
//  InstaClone
//
//  Created by Barış Aydemir on 2.11.2023.
//

import UIKit

class HomeTableViewCell2: UITableViewCell {
 // MARK: - PROPERTIES
    
    @IBOutlet weak var userProfilePictureImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userPostImg: UIImageView!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var MainUserPpImg: UIImageView!
    @IBOutlet weak var postTimeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButtonTapped(_ sender: Any) {
        print("Like Button Tıklandı")
    }
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        print("Comment Button Tıklandı")
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        print("Share Button Tıklandı")
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        print("Save Button Tıklandı")
    }
    
    
}
