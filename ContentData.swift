
import Foundation
class ContentData : ObservableObject {
   // @Published var ButtonTap = false
    
    init() {
       
        print("init")
    }
    deinit {
        
        print("deinit")
    }
    
    
    func getAPICalled(){
        
        print(APPURL.FacebookLogin)
    }
}
