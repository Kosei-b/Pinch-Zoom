//
//  ControlImageView.swift
//  Pinch&Zoom
//
//  Created by Kosei Ban on 2022-09-06.
//

import SwiftUI

struct ControlImageView: View {
    
    let icon: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 36))
    }
}

struct ControlImageView_Previews: PreviewProvider {
    static var previews: some View {
        ControlImageView(icon: "minus.magnifyingglass")
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
            .padding()
    }
}
