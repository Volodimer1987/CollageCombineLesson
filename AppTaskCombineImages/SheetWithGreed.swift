import Combine
import SwiftUI

struct SheetWithGreed:View {
    @Environment(\.dismiss) private var dismiss
    private let colomns:[GridItem] = [
        GridItem(.fixed(100)),
        GridItem(.fixed(100)),
        GridItem(.fixed(100)),
    ]
    var body: some View {
        NavigationView {
            VStack {
                photosUpper
                
                LazyVGrid(columns:colomns,spacing:19) {
                    ForEach(imagesNames,id: \.self) { imageName in
                        imageToGrig(imageName: imageName)
                    }
                }
                .frame(maxHeight:.infinity,alignment: .top)
                .toolbar {
                    ToolbarItem( placement: .topBarTrailing) {
                        Button {
                            dismiss.callAsFunction()
                        } label: {
                            Text("Close").fontWeight(.bold)
                        }
                        
                    }
                }
            }
        }
    }
}

#Preview {
    SheetWithGreed()
}

extension SheetWithGreed {
    var imagesNames:[String] {[
        "image 1","image 2","image 3","image 4",
        "image 5" , "image 6" , "image 7"
    ]}
    
    @ViewBuilder
    func imageToGrig(imageName:String)  -> some View {
            ImageAndId(nameImage: imageName)
    }
}

fileprivate var photosUpper:some View {
    HStack {
        Text("Photos")
            .font(.system(size: 28))
            .fontWeight(.bold)
            .foregroundStyle(.black)
        Spacer()
    }
    .padding(.horizontal,15)
    .padding(.top,20)
}
