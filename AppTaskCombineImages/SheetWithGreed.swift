import Combine
import SwiftUI

struct SheetWithGreed:View {
    @Environment(\.dismiss) private var dismiss
    @State private var imagesAndId:[ImageAndId] = []
    @EnvironmentObject var viewModel: ViewModel
    
    
    private let colomns:[GridItem] = [
        GridItem(.fixed(100),spacing: 20),
        GridItem(.fixed(100),spacing: 20),
        GridItem(.fixed(100),spacing: 20),
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                photosUpper
                LazyVGrid(columns:colomns,spacing:19) {
                    ForEach(imagesAndId,id: \.id) { id in
                        id
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
        .onAppear {
            viewModel.collageReadyImage = nil
            viewModel.countSelectedImagesFromSheet = 0
        }
        .task(priority: .userInitiated) {
            await imagesAndId = imageToGrig(imageName: imagesNames)
        }
    }
}

#Preview {
    SheetWithGreed().environmentObject(ViewModel())
}

extension SheetWithGreed {
    var imagesNames:[String] {[
        "image 1","image 2","image 3","image 4",
        "image 5" , "image 6" , "image 7"
    ]}
    
    
    func imageToGrig(imageName:[String]) async -> [ImageAndId]{
        var arrayOfImageAndId:[ImageAndId] = []
        for  imageName in imagesNames {
            let image =  ImageAndId(nameImage: imageName)
            arrayOfImageAndId.append(image)
        }
        return arrayOfImageAndId
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

extension SheetWithGreed  {
    func sendSelectedImages() -> Image? {
        var image:Image?
        for value in imagesAndId {
            if value.isSelectedByUser {
                print(value.nameImage + "was tapped")
                image = Image(value.nameImage)
                return  image
            } else {
                continue
            }
        }
        Thread.sleep(forTimeInterval: 1.0)
        return Image("image 7")
    }
}

