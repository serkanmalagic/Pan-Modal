//
//  Observable.swift
//  MVVM-Example
//
//  Created by Serkan Mehmet Malagiç on 7.11.2021.
//

import Foundation

class Observable<T> {
    
    var value : T? {
        didSet{
            listener?(value)
        }
    }
    
    init(_ value : T?){
        self.value = value
    }
    private var listener : ((T?) -> Void)?
    
    func bind(_ listener: ( @escaping (T?) -> Void)){
        listener(value)
        self.listener = listener
    }
}
