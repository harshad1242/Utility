
enum User : String {
    case validateUser
    case SaveUserDevice
}
enum ApiMethod :String{
    case POST
    case GET
}

typealias apiCompletionV2 = (_ connected:Bool?) -> Void
typealias passwordEncryptresponseAPI = (_ passValue:String?) -> Void
typealias responseSwaggerAPI = (_ connected:Bool?,_ data:Data?,_ response:URLResponse?,_ error : Error?) -> Void
typealias responseAPI = (_ isSucess:Bool?,_ data:Data?,_ error : Error?) -> Void


import SwiftyJSON
class DMApiManager: NSObject{

    static let sharedInstance = DMApiManager()
    var baseURLSwaggerAPI = ""
    var folderName = ""
    let sessionDefault = URLSession(configuration:URLSessionConfiguration.default)

    func requestSwagerURL(type:String,method:String,param:[String:AnyObject],withCompletionHandler:(_ url:URL?,_ header:Data?,_ err : Error?) -> Void){
        if type != "SaveProfileImage"{
            print("type = \(type) param = \(param)")
        }
        

        if type == "SaveProfileImage"{
            self.folderName = "DocManAPI/"
        }else{
            self.folderName = ""
        }
        var url = URL(string:baseDocManSwaggerAPI+folderName+type)

        if method == ApiMethod.POST.rawValue && type == "SaveCashPosition"{

            for paramItem in param{

                url = url!.appending(paramItem.key, value: paramItem.value as? String)

            }
           // print(url.debugDescription)
            withCompletionHandler(url,nil,nil)

        }else if method == ApiMethod.POST.rawValue && type == "SaveComment"{

            for paramItem in param{

                url = url!.appending(paramItem.key, value: paramItem.value as? String)
                // url = url!.appending(paramItem.key, value:(paramItem.value as! String))
            }
           // print(url.debugDescription)
            withCompletionHandler(url,nil,nil)
        }else{

            if method == ApiMethod.POST.rawValue{

                guard let jsonData = try? JSONSerialization.data(withJSONObject: param) else {
                    return
                }
               // print(url.debugDescription)
                withCompletionHandler(url,jsonData,nil)
            }else{
                for paramItem in param{

                    url = url!.appending(paramItem.key, value: paramItem.value as? String)
                    // url = url!.appending(paramItem.key, value:(paramItem.value as! String))
                }
               // print(url.debugDescription)
                withCompletionHandler(url,nil,nil)
            }

        }
    }
    func requestVendorSwagerURLV2(type:String,method:String,param:[String:AnyObject],withCompletionHandler:(_ url:URL?,_ header:Data?,_ err : Error?) -> Void){
        print("type = \(type) param = \(param)")

        
        self.folderName = ""
        var url = URL(string:VendorbasePathV2+folderName+type)

        if method == ApiMethod.POST.rawValue{

            guard let jsonData = try? JSONSerialization.data(withJSONObject: param) else {
                return
            }
            print(url.debugDescription)
            withCompletionHandler(url,jsonData,nil)
        }else{
            for paramItem in param{

                url = url!.appending(paramItem.key, value: paramItem.value as? String)
                // url = url!.appending(paramItem.key, value:(paramItem.value as! String))
            }
            print(url.debugDescription)
            withCompletionHandler(url,nil,nil)
        }
    }
    func requestVendorSwagerURL(type:String,method:String,param:[String:AnyObject],withCompletionHandler:(_ url:URL?,_ header:Data?,_ err : Error?) -> Void){
        print("type = \(type) param = \(param)")

        if type == "SaveProfileImage"{
            self.folderName = "DocManAPI/"
        }else{
            self.folderName = ""
        }
        var url = URL(string:VendorbasePath+folderName+type)

        if method == ApiMethod.POST.rawValue && type == "SaveCashPosition"{

            for paramItem in param{

                url = url!.appending(paramItem.key, value: paramItem.value as? String)

            }
            print(url.debugDescription)
            withCompletionHandler(url,nil,nil)

        }
        else {

            if method == ApiMethod.POST.rawValue{

                guard let jsonData = try? JSONSerialization.data(withJSONObject: param) else {
                    return
                }
                print(url.debugDescription)
                withCompletionHandler(url,jsonData,nil)
            }else{
                for paramItem in param{

                    url = url!.appending(paramItem.key, value: paramItem.value as? String)
                    // url = url!.appending(paramItem.key, value:(paramItem.value as! String))
                }
                print(url.debugDescription)
                withCompletionHandler(url,nil,nil)
            }

        }
    }
    func callSwagerAPI(type:String,method:String,param : [String: AnyObject],responseHandler:@escaping responseSwaggerAPI){
        if Reachability.isConnectedToNetwork(){
            requestSwagerURL(type: type, method: method, param:param){(url,header,requestError) in
                if UIApplication.shared.canOpenURL(url!){
                    var request = URLRequest(url:url!)
                        request.httpMethod = method
                    if method == ApiMethod.POST.rawValue && type == "SaveCashPosition"{

                    }else if method == ApiMethod.POST.rawValue && type == "SaveComment"{

                    }else{

                        if method == ApiMethod.POST.rawValue{
                            request.httpBody = header
                        }
                    }
                    print("Token API = \(userDefaults.string(forKey:swaggerToken) ?? "Empty")")
                    request.setValue(userDefaults.string(forKey:swaggerToken) ?? "", forHTTPHeaderField: "Authorization")
                    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
                    print(url!.absoluteString)

                    let task = sessionDefault.dataTask(with: request, completionHandler: {data, response,sessionError -> Void in
                        responseHandler(true,data,response, sessionError)

                    })

                    task.resume()

                }else {
                    responseHandler(true,nil,nil,requestError)
                }
            }
        }else{
            responseHandler(false,nil,nil,nil)
            print("Internet Connection not Available!")
        }
    }

}
extension URL {

    func appending(_ queryItem: String, value: String?) -> URL {

        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        return urlComponents.url!
    }
}
import Combine
class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

//  var webServiceObj = WebAPIServices()
class WebAPIServices{
    func login_now(username:String, password:String,responseHandler:@escaping responseSwaggerAPI){
        let param = [
            "userName": username.trimmingCharacters(in:.whitespaces),
            "password": password.trimmingCharacters(in:.whitespaces),
        ]
        print("login Param = \(param)")
        DMApiManager.sharedInstance.callSwagerAPI(type: User.validateUser.rawValue, method: ApiMethod.POST.rawValue, param: param as [String : AnyObject]) {(isSucess,data,responseSwagger,err) in
            DispatchQueue.main.async{
                responseHandler(isSucess,data,responseSwagger,err)
            }
        }
    }
    
}
