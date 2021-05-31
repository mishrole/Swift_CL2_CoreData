//
//  ClienteTableViewCell.swift
//  CL2_T6NN_01_RodriguezLeonM
//
//  Created by Mitchell on 30/05/21.
//

import UIKit

class ClienteTableViewCell: UITableViewCell {

    @IBOutlet weak var NombreCliente: UILabel!
    @IBOutlet weak var DniCliente: UILabel!
    @IBOutlet weak var ServicioCliente: UILabel!
    @IBOutlet weak var TotalPagarCliente: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
