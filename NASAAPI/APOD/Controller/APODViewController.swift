//
//  ViewController.swift
//  NASAAPI
//
//  Created by Егор Горских on 16.12.2020.
//

import UIKit

final class APODViewController: UIViewController {
    
    let av = APODView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationController()
        addSubviews()
        storeConstraints()
        buttonActionAndimageTapped()
        uploadPhoto()
        
    }

    func setupNavigationController() {
        self.view.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "apod"
        view.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }

    private func buttonActionAndimageTapped() {
        av.buttonDescriptionVC.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector((imageTapped)))
        av.imageView.addGestureRecognizer(tap)
    }
    
    private func addSubviews() {

        view.addSubview(av.imageView)
        view.addSubview(av.labelDate)
        view.addSubview(av.labelCopyright)
        view.addSubview(av.activityIndicatorView)
        view.addSubview(av.labelTitle)
        view.addSubview(av.buttonDescriptionVC)
    }
    
    private func storeConstraints() {
        
        NSLayoutConstraint.activate([
            av.labelTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            av.labelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            av.labelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            av.imageView.topAnchor.constraint(equalTo: av.labelTitle.topAnchor, constant: 20),
            av.imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            av.imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            av.imageView.heightAnchor.constraint(equalTo: av.imageView.widthAnchor, multiplier: 1),
            
            av.buttonDescriptionVC.topAnchor.constraint(equalTo: av.imageView.bottomAnchor, constant: 15),
            av.buttonDescriptionVC.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            av.buttonDescriptionVC.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            av.labelDate.topAnchor.constraint(equalTo: av.buttonDescriptionVC.bottomAnchor, constant: 10),
            av.labelDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            av.labelCopyright.topAnchor.constraint(equalTo: av.labelDate.bottomAnchor, constant: 0),
            av.labelCopyright.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            av.activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            av.activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    private func uploadPhoto() {
        let networkingAPOTD = APODNetworking()
        networkingAPOTD.fetchAstronomyPicture { (modelAPOTD) in
            
            if let modelAPOTD = modelAPOTD {
                self.updateUI(with: modelAPOTD)
            }
        }
    }
    
    private func updateUI(with modelAPOTD: APODModel) {
        let networkingAPOTD = APODNetworking()
        
        networkingAPOTD.fetchUrlData(with: modelAPOTD.url) { (data) in
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                return
            }
            
            DispatchQueue.main.async {
                self.av.activityIndicatorView.stopAnimating()
                self.av.activityIndicatorView.isHidden = true
                self.av.buttonDescriptionVC.isHidden = false
                
                self.av.labelTitle.text = modelAPOTD.title
                self.av.imageView.image = image
                self.av.labelCopyright.text = modelAPOTD.copyright ?? " "
                self.av.labelDate.text = modelAPOTD.date
            }
        }
    }
    
    @objc func buttonAction(_ : UIButton) {
        let apotdDescriptionViewController = APODDescriptionViewController()
        apotdDescriptionViewController.modalPresentationStyle = .fullScreen
        present(apotdDescriptionViewController, animated: true, completion: nil)
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        newImageView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
}
