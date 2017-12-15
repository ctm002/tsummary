//
//  Custom.swift
//  tsummary
//
//  Created by Soporte on 07-12-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {

    let lblNro : UILabel = {
            let lbl = UILabel(frame: .zero)
            lbl.backgroundColor = UIColor.yellow
            return lbl
        
    }()
    
    let lblDia : UILabel = {
        let lbl = UILabel(frame:.zero)
        lbl.backgroundColor = UIColor.blue
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    func setupLayout()
    {
        contentView.addSubview(lblDia)
        contentView.addSubview(lblNro)
        
        lblNro.translatesAutoresizingMaskIntoConstraints = false
        lblNro.textAlignment = .center
        lblNro.widthAnchor.constraint(equalToConstant: 50)
        lblNro.heightAnchor.constraint(equalToConstant: 50)
        
        lblDia.translatesAutoresizingMaskIntoConstraints = false
        lblDia.textAlignment = .center
        lblDia.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        lblDia.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor).isActive = true
        lblDia.widthAnchor.constraint(equalToConstant: 50).isActive = true
        lblDia.heightAnchor.constraint(equalToConstant: 50).isActive = true
        lblDia.topAnchor.constraint(equalTo:  contentView.topAnchor, constant: 0).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
