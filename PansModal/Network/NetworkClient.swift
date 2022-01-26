//
//  NetworkApiClient.swift
//  Jenkins
//
//  Created by Serkan Mehmet Malagiç on 18.10.2021.
//

import Foundation
import Alamofire
import NVActivityIndicatorView

struct NetworkClient {
    
    typealias onSuccess<T> = ((T) -> ())
    typealias onFailure = ( (_ error: Error) -> ())
    
    // object parameter is added here so the T generic param can infer the type
    // All objects must conform to "Decodable" protocol
    static func performRequest<T>(vc : UIViewController ,object: T.Type, router: APIRouter, success: @escaping onSuccess<T>, failure: @escaping onFailure) where T: Decodable{
        
        let activityView = vc.view.createSpinner()
        vc.view.isUserInteractionEnabled = false
        activityView.startAnimating()
        
        AF.request(router)
            .responseJSON { (response) in
                vc.view.isUserInteractionEnabled = true
                activityView.stopAnimating()
                do {
                    let data = try JSONDecoder().decode(T.self, from: response.data!)
                    success(data)
                } catch let error{
                    let alert = UIAlertController(title: error.localizedDescription, message: "", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil))
                    vc.present(alert, animated: true, completion: nil)
                }
            }
    }
}
