//
//  ViewController.swift
//  NASAAPI
//
//  Created by Егор Горских on 16.12.2020.
//

import UIKit
import Foundation

class APOTDViewController: UIViewController {
    
    let imageView = UIImageView()
    let labelDate = UILabel()
    let labelCopyright = UILabel()
    let labelTitle = UILabel()
    let activityIndicatorView = UIActivityIndicatorView()
    let buttonDescriptionVC = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        uploadPhoto()
    }

    func setupUI() {
        
        let view = UIView()
        view.backgroundColor = .darkGray
        
        view.addSubview(imageView)
        view.addSubview(labelDate)
        view.addSubview(labelCopyright)
        view.addSubview(activityIndicatorView)
        view.addSubview(labelTitle)
        view.addSubview(buttonDescriptionVC)
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        activityIndicatorView.color = .black
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        
        labelTitle.numberOfLines = 0
        labelTitle.textAlignment = .center
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        labelCopyright.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonDescriptionVC.clipsToBounds = true
        buttonDescriptionVC.backgroundColor = .purple
        buttonDescriptionVC.setTitle("description", for: .normal)
        buttonDescriptionVC.translatesAutoresizingMaskIntoConstraints = false
        buttonDescriptionVC.addTarget(self, action: #selector(APOTDViewController.buttonAction(_ :)), for: .touchUpInside)
        buttonDescriptionVC.isHidden = true
        buttonDescriptionVC.layer.cornerRadius = 10
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        buttonDescriptionVC.backgroundColor = UIColor.clear
        buttonDescriptionVC.layer.borderWidth = 1.0
        buttonDescriptionVC.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        buttonDescriptionVC.layer.cornerRadius = cornerRadius
        
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            labelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            labelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            imageView.topAnchor.constraint(equalTo: labelTitle.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
            
            buttonDescriptionVC.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            buttonDescriptionVC.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            buttonDescriptionVC.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            labelDate.topAnchor.constraint(equalTo: buttonDescriptionVC.bottomAnchor, constant: 10),
            labelDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            labelCopyright.topAnchor.constraint(equalTo: labelDate.bottomAnchor, constant: 0),
            labelCopyright.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        self.view = view
    }
    
    func uploadPhoto() {
        let networkingAPOTD = NetworkingAPOTD()
        networkingAPOTD.fetchAstronomyPicture { (modelAPOTD) in
            
            if let modelAPOTD = modelAPOTD {
                self.updateUI(with: modelAPOTD)
            }
        }
    }
    
    func updateUI(with modelAPOTD: ModelAPOTD) {
        let networkingAPOTD = NetworkingAPOTD()
        networkingAPOTD.fetchUrlData(with: modelAPOTD.url) { (data) in
            guard let data = data,
                  let image = UIImage(data: data)
            else {
                return
            }
            
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
                self.buttonDescriptionVC.isHidden = false
                
                self.labelTitle.text = modelAPOTD.title
                self.imageView.image = image
                self.labelCopyright.text = modelAPOTD.copyright ?? " "
                self.labelDate.text = modelAPOTD.date
            }
        }
    }
    
    @objc func buttonAction(_ : UIButton) {
        print("Button tapped")
        
        let descriptionViewController = DescriptionViewController()
        descriptionViewController.modalPresentationStyle = .fullScreen
        present(descriptionViewController, animated: true, completion: nil)
    }
    
}

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap({ URLQueryItem(name: $0.0, value: $0.1) })
        return components?.url
    }
}



