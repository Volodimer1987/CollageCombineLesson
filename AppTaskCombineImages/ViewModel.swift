import SwiftUI
import Combine


class ViewModel:ObservableObject {
    @Published var selectedImagesFromSheet = CurrentValueSubject<[Image],Never>([])
    @Published var countSelectedImagesFromSheet:Int = 0
    @Published var collageReadyImage:Image?
}
