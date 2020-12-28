//
//  DescriptionViewController.swift
//  NASAAPI
//
//  Created by Егор Горских on 20.12.2020.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 17.0)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.backgroundColor = .lightGray
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            textView.heightAnchor.constraint(equalTo: textView.widthAnchor, multiplier: 2)
        ])
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadDescription()
        
        view.backgroundColor = .lightGray
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture))
        swipeRecognizer.direction = .left
        view.addGestureRecognizer(swipeRecognizer)
    }
    
    func uploadDescription() {
        let networkingAPOTD = NetworkingAPOTD()
        networkingAPOTD.fetchAstronomyPicture { (modelAPOTD) in
            
            if let modelAPOTD = modelAPOTD {
                self.updateDescription(with: modelAPOTD)
            }
        }
    }
    
    func updateDescription(with modelAPOTD: ModelAPOTD) {
        let networkingAPOTD = NetworkingAPOTD()
        networkingAPOTD.fetchUrlData(with: modelAPOTD.url) { (data) in
            guard let _ = data
            else {
                return
            }
            
            DispatchQueue.main.async {
                self.textView.text = modelAPOTD.description
            }
        }
    }
    
    @objc func handleSwipeGesture(sender: UISwipeGestureRecognizer) {
        let transition = CATransition()
        transition.duration = 0.6
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        view.layer.add(transition, forKey: "rightToLeftTransition")
        dismiss(animated: true, completion: nil)
    }
}


