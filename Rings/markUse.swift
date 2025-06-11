//
//  markUse.swift
//  Rings
//
//  Created by Chuck Deerinck on 6/8/25.
//

import Foundation

func markUse(globals: Globals, sectionals:Sectionals, name: String) {
    for (index, _) in sectionals.sectionals.enumerated() {
//        if sectionals.sectionals[index].use != (sectionals.sectionals[index].name == name) {
//            print("Changing", sectionals.sectionals[index].name, name)
//        } else {
//            print("Leaving", sectionals.sectionals[index].name, name)
//        }
        sectionals.sectionals[index].use = (sectionals.sectionals[index].name == name)
        if sectionals.sectionals[index].use {
            globals.sectionalInUse = sectionals.sectionals[index]
        }
    }
}
