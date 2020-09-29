//
//  ViewController.swift
//  PlayVideoFromServerTask
//
//  Created by Vinod Bhaskar on 28/09/20.
//  Copyright © 2020 Metheinspiring. All rights reserved.
//

import UIKit
import Alamofire
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var responseArr = [NSDictionary]()
    
    //View shown incase of error
    @IBOutlet var bgView: UIView!
    
    //used to display error from api response
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCall()
    }
    
    func apiCall(){
        let url:String = K.baseURL
        let request =  AF.request(url)
        request.responseJSON { (response) in
            
            if let err = response.error{
                self.errorLbl.text = err.localizedDescription
                self.tableView.backgroundView = self.bgView
            }
            else if let responseDict = response.value as? NSDictionary ,let videoArr = responseDict.value(forKey: K.messageKey) as? [NSDictionary]{
                //it's valid json response from server
                self.responseArr =  videoArr
                
                //remove older error view if exist
                self.tableView.backgroundView = nil
                
                // Reloading the tableView
                self.tableView.reloadData()
            }else{
                self.errorLbl.text = "Something went wrong please Try Again!"
                self.tableView.backgroundView = self.bgView
            }
            
        }
    }
    
    @IBAction func reloadBtnPress(_ sender: UIButton) {
        //incase of error reload option shown call UI again
        apiCall()
    }
    
    // Function for playing video
    func playVideo(urlString:String){
        
        let path:String = urlString
        let player:AVPlayer = AVPlayer(url: URL(string: path)!)
        player.play()
        //player.isMuted = true
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        present(playerVC, animated: true, completion: nil)
        
    }
}
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.videoTableViewCellIdentifier)as!VideoTableViewCell
        cell.selectionStyle = .none
        cell.backGroundView.layer.cornerRadius = 10
        let videoDict = responseArr[indexPath.row]
        cell.idLabel.text = "ID : \(videoDict.value(forKey: "id") ?? "")"
        cell.urlLabel.text = "URL : \(videoDict.value(forKey: "mp4Video") ?? "")"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let videoDict = responseArr[indexPath.row]
        if let videoUrl = videoDict.value(forKey: "mp4Video") as? String{
            playVideo(urlString: videoUrl)
            apiCall()
        }
    }
}

