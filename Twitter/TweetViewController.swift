import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.becomeFirstResponder()
    }
    

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweet(_ sender: UIBarButtonItem) {
        if (!tweetTextView.text.isEmpty){
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { Error in
                print(Error)
                self.dismiss(animated: true, completion: nil)
            })
        } else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    


}
