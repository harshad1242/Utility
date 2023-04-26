//
//  ContentView.swift
//  PracticleSession
//
//  Created by PSH-LP-C02G37NYQ6L4 on 26/04/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var dataObj = ContentData()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }.onAppear(){
            dataObj.getAPICalled()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
