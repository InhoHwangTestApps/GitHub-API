//
//  Commit.swift
//  GitHub API
//
//  Created by Inho Hwang on 2021/2/22.
//

import UIKit

struct Author: Decodable {
  let name: String
}

struct Commit: Decodable {
  let message: String
  let author: Author
}

struct CommitOverview: Decodable {
  let sha: String
  let commit: Commit
}

class CommitViewModel: NSObject {
    let authorName: String;
    let commitMessage: String;
    let commitHash: String;
    
    init(commitHash:String, authorName:String, commitMessage:String) {
        self.authorName = authorName;
        self.commitHash = commitHash;
        self.commitMessage = commitMessage;
    }
    override init() {
        self.authorName = "Unknown";
        self.commitHash = ".";
        self.commitMessage = "";
    }
}

class GitHubAPIDecoder {
    static func getListOfCommmitViewModels(gitHubResponseOfListOfCommits:Any?) -> [CommitViewModel] {
        var commits = [CommitViewModel]();
        if let listOfCommits = gitHubResponseOfListOfCommits as? NSArray {
            for commit in listOfCommits {
                
                var commitObject:CommitViewModel? = nil
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: commit, options: .prettyPrinted) {
                    if let commitOverview = try? JSONDecoder().decode(CommitOverview.self, from: jsonData) {
                        commitObject = CommitViewModel.init(commitHash: commitOverview.sha, authorName: commitOverview.commit.author.name, commitMessage: commitOverview.commit.message)
                    }
                }
                
                // If commit cannot be parsed due to breaking GitHub API changes, at least let the user know there is a commit there.
                commits.append(commitObject != nil ? commitObject! : CommitViewModel.init())
            }
        }
        return commits;
    }
}
