//
//  ContentView.swift
//  AppTaskCombineImages
//
//  Created by vladimir gennadievich on 10/7/24.
//

import SwiftUI

struct MainViewApp: View {
    
    @StateObject  var vm:ViewModel = ViewModel()
    @State private var showSheet:Bool = false
    
    var body: some View {
        NavigationView(content: {
            VStack(alignment:.center) {
                if let collageImage = vm.collageReadyImage {
                    Image(uiImage:collageImage)
                        .ifHaveCollage()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth:.infinity,maxHeight: 250,alignment: .center)
                        .clipShape(RoundedRectangle(
                        cornerRadius: 10, style: .continuous) )
                        .padding(.all,10)
                        .padding(.bottom,15)
                }
                
                VStack(spacing:20) {
                    Button {
                withAnimation(.default) {
                        vm.collageReadyImage = nil
                        vm.countSelectedImagesFromSheet = 0
                        vm.selectedImagesFromSheet.send([])
                        }
                    } label: {
                        Text("Clear")
                            .foregroundStyle(.blue)
                            .frame(maxWidth:.infinity,maxHeight: 40)
                            .background(Color.gray.opacity(0.2),in: RoundedRectangle(cornerRadius: 12))
                        
                    }
                    
                    Button {
                        vm.saveImageFromImageSever()
                    } label: {
                        Text("Save")
                            .foregroundStyle(.white)
                            .frame(maxWidth:.infinity,maxHeight: 40)
                            .background(Color.blue,in: RoundedRectangle(cornerRadius: 12))
                    }
                    .frame(maxWidth:.infinity,maxHeight: 40)
                    
                    
                }
                .disabled(vm.selectedImagesFromSheet.value.count == 0)
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
                        vm.createSubscription()
                        showSheet.toggle()

                         if vm.selectedImagesFromSheet.value.count > 0 {
                                 vm.selectedImagesFromSheet.value = []
                          }
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
        .onDisappear {
            vm.cancelSubscription()
        }

        .environmentObject(vm)
    }
} 




#Preview {
    MainViewApp()
}
