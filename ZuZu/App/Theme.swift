import SwiftUI

enum ZuZuTheme {
    static let background = Color(red: 18/255, green: 18/255, blue: 20/255)
    static let card = Color(red: 30/255, green: 30/255, blue: 33/255)
    static let raised = Color(red: 39/255, green: 39/255, blue: 43/255)
    static let amber = Color(red: 233/255, green: 164/255, blue: 61/255)
    static let coral = Color(red: 255/255, green: 105/255, blue: 99/255)
    static let mint = Color(red: 54/255, green: 211/255, blue: 161/255)
    static let blue = Color(red: 93/255, green: 166/255, blue: 249/255)
    static let muted = Color(red: 161/255, green: 161/255, blue: 168/255)
    static let primary = Color(red: 245/255, green: 245/255, blue: 247/255)
}

extension View {
    func zuzuCard(radius: CGFloat = 24) -> some View {
        padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(ZuZuTheme.card, in: RoundedRectangle(cornerRadius: radius))
    }
}
