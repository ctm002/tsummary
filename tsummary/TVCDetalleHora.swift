//
//  TVCDetalleHora.swift
//  tsummary
//
//  Created by Soporte on 12-12-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import UIKit

class TVCDetalleHora: UITableViewCell {
    
    var mostrar: Bool = false
    
    var lblCliente: UILabel =
    {
        let lbl = UILabel(frame:.zero)
        lbl.textColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    var lblProyecto: UILabel =
    {
        let lbl = UILabel(frame:.zero)
        lbl.textColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0)
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        return lbl
    }()
    
    var lblDetalleHora: UILabel = {
        let lbl = UILabel(frame:.zero)
        lbl.textColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    var lblAsunto: UILabel =
    {
        let lbl = UILabel(frame:.zero)
        lbl.textColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0)
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        return lbl
    }()
    
    var lblFechaIngreso: UILabel = {
        let lbl = UILabel(frame:.zero)
        lbl.textColor = UIColor(red:0.91, green:0.44, blue:0.05, alpha:1.0)
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        return lbl
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    var IdHora: Int32 = 0
    
    func setupLayout()
    {
        contentView.addSubview(lblCliente)
        contentView.addSubview(lblProyecto)
        contentView.addSubview(lblDetalleHora)
        contentView.addSubview(lblAsunto)
        contentView.addSubview(lblFechaIngreso)
        
        lblCliente.translatesAutoresizingMaskIntoConstraints = false
        lblCliente.textAlignment = .left
        lblCliente.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        lblCliente.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        lblCliente.numberOfLines = 0
        lblCliente.backgroundColor = mostrar ? UIColor.yellow :  UIColor.white
        
        lblDetalleHora.translatesAutoresizingMaskIntoConstraints = false
        lblDetalleHora.textAlignment = .center
        lblDetalleHora.widthAnchor.constraint(equalToConstant: 80).isActive = true
        lblDetalleHora.heightAnchor.constraint(equalToConstant: 40).isActive = true
        lblDetalleHora.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        lblDetalleHora.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        lblDetalleHora.backgroundColor = mostrar ?  UIColor.brown : UIColor.white
        
        lblProyecto.translatesAutoresizingMaskIntoConstraints = false
        lblProyecto.textAlignment = .left
        lblProyecto.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        lblProyecto.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lblProyecto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        lblProyecto.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        lblProyecto.numberOfLines = 0
        lblProyecto.backgroundColor = mostrar ?  UIColor.purple : UIColor.white
        
        lblAsunto.translatesAutoresizingMaskIntoConstraints = false
        lblAsunto.textAlignment = .left
        lblAsunto.numberOfLines = 0
        //lblAsunto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        lblAsunto.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        //lblAsunto.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        lblFechaIngreso.translatesAutoresizingMaskIntoConstraints = false
        lblFechaIngreso.textAlignment = .left
        lblFechaIngreso.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        lblFechaIngreso.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        lblFechaIngreso.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lblFechaIngreso.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        contentView.addConstraint(NSLayoutConstraint(item: lblCliente, attribute: .height, relatedBy: .equal, toItem: lblDetalleHora, attribute: .height, multiplier: 1, constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(item: lblDetalleHora, attribute: .leading, relatedBy: .equal, toItem: lblCliente, attribute: .trailing, multiplier: 1, constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(item: lblProyecto, attribute: .top, relatedBy: .equal, toItem: lblCliente, attribute: .bottom, multiplier: 1, constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(item: lblAsunto, attribute: .top, relatedBy: .equal, toItem: lblProyecto, attribute: .bottom, multiplier: 1, constant: 5))
        
        contentView.addConstraint(NSLayoutConstraint(item: lblFechaIngreso, attribute: .top, relatedBy: .equal, toItem: lblAsunto, attribute: .bottom, multiplier: 1, constant: 10))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
