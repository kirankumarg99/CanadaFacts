//
//  TableViewCell.swift
//  CanadaFacts
//
//  Created by Kiran Chowdary on 8/5/18.
//  Copyright © 2018 Kiran Chowdary. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class TableViewCell: UITableViewCell {
    
    let factTitleLabel: UILabel = UILabel()
    let factDescriptionLabel: UILabel = UILabel()
    let factImageView: UIImageView = UIImageView()
    var imageViewRatioConstraint: Constraint? = nil
    var imageViewHeightConstraint: Constraint? = nil
    let defaultImage: UIImage = #imageLiteral(resourceName: "default_image")
    

    static let reuseIdentifier = "TableViewCell"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    //setting up views & Constraints
    func setupViews() {
        factTitleLabel.font = UIFont.systemFont(ofSize: 24)
        factTitleLabel.numberOfLines = 0
        factDescriptionLabel.numberOfLines = 0
        factImageView.contentMode = .scaleAspectFit
        let completeView = UIView()
        completeView.clipsToBounds = true
        completeView.layer.cornerRadius = 1
        contentView.addSubview(completeView)
        completeView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(10, 10, 10, 10))
        }
        
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .equalSpacing
        verticalStackView.spacing = 10
        verticalStackView.addArrangedSubview(factTitleLabel)
        verticalStackView.addArrangedSubview(factDescriptionLabel)
        
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fill
        horizontalStackView.alignment = .center
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(factImageView)
        
        
        factImageView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(100)
           
        }
        
        completeView.addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { make in
            make.edges.equalTo(completeView).inset(UIEdgeInsetsMake(10, 10, 10, 10))
        }
    }
    
    func displayData(_ fact: FactModel) {
        factTitleLabel.text = fact.title
        factDescriptionLabel.text = fact.description ?? "Description is not included"
        loadImage(fact)
        
        }
    // Image Caching with Kingfisher
    func loadImage(_ fact: FactModel){
        let imageURL = fact.imageHref
        
        if(imageURL != nil){
            ImageDownloader.default.downloadImage(with: imageURL!, retrieveImageTask: nil, options: [], progressBlock: nil) { (image, error, url, data) in
        
                //cache image:
                if let image =  image, let _ = url {
                    ImageCache.default.store(image, forKey: imageURL!.absoluteString)
                }
            }
            ImageCache.default.retrieveImage(forKey: imageURL!.absoluteString, options: nil) {
                image, cacheType in
                if image != nil {
                    
                    //We are storing the cache to disk
                    let resource = ImageResource(downloadURL: imageURL!, cacheKey:imageURL!.absoluteString)
                    self.factImageView.kf.setImage(with: resource, placeholder: self.defaultImage)
                } else {
                   
                    self.factImageView.kf.setImage(with: imageURL, placeholder: self.defaultImage)
                }
            }
            
            
        }
        else {
            self.factImageView.kf.setImage(with: imageURL, placeholder: self.defaultImage)
        }
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
