//
//  ContentView.swift
//  AppTaskCombineImages
//
//  Created by vladimir gennadievich on 10/7/24.
//

import SwiftUI

struct MainViewApp: View {
    
    @State private var vm:ViewModel = ViewModel()
    @State private var showSheet:Bool = false
    
    var body: some View {
        NavigationView(content: {
            VStack(alignment:.center) {
                if let collageImage = vm.collageReadyImage {
                    collageImage
                        .ifHaveCollage()
                } else {
                    Image("checkImage")
                        .ifHaveCollage()
                }
                
                VStack(spacing:20) {
                    Button {
                        print("add image")
                    } label: {
                        Text("Clear")
                            .foregroundStyle(.blue)
                            .frame(maxWidth:.infinity,maxHeight: 40)
                            .background(Color.gray.opacity(0.2),in: RoundedRectangle(cornerRadius: 12))
                        
                    }
                    
                    Button {
                        print("save image")
                    } label: {
                        Text("Save")
                            .foregroundStyle(.white)
                            .frame(maxWidth:.infinity,maxHeight: 40)
                            .background(Color.blue,in: RoundedRectangle(cornerRadius: 12))
                    }
                    .frame(maxWidth:.infinity,maxHeight: 40)
                    
                }
                .fontWeight(.bold)
                .font(.headline)
                .padding(.horizontal,10)
                
            }
            
            .overlay(alignment: .top) {
                HStack(spacing:100) {
                    Text("\(vm.countSelectedImagesFromSheet) photos")
                        .fontWeight(.bold)
                        .font(.title)
                    
                    Spacer()
                    
                    Button {
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                    } .frame(width: 25,height: 25)
                    
                    
                }
                .padding(.horizontal,10)
                .offset(y:-40)
            }
            .sheet(isPresented: $showSheet) {
                SheetWithGreed()
            }
        })
    }
}




#Preview {
    MainViewApp()
}
