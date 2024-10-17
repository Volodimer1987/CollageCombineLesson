import SwiftUI
import Combine
import Photos

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    }
    
    static func isSavedImageAndReturnFuture(image:UIImage) -> Future<String,SavedImageError> {
        return Future { promise in
            do {
                try PHPhotoLibrary.shared().performChangesAndWait{
                    let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    guard let savedAssetId = request.placeholderForCreatedAsset?.localIdentifier else {
                        return promise(.failure(SavedImageError.photoNotSaved
))                    }
                    promise(.success(savedAssetId))
                }
            } catch  {
                promise(.failure(.photoNotSaved))
            }
        }
    }
    
    deinit {
        print("class was deinit ")
    }
}

extension ImageSaver {
    enum SavedImageError:Error {
        case photoNotSaved
        
        var localizedDescription:String {
            switch self {
            case .photoNotSaved:"Error:Can not save image"
            }
        }
        
    }
}
