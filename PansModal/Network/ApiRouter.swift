//
//  ApiRouter.swift
//  Jenkins
//
//  Created by Serkan Mehmet Malagiç on 19.10.2021.
//

import Foundation
import Alamofire

class AuthManager {
    
    static var loggedIn = false
    
    static func authKey() -> String {
        return "Bearer 201030400"
    }
}


enum APIRouter: URLRequestConvertible {
    
    case getTodoLists
    case getPosts
    case addToDo(title: String, description: String)
    case getPost(id: String)
    case getPostsComments(id : String)
    case getUsers
    case getAlbums
    case getTodos
    case getTodo(id:String)
    
    var method: HTTPMethod {
        switch self {
        case .getTodoLists:
            return .get
        case .getPosts:
            return .get
        case .getPost(_):
            return .get
        case .getPostsComments(_):
            return .get
        case .addToDo(_, _):
            return .post
        case .getUsers:
            return .get
        case .getAlbums:
            return .get
        case .getTodos:
            return .get
        case .getTodo(_):
            return .get
        }
    
}

var path: String {
    switch self {
    case .getTodoLists:
        return "list.php"
    case .getPosts:
        return "posts"
    case .getPost(let id):
        return "posts/\(id)"
    case .getPostsComments(let id):
        return "posts/\(id)/comments"
    case .addToDo(_, _):
        return "add.php"
    case .getUsers:
        return "users"
    case .getAlbums:
        return "albums"
    case .getTodos:
        return "todos"
    case .getTodo(let id):
        return "todos\(id)"
    }
}

var parameters: Parameters? {
    switch self {
    case .getTodoLists:
        return nil
    case .getPosts:
        return nil
    case .getPost:
        return nil
    case .getPostsComments:
        return nil
    case .addToDo(let title, let description):
        return ["title": title, "desc": description]
    case .getUsers:
        return nil
    case .getAlbums:
        return nil
    case .getTodos:
        return nil
    case .getTodo:
        return nil
    }
}

// this is for authentication, allow all, and maybe disable for some
var AuthRequired: Bool {
    switch self {
    case .getTodoLists:
        return false
    case .getPosts:
        return false
    case .getPost:
        return false
    case .getPostsComments:
        return false
    case .getUsers:
        return false
    case .getAlbums:
        return false
    case .getTodos:
        return false
    case .getTodo:
        return false
    default:
        return true
    }
}
// encoding, either URL (normal url query) or a JSON body..
var encoding: ParameterEncoding {
    switch self {
    case .getTodoLists:
        return JSONEncoding.default
    case .getPosts:
        return JSONEncoding.default
    case .getPost:
        return JSONEncoding.default
    case .getPostsComments:
        return JSONEncoding.default
    case .getUsers:
        return JSONEncoding.default
    case .getAlbums:
        return JSONEncoding.default
    case .getTodos:
        return JSONEncoding.default
    case .getTodo:
        return JSONEncoding.default
    default:
        return URLEncoding.default
        
    }
}


func asURLRequest() throws -> URLRequest {
    let url = try Constants.baseURL.asURL().appendingPathComponent(path)
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    
    // Common Headers
    request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
    
    request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
    
    if(AuthRequired){
        if(AuthManager.loggedIn) {
            request.setValue(AuthManager.authKey(), forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        }
    }
    
    if let parameters = parameters {
        return try encoding.encode(request, with: parameters)
        
    }
    
    return request
}


}
