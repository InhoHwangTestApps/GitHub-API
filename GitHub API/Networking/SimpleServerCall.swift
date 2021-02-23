//
//  AFNetworkingWrapper.swift
//  GitHub API
//
//  Created by Inho Hwang on 2021/2/22.
//

import UIKit
import AFNetworking

class SimpleServerCall {
    private let gitHubAPIBaseUrl = "https://api.github.com/"
    private let gitHubAPIRecommendedHeaders = ["accept":"application/vnd.github.v3+json"]

    static let shared = SimpleServerCall()
    
    private init() {
    }
    
    func simpleServerCallGET(fullUrlString: String, parameters: Dictionary<String, Any>?, headers: [String : String]?, tryAgainOnceIfFailed: Bool, completionHandler: @escaping (Bool, Any?, Error?) -> ()) {
        let manager = AFHTTPSessionManager.init()
        manager.requestSerializer.timeoutInterval = 10;
        manager.get(fullUrlString, parameters: parameters, headers: headers, progress: nil) { (sessionDataTask, response) in
            DispatchQueue.main.async {
                completionHandler(true, response, nil)
            }
        } failure: { (task, error) in
            if (tryAgainOnceIfFailed) {
                self.simpleServerCallGET(fullUrlString: fullUrlString, parameters: parameters, headers: headers, tryAgainOnceIfFailed: false, completionHandler: completionHandler)
            } else {
                DispatchQueue.main.async {
                    completionHandler(true, nil, error)
                }
            }
        }
    }
    
    
    func gitHubAPIGET(endPartOfUrlWithoutSlashInFront: String, parameters: Dictionary<String, Any>?, tryAgainOnceIfFailed: Bool, completionHandler: @escaping (Bool, Any?, Error?) -> ()) {
        simpleServerCallGET(fullUrlString: gitHubAPIBaseUrl + endPartOfUrlWithoutSlashInFront, parameters: parameters, headers: gitHubAPIRecommendedHeaders, tryAgainOnceIfFailed: true, completionHandler: completionHandler)
    }
    
}
