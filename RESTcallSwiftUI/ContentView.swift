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
                
                let json1 = """
                {
                    "name": "Networking with URLSession",
                    "language": "Swift",
                    "version": 5.2
                }
                """
                let json2 = """
                {
                    "clientText": "clientText",
                    "timeStamp": "timeStamp"
                }
                """

                
                guard let uploadUrl = URL(string: "http://127.0.0.1:8080/upload") else {
                    fatalError()
                }
                guard let uploadUr2 = URL(string: "http://127.0.0.1:8080/echo") else {
                    fatalError()
                }
                var request1 = URLRequest(url: uploadUrl)
                let jsonData1 = json1.data(using: .utf8)
                request1.httpMethod = "Post"
                request1.setValue("application/json", forHTTPHeaderField: "Content-type")
                let urlSession1 = URLSession(configuration: .default)
                let task1 = urlSession1.uploadTask(with: request1, from: jsonData1) {d, r, e in
                    print(r ?? "no response")
                    
                }
                task1.resume()
                
                request1.url = uploadUr2
                let jsonData2 = json2.data(using: .utf8)
                let task2 = urlSession1.uploadTask(with: request1, from: jsonData2) {d, r, e in
                    print(r ?? "no response")
                    let jsonResponse = String(decoding: d!, as: UTF8.self)
                    print(jsonResponse)
                }
                task2.resume()
                        
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
