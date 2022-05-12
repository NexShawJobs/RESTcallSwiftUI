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
                let (data, _) = try await URLSession.shared.data(from: URL(string:"https://qni31qs1i7.execute-api.us-east-1.amazonaws.com/pingPongStage/pingpongresource")!)
                let decodedResponse = try? JSONDecoder().decode(SimpleText.self, from: data)
                simpleText = decodedResponse?.body ?? "_"
                statusCode = "\(decodedResponse?.statusCode ?? 0)"
            }
        } label: {
            Text("Simple Text")
        }
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
