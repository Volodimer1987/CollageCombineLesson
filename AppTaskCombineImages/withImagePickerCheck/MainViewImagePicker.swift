import Combine
import SwiftUI
import PhotosUI

struct MainViewImagePicker:View {
    
    @State private var showImagePicker:Bool = false
    @State private var selectedImageFromPicker:UIImage?
    @State private var photoPickerItem:PhotosPickerItem?
    
    var body: some View {
        VStack {
            HStack {
                PhotosPicker(selection:$photoPickerItem,matching: .images) {
                    Image(uiImage: selectedImageFromPicker ?? UIImage(resource: .image7))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:100,height: 100)
                            .border(.red, width: 4)
                            .clipShape(Circle())

                           
                }
                Spacer()
            }
            .padding([.leading,.top],10)
            Spacer()

        }
        .onChange(of: photoPickerItem) { _, _ in
            Task {
                if let photoPickerItem,let data = try? await photoPickerItem.loadTransferable(type:Data.self) {
                    if let image  = UIImage(data: data) {
                        selectedImageFromPicker = image
                    }
                }
            }
        }
    }
}


#Preview {
    MainViewImagePicker()
}

