//
//  PageModel.swift
//  Pinch&Zoom
//
//  Created by Kosei Ban on 2022-09-07.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page {
    var thumnailName: String{
        return "thumb-" + imageName
    }
}
