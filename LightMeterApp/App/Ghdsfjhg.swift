import SwiftUI
import OneSignalFramework

struct Ghdsfjhg: View {
 
     
    @ObservedObject var sdfgfgiujhsgf: Phsdgcf = Phsdgcf()
    @State var nfsduagiygsdf:  String = "hsssdfg"
    @AppStorage("mmbnfsduhfg") var mmbnfsduhfg: Bool = true
    @AppStorage("powegsduf") var powegsduf: String = "bwdf"
     var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            if nfsduagiygsdf == "wrrewgegfvdfs" || nfsduagiygsdf == "bbsdbdbdf" {
                if self.powegsduf == "meter" || powegsduf == "tttyytykgsydjhf" {
               
                    if #available(iOS 15.0, *) {
                        MainView()
                        
                            .onAppear{
                                powegsduf = "tttyytykgsydjhf"
                                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                                UINavigationController.attemptRotationToDeviceOrientation()
                            }
                    } else {
                        // Fallback on earlier versions
                    }
                    
                } else {
                    Rtjgsdfjhgds(urehgdf: sdfgfgiujhsgf)
                }
            }
            
        }.onAppear {
            
            OneSignal.Notifications.requestPermission({ accepted in
                if accepted {
                    nfsduagiygsdf = "wrrewgegfvdfs"
                } else {
                    nfsduagiygsdf = "bbsdbdbdf"
                }
            })
        if mmbnfsduhfg {
 
            if let url = URL(string: "https://conversationsweep.store/SpectrumSense/SpectrumSense.json") {
                URLSession.shared.dataTask(with: url) { wueyqgfsdh, response, error in
                     
                    if let aesdvsd = wueyqgfsdh {
                        if let avevdsv = try? JSONSerialization.jsonObject(with: aesdvsd, options: []) as? [String: Any] {
                            
                          
                            
                            if let tywequfghjsdbf = avevdsv["jyewrhsgdfsdfsg"] as? String {
                                
                                
                                DispatchQueue.main.async {
                                    
                                    self.powegsduf = tywequfghjsdbf
                                    
                                  
                                    
                                    mmbnfsduhfg = false
                                }
                            }
                        }
                    } else {
                        self.powegsduf = "tttyytykgsydjhf"
                    }
                }.resume()
            }
        }
    }
    }
}

 
