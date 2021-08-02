//
//  APODDescriptionViewController.swift
//  NASAAPI
//
//  Created by Егор Горских on 12.01.2021.
//

import UIKit

final class APODDescriptionView: UIView {
    
    lazy var textView: UITextView = {
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 17.0)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        textView.textColor = .white
        
        return textView
    }()
    
}
