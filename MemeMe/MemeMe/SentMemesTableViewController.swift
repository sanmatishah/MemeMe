//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Sanmati Shah on 10/08/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {

    var memes: [MemeModel]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
        
    // MARK: - Table view data source
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemesTableViewCell", for: indexPath)

        let memeObject = memes[indexPath.row]
        cell.imageView?.image = memeObject.memedImage
        cell.textLabel?.text = memeObject.topText + "..." + memeObject.bottomText

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.memeImage = memes[indexPath.row].memedImage
        navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
}
