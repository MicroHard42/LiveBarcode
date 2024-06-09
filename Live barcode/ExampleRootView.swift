//
//  ExampleRootView.swift
//  Live barcode
//
//  Created by Adam Kuhnel on 6/8/24.
//

import SwiftUI

struct ExampleRootView: View {
    @State var isShowing: Bool = false
    @State private var scannedData: String = ""
    var body: some View {
        TextField("Enter or Scan Data", text: $scannedData)
        Button(action: {
            isShowing = true
        }, label: {
            Text("Begin Scan")
        })
        
            .sheet(isPresented: $isShowing, content: {
                ContentView(scannedData: $scannedData)
            })
    }
}
