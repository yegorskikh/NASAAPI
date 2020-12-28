//
//  ViewController.swift
//  NASAAPI
//
//  Created by Егор Горских on 16.12.2020.
//

import UIKit
import Foundation

class APOTDViewController: UIViewController {
    
    lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var buttonDescriptionVC: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.backgroundColor = .purple
        button.setTitle("description", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(APOTDViewController.buttonAction(_ :)), for: .touchUpInside)
        button.isHidden = true
        button.layer.cornerRadius = 10
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        button.layer.cornerRadius = cornerRadius
        
        return button
    }()
    
    lazy var labelDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var labelCopyright: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.color = .black
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicatorView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        
        addSubviews()
        setupConstraints()
        uploadPhoto()
    }

    private func addSubviews() {
        self.view.addSubview(imageView)
        self.view.addSubview(labelDate)
        self.view.addSubview(labelCopyright)
        self.view.addSubview(activityIndicatorView)
        self.view.addSubview(labelTitle)
        self.view.addSubview(buttonDescriptionVC)
    }
    
    private func setupConstraints() {
        
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
    }
    
    private func uploadPhoto() {
        let networkingAPOTD = NetworkingAPOTD()
        networkingAPOTD.fetchAstronomyPicture { (modelAPOTD) in
            
            if let modelAPOTD = modelAPOTD {
                self.updateUI(with: modelAPOTD)
            }
        }
    }
    
    private func updateUI(with modelAPOTD: ModelAPOTD) {
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



