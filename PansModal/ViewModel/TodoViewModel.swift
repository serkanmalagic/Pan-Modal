//
//  TodoViewModel.swift
//  MVVM
//
//  Created by Serkan Mehmet Malagiç on 4.01.2022.
//

import Foundation
import UIKit
import Alamofire
import EasyBinding

struct TodoViewModel {
    
    var todos: Observable<[Todo]> = Observable([])

    var isLoading = Var(true)
    let title = Var("The New App")
    let exampleImage = Var(UIImage(named: "example1"))
    let backgroundColor = Var(UIColor.systemPink)

    /**
     Example method to change the view model values and see the real time changes in the screen.
     */
    mutating func updateViewModel() {
        
        title.value = Lorem.sentences(1)
        exampleImage.value = UIImage(named: "example\(isLoading.value ? "1" : "2")")
        backgroundColor.value = UIColor.random
        
    }
    
    func fetchData (vc : UIViewController) {
                
        NetworkClient.performRequest(vc: vc, object: [Todo].self, router: APIRouter.getTodos, success : { result in
            todos.value = result
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func getTodosCount () -> Int? {
        return todos.value?.count ?? 0
    }
    
    mutating func startIndicator () {
        isLoading.value = true
    }
    
    mutating func endIndicator () {
        isLoading.value = false
    }
}


