//
//  ProfileViewController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 15.03.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labelSurname: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var ratingBar: RatingBar!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var btnNetworks: UIButton!
    @IBOutlet weak var btnReviews: UIButton!
    @IBOutlet weak var btnBlockList: UIButton!
    @IBOutlet weak var btnDeleteAccount: UIButton!
    @IBOutlet weak var btnExit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnEditProfile.layer.cornerRadius = 8
        btnNetworks.layer.cornerRadius = 8
        btnReviews.layer.cornerRadius = 8
        btnBlockList.layer.cornerRadius = 8
        btnDeleteAccount.layer.cornerRadius = 8
        btnExit.layer.cornerRadius = 8
        imgView.layer.cornerRadius = imgView.frame.height/2
        imgView.clipsToBounds = true


        
        getFullInfoAboutProfile(withData: 1, withResult: {[weak self] response in
            guard let res = response as? DataResponseResult<Profile> else {
                return
            }
            let userInfo = res.value
            self?.labelName.text = userInfo.name
            self?.labelSurname.text = userInfo.surname
            self?.downloadImage(from: userInfo.photoUrl)
        })

        // Do any additional setup after loading the view.
    }

    func downloadImage(from urlString: String?) {
        guard let url = URL(string: urlString ?? "") else {
            return
        }
        getData(from: url) { data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async { [weak self] in
                self?.imgView.image = UIImage(data: data)
            }
        }
    }

    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

}
