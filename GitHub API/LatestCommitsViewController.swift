//
//  ViewController.swift
//  GitHub API
//
//  Created by Inho Hwang on 2021/2/22.
//

import UIKit



class LatestCommitsViewController: UIViewController{

    @IBOutlet var tableView: UITableView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    let refreshControl = UIRefreshControl()
    
    var currentlyFetchingCommits = false
    var commitViewModelArray = [CommitViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        fetchUpTo25LatestCommits()
    }
    
    @objc func refresh(sender:AnyObject) {
        if (!currentlyFetchingCommits) {
            fetchUpTo25LatestCommits()
        }
    }

    func fetchUpTo25LatestCommits() {
        currentlyFetchingCommits = true;
        self.spinner.startAnimating()
        SimpleServerCall.init().gitHubAPIGET(endPartOfUrlWithoutSlashInFront: "repos/InhoHwangTestApps/GitHub-API/commits", parameters: ["sha":"main", "per_page":25, "page": "0"], tryAgainOnceIfFailed: true, completionHandler: { (success, response, error) in
            if (success) {
                self.commitViewModelArray = GitHubAPIDecoder.getListOfCommmitViewModels(gitHubResponseOfListOfCommits: response)
                self.tableView.reloadData()
            } else {
                let alertController = UIAlertController(title: "Something went wrong", message: "Raise a issue in my GitHub page: https://github.com/InhoHwangTestApps/GitHub-API. Thanks!", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Okay", style: .cancel) { (action:UIAlertAction) in
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            self.spinner.stopAnimating()
            self.currentlyFetchingCommits = false;
            self.refreshControl.endRefreshing()
        })
    }

}

extension LatestCommitsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commitViewModelArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CommitTableViewCell
        cell.bindWithViewModel(commitViewModel:self.commitViewModelArray[indexPath.row])
        return cell;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  "InhoHwangTestApps/GitHub-API"
    }
    
}
