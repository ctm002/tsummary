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
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.yellow
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
        contentView.backgroundColor = UIColor.green
        contentView.addSubview(lblCliente)
        contentView.addSubview(lblProyecto)
        contentView.addSubview(lblDetalleHora)
        contentView.addSubview(lblAsunto)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
