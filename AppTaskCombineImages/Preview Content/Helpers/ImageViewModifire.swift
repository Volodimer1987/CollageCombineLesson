import SwiftUI

extension Image  {
    func ifHaveCollage() -> some View  {
            self
                .resizable()
                .scaledToFill()
                .frame(maxWidth:.infinity,maxHeight: 250,alignment: .center)
                .clipShape(RoundedRectangle(
                cornerRadius: 10, style: .continuous) )
                .padding(.all,10)
                .padding(.bottom,15)
   }
}
