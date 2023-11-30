//
//  UIKitWrapper.swift
//  PuraProject
//
//  Created by Jake Gray on 11/29/23.
//

import SwiftUI
import UIKit

struct UIKitWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        guard let navigationController = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController() else {
            return UIViewController()
        }
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}



