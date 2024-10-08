import SwiftUI

struct ImageAndId:View,Identifiable {
    let id = UUID.init().uuidString
    let nameImage:String
    @State private var isSelectedByUser = false
    
    var body: some View {
            Image(nameImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius:10,style:.continuous))
                .frame(width:100,height: 100)
                .overlay(alignment: .topTrailing) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 25,height: 25)
                .foregroundStyle(isSelectedByUser ? .white:.clear)
                .offset(x:-6, y:-8)
            
            
        }
        .onTapGesture {
            withAnimation(.bouncy) {
                isSelectedByUser.toggle()
            }
        }

    }
}

#Preview {
    ImageAndId(nameImage:"image 1")
}
