//
//  ServiceManager.swift
//  UpgradAssignment
//
//  Created by AiTechnology on 10/5/19.
//  Copyright © 2019 vinit.somani. All rights reserved.
//

import UIKit

class ServiceManager: NSObject {
    
    class func processDataFromServer<T:Codable>(service: Service,model:T.Type,responseProcessingBlock: @escaping (T?,Error?) -> () )
    {
        let request = RequestManager.sharedInstance.createRequest(service: service)
        SessionManager.sharedInstance.processRequest(request: request) { (data, error) in
            ServiceManager.processDataModalFromResponseData(model:T.self,data: data,error: error,responseProcessingBlock: responseProcessingBlock)
            
        }
    }
    
    private class func processDataModalFromResponseData<T:Codable>(model:T.Type, data:Data?,error:Error?,responseProcessingBlock: @escaping (T?,Error?) -> ())
    {
        if let responseError = error
        {
            responseProcessingBlock(nil,responseError)
            return
        }
        
        if let responseData = data
        {
            do{
                let jsonDecoder = JSONDecoder.init()
                let parsingModel = try jsonDecoder.decode(model.self, from: responseData)
                responseProcessingBlock(parsingModel, nil)
            }
            catch(let parsingError)
            {
                responseProcessingBlock(nil,parsingError)
            }
        }
    }
    
}
