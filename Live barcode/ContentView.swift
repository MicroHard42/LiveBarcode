//
//  ContentView.swift
//  Live barcode
//
//  Created by Adam Kuhnel on 6/8/24.
//

import SwiftUI
import SwiftData
import VisionKit

struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode
    
    
    @EnvironmentObject var vm: AppViewModel
    
    @Binding var scannedData: String
    @State private var isShowing: Bool = false

    
    

    var body: some View {
        
        VStack{
                        
            switch vm.dataScannerAccessStatus {
            case .notDetermined:
                Text("Requesting Camera access...")
            case .cameraAccessNotGranted:
                Text("Pklease provide Camera access in settings")
            case .cameraNotAvailable:
                Text("Device does not have Camera Available")
            case .scannerAvailable:
                mainView
            case .scannerNotAvailable:
                Text("Your device does not support scanning for this app")
            }
        }
        
        
    }
    
    
    private var mainView: some View {
        VStack{
            
            DataScannerView(scannedData: $scannedData, recognizedItems: $vm.recognizedItems, recognizedDataType: vm.recognizedDataType, recognizesMultipleItems: vm.recognizesMultipeItems)
                .background { Color.gray.opacity(0.3)}
                .ignoresSafeArea()
                .id(vm.dataScannerViewID)
            VStack{
                headerView
                ScrollView{
                    LazyVStack(alignment: .leading, spacing: 16){
                        ForEach(vm.recognizedItems){item in
                            Group{
                                switch item {
                                case .barcode(let barcode):
                                    Text(barcode.payloadStringValue ?? "Unknown Barcode Value")
                                case .text(let text):
                                    Text(text.transcript)
                                @unknown default:
                                    Text("UnKnown")
                                    
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .presentationCornerRadius(8.0)
                            .onTapGesture {
                                handleTap(for: item)
                            }
                        
                        }
                    }
                    .padding()
                }
            }
        }.onChange(of: vm.scanType, { oldValue, newValue in
            vm.recognizedItems = []
        })
        .onChange(of: vm.textContentType, { oldValue, newValue in
            vm.recognizedItems = []
        })
        .onChange(of: vm.recognizesMultipeItems, { oldValue, newValue in
            vm.recognizedItems = []
        })
        
        
    }
    
    private var headerView: some View{
        VStack{
            HStack{
                Picker("Scan Type", selection: $vm.scanType){
                    Text("Barcode").tag(ScanType.barcode)
                    Text("Text").tag(ScanType.text)
                }.pickerStyle(.segmented)
                
                Toggle("Scan multiple", isOn: $vm.recognizesMultipeItems)
            }.padding(.top)
            
            
            Text(vm.headerText).padding(.top)
        }
        .padding(.horizontal)
    }

    private func handleTap(for item: RecognizedItem) {
            switch item {
            case .barcode(let barcode):
                print("Tapped barcode: \(barcode.payloadStringValue ?? "Unknown Barcode Value")")
                scannedData = barcode.payloadStringValue ?? ""
                presentationMode.wrappedValue.dismiss()

            case .text(let text):
                print("Tapped text: \(text.transcript)")
                scannedData = text.transcript
                presentationMode.wrappedValue.dismiss()

            @unknown default:
                print("Tapped unknown item")
            }
        }
}
