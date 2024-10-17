import SwiftUI
import Combine
import Foundation
import UIKit


class ViewModel:ObservableObject {
    let imageSaverToPhone = ImageSaver()
    
    @Published var selectedImagesFromSheet = CurrentValueSubject<[ImageAndId],Never>([])
    @Published var countSelectedImagesFromSheet:Int = 0
    @Published var collageReadyImage:UIImage? = nil
    @Published var lastSavedPhotoIdOrError:String? = nil
    
    private var  cancellable:[String:AnyCancellable?] = [:]

    func createSubscription()  {
        cancellable["selectedImagesFromSheet"] =  selectedImagesFromSheet
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .map {  imageS in
                let imagesWithOut = imageS.compactMap { imageName in
                    return UIImage(named: imageName.nameImage)
                }
                return imagesWithOut
            }
            .map {  arrayImages in
                var returnUIMage:UIImage? = UIImage()
                if arrayImages.count == 0 {
                    returnUIMage = nil
                } else if arrayImages.count == 1 {
                    if let image = arrayImages.first {
                        returnUIMage = image
                    } else {
                        returnUIMage = arrayImages.first
                    }
                } else {
                    returnUIMage = UIImage.collage(images: arrayImages, size: CGSize(width: 250, height: 250))
                }
                return returnUIMage
            }
            .assign(to: \.collageReadyImage, on: self)
    }
    
    func saveImageFromImageSever() {
        guard let image = collageReadyImage else { return }
        imageSaverToPhone.writeToPhotoAlbum(image: image)
    }
    
    func cancelSubscription(nameOfSubscription:String) {
        cancellable[nameOfSubscription] = nil
    }
   
    func createSubscriptionOnSavedImage() {
        guard let image = collageReadyImage else { return }
        
        cancellable["return future"] =  ImageSaver.isSavedImageAndReturnFuture(image: image)
            .sink { [unowned self] complitionBack in
                if case .failure(let error) = complitionBack {
                    lastSavedPhotoIdOrError = error.localizedDescription
                }
            } receiveValue: { [unowned self] backValue in
                lastSavedPhotoIdOrError = "Saved photo with id \(backValue)"
            }
    }
    
    func clearMessagesAfterTrySaveImage() {
        lastSavedPhotoIdOrError = nil
    }
    
   
}

extension UIImage {

  static func collage(images: [UIImage], size: CGSize) -> UIImage {
    let rows = images.count < 3 ? 1 : 2
    let columns = Int(round(Double(images.count) / Double(rows)))
    let tileSize = CGSize(width: round(size.width / CGFloat(columns)),
                          height: round(size.height / CGFloat(rows)))

    UIGraphicsBeginImageContextWithOptions(size, true, 0)
    UIColor.white.setFill()
    UIRectFill(CGRect(origin: .zero, size: size))

    for (index, image) in images.enumerated() {
      image.scaled(tileSize).draw(at: CGPoint(
        x: CGFloat(index % columns) * tileSize.width,
        y: CGFloat(index / columns) * tileSize.height
      ))
    }
      let image = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         return image ?? UIImage()
    }

    func scaled(_ newSize: CGSize) -> UIImage {
        guard size != newSize else {
          return self
        }

        let ratio = max(newSize.width / size.width, newSize.height / size.height)
        let width = size.width * ratio
        let height = size.height * ratio

        let scaledRect = CGRect(
          x: (newSize.width - width) / 2.0,
          y: (newSize.height - height) / 2.0,
          width: width, height: height)

        UIGraphicsBeginImageContextWithOptions(scaledRect.size, false, 0.0);
        defer { UIGraphicsEndImageContext() }

        draw(in: scaledRect)
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
      }
    }
