import UIKit

class HomeTableTableViewController: UITableViewController{

    var tweetArray = [NSDictionary]()
    var numberofTweets: Int!
    
    let myRefreshControl = UIRefreshControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
        
        
        myRefreshControl.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    @objc func loadTweet(){
        
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": 10]
        
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: { tweets in
            
            self.tweetArray.removeAll()
            
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
            
        }, failure: { Error in
            print("could not get tweets")
        })
    }
    
    

    @IBAction func onLogout(_ sender: UIBarButtonItem) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated:true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        
        let imageData = try? Data(contentsOf: imageURL!)
        
        if let data = imageData{
            cell.profileImageView.image = UIImage(data: data)
        }
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContentLabel.text = tweetArray[indexPath.row]["text"] as? String
        
        return cell
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }

}
