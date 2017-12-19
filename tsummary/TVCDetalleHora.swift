//
//  TVCDetalleHora.swift
//  tsummary
//
//  Created by Soporte on 12-12-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import UIKit

class TVCDetalleHora: UITableViewCell {
    
    var lblCliente: UILabel =
    {
        let lbl = UILabel(frame:.zero)
        return lbl
    }()
    
    var lblProyecto: UILabel =
    {
        let lbl = UILabel()
        return lbl
    }()
    
    
    var lblDetalleHora: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    
    var lblAsunto: UILabel =
    {
        let lbl = UILabel()
        return lbl
    }()
    
    /*
    override func awakeFromNib() {
        super.awakeFromNib()
    }*/
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    func setupLayout()
    {
        //contentView.backgroundColor = UIColor.green
        contentView.addSubview(lblCliente)
        contentView.addSubview(lblProyecto)
        contentView.addSubview(lblDetalleHora)
        contentView.addSubview(lblAsunto)
        
        lblCliente.translatesAutoresizingMaskIntoConstraints = false
        lblCliente.textAlignment = .left
        lblCliente.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        lblCliente.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        lblCliente.numberOfLines = 0
        lblCliente.backgroundColor = UIColor.yellow
        
        lblDetalleHora.translatesAutoresizingMaskIntoConstraints = false
        lblDetalleHora.textAlignment = .center
        lblDetalleHora.widthAnchor.constraint(equalToConstant: 80).isActive = true
        lblDetalleHora.heightAnchor.constraint(equalToConstant: 40).isActive = true
        lblDetalleHora.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        lblDetalleHora.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        lblDetalleHora.backgroundColor = UIColor.brown
        
        lblProyecto.translatesAutoresizingMaskIntoConstraints = false
        lblProyecto.textAlignment = .left
        lblProyecto.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        lblProyecto.heightAnchor.constraint(equalToConstant: 40).isActive = true
        lblProyecto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        lblProyecto.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        lblProyecto.numberOfLines = 0
        lblProyecto.backgroundColor = UIColor.purple
        
        lblAsunto.translatesAutoresizingMaskIntoConstraints = false
        lblAsunto.textAlignment = .left
        lblAsunto.numberOfLines = 0
        lblAsunto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        lblAsunto.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        lblAsunto.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        contentView.addConstraint(NSLayoutConstraint(item: lblCliente, attribute: .height, relatedBy: .equal, toItem: lblDetalleHora, attribute: .height, multiplier: 1, constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(item: lblDetalleHora, attribute: .leading, relatedBy: .equal, toItem: lblCliente, attribute: .trailing, multiplier: 1, constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(item: lblProyecto, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal,
            toItem: lblCliente, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(item: lblAsunto, attribute: .top, relatedBy: .equal, toItem: lblProyecto, attribute: .bottom, multiplier: 1, constant: 10))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
