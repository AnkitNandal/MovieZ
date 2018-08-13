//
//  KSearchOperation.swift
//  Moviez
//
//  Created by Ankit Nandal on 04/08/18.
//  Copyright © 2018 Ankit Nandal. All rights reserved.
//

import UIKit


//Search Operation Api Parameters.
class KSearchOperationParamters: NSObject {
    
    let query:String
    let page:Int
    
    init(query:String, pageNumber:Int) {
        self.query = query
        self.page = pageNumber
    }
}


// Operation that is used to fetch search response.
class KSearchOperation: KServiceOperation {
   
    var searchParams:KSearchOperationParamters?
    
    //Operation Initializer with paramters
    init(searchParameter:KSearchOperationParamters, executeOnService:KService?){
        //Initialize super to use self here
        super.init()
        self.searchParams = searchParameter
        service = executeOnService
        addParameters(searchParameter: searchParameter)
    }
    
    //MARK:- Set Parameters
    func addParameters(searchParameter:KSearchOperationParamters) {
        createRequest()
        addUrlParameters(searchParameter: searchParameter)
    }
    
    func createRequest() {
        guard let endPoint = kNetworkAdapter.getEndPoint(for: kNetworkAdapter.Of.search) else {return}
        request = KRequest(method: .get, endpoint: endPoint)
    }
    
    func addUrlParameters(searchParameter: KSearchOperationParamters) {
        var parameterDict:ParametersDict = ParametersDict()
        parameterDict["query"] = searchParameter.query
        parameterDict["page"] = searchParameter.page
        request?.urlParams = parameterDict
    }
    
    
    //MARK:- Override Parent
    override func parsedResponse(_ response: KResponse!) -> Any? {
        guard let data = response.responseData  else {return nil}
        do {
            let decoder = JSONDecoder()
            let movieData = try decoder.decode(MovieInfo.self, from: data)
            if let searchTerm = self.searchParams?.query {
                KSearchSuggestions.shared().saveSearchSuggestions(for: searchTerm)
            }
            return movieData
        } catch let err {
            print("Err", err)
        }
        return nil
    }
    
}


