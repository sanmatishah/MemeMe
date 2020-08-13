//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Sanmati Shah on 13/08/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var memeImage: UIImage!
    
    @IBOutlet weak var memeImageView: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.image = memeImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        super.viewWillDisappear(animated)
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
