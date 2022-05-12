//
//  ContentView.swift
//  RESTcallSwiftUI
//
//  Created by NebSha on 5/12/22.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State private var simpleText: String = ""
    @State private var statusCode: String = ""
        
    var body: some View {
        Text(simpleText)
        Text(statusCode)
        Button {
            Task {
                
                let json = "{ \"ping\" : \"nex\" }"
                let url :URL = URL(string: "https://qni31qs1i7.execute-api.us-east-1.amazonaws.com/pingPongStage/pingpongresource")!
                var request = URLRequest(url: url)
                request.httpMethod = "Post"
                request.httpBody = json.data(using: .utf8)
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: request) {
                    (data, response, error) in
                    
                    if let data = data {
                        if let postResponse = String(data: data, encoding: .utf8){
                            print(postResponse)
                            simpleText = postResponse
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                simpleText = ""
                            }
                        }
                    }
                }
                task.resume()

                
                let (data, _) = try await URLSession.shared.data(from: URL(string:"https://qni31qs1i7.execute-api.us-east-1.amazonaws.com/pingPongStage/pingpongresource")!)
                let decodedResponse = try? JSONDecoder().decode(SimpleText.self, from: data)
                //simpleText = decodedResponse?.body ?? "_"
                statusCode = "\(decodedResponse?.statusCode ?? 0)"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    statusCode = ""
                }
            }
        } label: {
            Text("Simple Text")
        }
        Text ("Time Taken:")
        

        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct SimpleText: Codable {
    let body: String
    let statusCode: Int
}
