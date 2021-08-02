//
//  DescriptionViewController.swift
//  NASAAPI
//
//  Created by Егор Горских on 20.12.2020.
//

import UIKit

final class APOTDDescriptionViewController: UIViewController {
    
    let adv = APOTDDescriptionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        
        uploadDescription()
        swipeRecognizer()
        addSubviews()
        setupConstraint()
    }
    
    private func addSubviews() {
        view.addSubview(adv.textView)
    }
    
    private func setupConstraint() {
        
        NSLayoutConstraint.activate([
            adv.textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            adv.textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            adv.textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            adv.textView.heightAnchor.constraint(equalTo: adv.textView.widthAnchor, multiplier: 2)
        ])
    }

    private func uploadDescription() {
    let networkingAPOTD = APOTDNetworking()
    networkingAPOTD.fetchAstronomyPicture { (modelAPOTD) in

        if let modelAPOTD = modelAPOTD {
            self.updateDescription(with: modelAPOTD)
        }
    }
}

    private func updateDescription(with modelAPOTD: APOTDModel) {

    let networkingAPOTD = APOTDNetworking()
    networkingAPOTD.fetchUrlData(with: modelAPOTD.url) { (data) in
        guard let _ = data
        else {
            return
        }
        DispatchQueue.main.async {
            self.adv.textView.text = modelAPOTD.description
        }
    }

}

func swipeRecognizer() {
    let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture))
    swipeRecognizer.direction = .left
    view.addGestureRecognizer(swipeRecognizer)
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


