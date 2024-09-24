import SwiftUI

class TestViewNew: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        ContentView()
    }
    struct ContentView:View
    {
        var body:some View{
            VStack{
                TopBar()
                
                Spacer()
            }
        }
    }

    struct ContentView_Previews:PreviewProvider{
        static var previews: some View{
            ContentView()
        }
    }

    struct TopBar:View{
        
        var body: some View{
            VStack(spacing: 20){
                HStack{
                    Text("Money Detector").font(.system(size:20)).fontWeight(.semibold).foregroundColor(.red)
                    Spacer()
                    
                    Button(action:{}){Image(systemName:"plus")}
                }
            }.padding().padding(.top,(UIApplication.shared.windows.last?.safeAreaInsets.top)!+10).background(Color.red)
        }
    }
    
}

