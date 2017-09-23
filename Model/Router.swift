//Based off of Router in official Alamofire on Github
/*https://github.com/Alamofire/Alamofire*/

import Foundation
import Alamofire

public enum Router: URLRequestConvertible {
    static let baseURLPath = "https://api.github.com"
    static let authenticationToken = "Basic xxx"
    static let githubAcceptStringV3 = "application/vnd.github.v3+json"
    
    case getPullRequests(parameters: Parameters)
    
    var method: HTTPMethod {
        switch self {
        case .getPullRequests:
            return .get

        }
    }
    
    var path: String {
        switch self {
        case .getPullRequests:
            //example "/users/(username)"
            return "/repos/timothypeter/ProCore-Demo"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        
        let url = try Router.baseURLPath.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
            case .getPullRequests(let parameters):
                urlRequest = try URLEncoding.default.encode(urlRequest, with:  parameters)
            print(urlRequest)
            default:
                break
        }
        
        /*
        let url = try Router.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.setValue(Router.authenticationToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = TimeInterval(10 * 1000)
 */
        
        return urlRequest
    }
}
