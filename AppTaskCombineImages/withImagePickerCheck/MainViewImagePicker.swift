import Combine
import SwiftUI
import PhotosUI

struct MainViewImagePicker:View {
    
    @State private var showImagePicker:Bool = false
    @State private var selectedImageFromPicker:UIImage?
    @State private var photoPickerItem:PhotosPickerItem?
    @State private var showAlertAccesToPhoto:Bool = false
    @State private var textForIfProhibitedAcces:String?
    
    @State private var subscriptions:[String:AnyCancellable?] = [:]
    
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
        .alert(isPresented:$showAlertAccesToPhoto) {
            Alert(title:Text("\(textForIfProhibitedAcces ?? " ")"),
                  dismissButton: .cancel()
            )
        }
        .onAppear {
            
        }
        .onChange(of: photoPickerItem) { _, _ in
            Task {
                if let photoPickerItem,let data = try? await photoPickerItem.loadTransferable(type:Data.self) {
                    if let image  = UIImage(data: data) {
                        selectedImageFromPicker = image
                    }
                } else {
                    subscriptions["acces to photo"] = PHPhotoLibrary
                        .isAuthorizedFuture
                        .sink(receiveCompletion: { complition in
                            switch complition {
                            case .finished:print("yes we get access to photo")
                            case .failure(let phpError):
                                showAlertAccesToPhoto.toggle()
                                switch phpError {
                                case .denied:textForIfProhibitedAcces = phpError.localizedDescription
                                case .limited: textForIfProhibitedAcces = phpError.localizedDescription
                                case .notDetermined:textForIfProhibitedAcces = phpError.localizedDescription
                                case .restricted:textForIfProhibitedAcces = phpError.localizedDescription
                                }
                            }
                        }, receiveValue: { value in
                            showAlertAccesToPhoto = value
                        })
                }
            }
        }
    }
}


#Preview {
    MainViewImagePicker()
}

 extension PHPhotoLibrary {
    
     enum ErrorAuthorizacionPhoto:Error {
         case notDetermined
         case restricted
         case denied
         case limited
         
         private var status:String {
             return "Status to photo library"
         }
         
         var localizedDescription:String {
             switch self {
             case .denied:return status + " " + "dinied"
             case .limited:return status + " " + "limited"
             case .restricted: return status + " " + "restricted"
             case .notDetermined:return status + " " + "not Determined"
             }
         }
     }
            static var isAuthorizedFuture: Future<Bool,PHPhotoLibrary.ErrorAuthorizacionPhoto> {
                return Future { promise in
                    let statusOfAuturisation = PHPhotoLibrary.authorizationStatus(for: .readWrite)
                    switch statusOfAuturisation {
                    case .authorized:promise(.success(true))
                    case .limited : promise(.failure(.limited))
                    case .denied  :promise(.failure(.denied))
                    case .restricted:promise(.failure(.restricted))
                    case .notDetermined:promise(.failure(.notDetermined))
                    default: break
                    }
                }
        }
}

extension MainViewImagePicker {
    
    
}
