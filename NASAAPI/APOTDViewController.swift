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
    let labelTitle = UILabel() // Title
    let textView = UITextView()
    let activityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        uploadPhoto()
    }
    
    func setupUI() {
        
        let view = UIView()
        view.backgroundColor = .lightGray

        view.addSubview(imageView)
        view.addSubview(labelDate)
        view.addSubview(labelCopyright)
        view.addSubview(textView)
        view.addSubview(activityIndicatorView)
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        
        textView.font = UIFont.systemFont(ofSize: 17.0)
        textView.textAlignment = .center
        textView.isEditable = false
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        labelCopyright.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
            
            textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            textView.heightAnchor.constraint(equalTo: textView.widthAnchor, multiplier: 0.5),
            
            labelDate.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 0),
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
        networkingAPOTD.fetchAstronomyPicture { (photoInfo) in
            if let photoInfo = photoInfo {
                self.updateUI(with: photoInfo)
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
                
                self.title = modelAPOTD.title
                self.imageView.image = image
                self.textView.text = modelAPOTD.description
                self.labelCopyright.text = modelAPOTD.copyright ?? " "
                self.labelDate.text = modelAPOTD.date
            }
        }
    }
    
}

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap({ URLQueryItem(name: $0.0, value: $0.1) })
        return components?.url
    }
}
