//
//  NewsTableViewExtension.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 03/04/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import Foundation

extension NewsController {
    
    //MARK: Table View Router Functions
    func structuringTableViewCellWithImage(multimediaArray: [NewsMultimedia?]) -> Bool{
        let unwrappedArray = arrayUnwrapped(arrayInput: multimediaArray)
        let unwrappedArrayCounted = unwrappedArrayCounter(unwrappedArray: unwrappedArray)
        let cellStructureWithoutImage = countedValueIsNil(countedValue: unwrappedArrayCounted)
        return cellStructureWithoutImage
    }
    
    //MARK: Execution Functions
    func wrappedArrayOpenOptional(wrappedArrayOptionalInput: [Any?]?) -> [Any?] {
        guard let arrayWrapped = wrappedArrayOptionalInput else { return [""] }
        return arrayWrapped
    }
    
    func arrayUnwrapped(arrayInput: [Any?]) -> [Any] {
        let arrayUnwrapped = arrayInput.compactMap { $0 }
        return arrayUnwrapped
    }
    
    func unwrappedArrayCounter(unwrappedArray: [Any]) -> Int {
        let arrayCountedValue = unwrappedArray.count
        return arrayCountedValue
    }
    
    func countedValueIsNil (countedValue: Int) -> Bool {
        switch countedValue {
        case 0: return true
        default: return false
        }
    }
}
