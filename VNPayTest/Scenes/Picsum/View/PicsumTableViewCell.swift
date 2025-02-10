//
//  PicsumTableViewCell.swift
//  VNPayTest
//
//  Created by Huynh Minh Hieu on 8/2/25.
//

import UIKit

class PicsumTableViewCell: BaseTableViewCell {
    private var imageTask: URLSessionDataTask?
    private var currentImageURL: String?
    
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var aspectRatioConstraint: NSLayoutConstraint?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        let bgView = UIView()
        bgView.backgroundColor = .clear
        selectedBackgroundView = bgView
        self.isUserInteractionEnabled = false
        
        contentView.addSubview(itemImageView)
        contentView.addSubview(authorLabel)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(sizeLabel)
        
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            itemImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            itemImageView.heightAnchor.constraint(equalToConstant: 300), // Default height
            
            authorLabel.leadingAnchor.constraint(equalTo: itemImageView.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: itemImageView.trailingAnchor),
            authorLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 10),
            
            sizeLabel.leadingAnchor.constraint(equalTo: itemImageView.leadingAnchor),
            sizeLabel.trailingAnchor.constraint(equalTo: itemImageView.trailingAnchor),
            sizeLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 10),
            sizeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            activityIndicator.centerXAnchor.constraint(equalTo: itemImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: itemImageView.centerYAnchor)
        ])
    }
    
    func configCell(with item: PhotoModel) {
        authorLabel.text = item.author
        sizeLabel.text = "Size: \(item.width ?? 0)x\(item.height ?? 0)"
        
        if let existingConstraint = aspectRatioConstraint {
            itemImageView.removeConstraint(existingConstraint)
        }
        
        let aspectRatio = CGFloat(item.height ?? 0) / CGFloat(item.width ?? 0)
        aspectRatioConstraint = itemImageView.heightAnchor.constraint(equalTo: itemImageView.widthAnchor, multiplier: aspectRatio)
        aspectRatioConstraint?.isActive = true
        
        if let imgURL = item.downloadUrl {
            currentImageURL = imgURL
        }
        
        itemImageView.image = nil
        activityIndicator.startAnimating()
        
        loadImage(url: currentImageURL ?? "")
    }
    
    private func loadImage(url: String) {
        imageTask?.cancel()
        imageTask = Ultis.createDownloadImageTaskAndCacheImage(url: url) {  image in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.itemImageView.image = image
                self.activityIndicator.stopAnimating()
                self.layoutIfNeeded()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        itemImageView.image = nil
        currentImageURL = nil
        activityIndicator.stopAnimating()
    }
    
}
