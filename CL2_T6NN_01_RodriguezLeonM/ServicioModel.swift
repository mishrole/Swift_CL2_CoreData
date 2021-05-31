//
//  ServicioModel.swift
//  CL2_T6NN_01_RodriguezLeonM
//
//  Created by Mitchell on 30/05/21.
//

import UIKit

class ServicioModel: NSObject {
    
    var Codigo: String = ""
    var Nombre: String = ""
    var PrecioServicio: Double = 0
    var PrecioInstalacion: Double = 0
    var DescuentoServicio: Double = 0
    
    override init() {
        Codigo = ""
        Nombre = ""
        PrecioServicio = 0
        PrecioInstalacion = 0
        DescuentoServicio = 0
    }
    
    init(pCodigo: String, pNombre: String, pPrecioServicio: Double, pPrecioInstalacion: Double, pDescuentoServicio: Double) {
        self.Codigo = pCodigo
        self.Nombre = pNombre
        self.PrecioServicio = pPrecioServicio
        self.PrecioInstalacion = pPrecioInstalacion
        self.DescuentoServicio = pDescuentoServicio
    }
}
