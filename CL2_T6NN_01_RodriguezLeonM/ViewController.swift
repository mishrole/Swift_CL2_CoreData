//
//  ViewController.swift
//  CL2_T6NN_01_RodriguezLeonM
//
//  Created by Mitchell on 30/05/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var txtNombres: UITextField!
    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtDni: UITextField!
    @IBOutlet weak var pvServicio: UIPickerView!
    @IBOutlet weak var txtCosto: UITextField!
    @IBOutlet weak var txtCantidad: UITextField!
    @IBOutlet weak var txtTotal: UITextField!
    @IBOutlet weak var txtServicioElegido: UITextField!
    @IBOutlet weak var tvListadoClientes: UITableView!
    
    var oListaServicio: [ServicioModel] = []
    var oListaCliente: [NSManagedObject] = []
    var oServicio: ServicioModel = ServicioModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pvServicio.dataSource = self
        pvServicio.delegate = self
        tvListadoClientes.dataSource = self
        tvListadoClientes.delegate = self
        
        // Valores por defecto
        self.txtCosto.text = "0.0"
        self.txtCantidad.text = "1"
        self.txtTotal.text = "0.0"
        
        // Observer de cantidad
        txtCantidad.addTarget(self, action: #selector(ViewController.txtCantidadDidChange(_:)), for: .editingChanged)
        
        // Data de Servicios
        oListaServicio.append(ServicioModel(pCodigo: "I60", pNombre: "Internet 60mb", pPrecioServicio: 229, pPrecioInstalacion: 20, pDescuentoServicio: 25))
        oListaServicio.append(ServicioModel(pCodigo: "I60", pNombre: "Internet 20mb", pPrecioServicio: 100, pPrecioInstalacion: 20, pDescuentoServicio: 5))
        oListaServicio.append(ServicioModel(pCodigo: "I60", pNombre: "Internet Satelital 40mb", pPrecioServicio: 180, pPrecioInstalacion: 30, pDescuentoServicio: 10))
    
        // Cargar datos en tabla
        consultarClientes()
    }
    
    // Utilitarios
    func mostrarAlerta(mensaje: String) {
        let alert = UIAlertController(title: "¡Atención!", message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default, handler: { action in
        }))
        present(alert, animated: true)
    }
    
    // Cálculos
    func calcularDescuentoServicio(precio: Double, descuento: Double) -> Double {
        return precio * (descuento / 100)
    }
    
    func calcularNeto(cantidadServicio: Double, precioServicio: Double, precioInstalacion: Double, descuentoServicio: Double) -> Double {
        let descuento = calcularDescuentoServicio(precio: precioServicio, descuento: descuentoServicio)
        return ((precioServicio - descuento) + precioInstalacion) * cantidadServicio
    }
    
    func generarCalculos() {
        let cantidad = Double(txtCantidad.text!)
        txtTotal.text = String(calcularNeto(cantidadServicio: cantidad ?? 0,precioServicio: oServicio.PrecioServicio, precioInstalacion: oServicio.PrecioInstalacion, descuentoServicio: oServicio.DescuentoServicio))
    }
    
    // Cálculo automático con observer a cantidad
    @objc func txtCantidadDidChange(_ textField: UITextField) {
        generarCalculos()
    }
    
    // Validaciones
    func servicioEsSeleccionado() -> Bool {
        if(txtServicioElegido.text?.isEmpty == true) {
            return false
        } else {
            return true
        }
    }
    
    func totalEsCalculado() -> Bool {
        if(txtTotal.text?.isEmpty == true) {
            return false
        } else {
            return true
        }
    }
    
    func formularioEsValido() -> Bool {
        if(txtNombres.text?.isEmpty == true || txtApellidos.text?.isEmpty == true || txtDni.text?.isEmpty == true || txtCantidad.text?.isEmpty == true) {
            return false
        } else {
            return true
        }
    }
    
    // Consultas
    func consultarClientes() {
        let oDelegado = UIApplication.shared.delegate as! AppDelegate
        let oContexto = oDelegado.persistentContainer.viewContext
        
        let oListado: NSFetchRequest<Cliente> = Cliente.fetchRequest()
        
        do {
            let result = try oContexto.fetch(oListado)
            oListaCliente = result as [NSManagedObject]
            tvListadoClientes.reloadData()
        }
        catch (let oError as NSError) {
            mostrarAlerta(mensaje: "Error al leer: \(oError.userInfo)")
        }
        
    }
    
    func registrarCliente() {
        let oDelegado = UIApplication.shared.delegate as! AppDelegate
        let oContexto = oDelegado.persistentContainer.viewContext
        
        let oEntidad = NSEntityDescription.entity(forEntityName: "Cliente", in: oContexto)
        
        let oNuevoRegistro = NSManagedObject(entity: oEntidad!, insertInto: oContexto)
        oNuevoRegistro.setValue(oListaCliente.count + 1, forKey: "codigo")
        oNuevoRegistro.setValue(txtNombres.text, forKey: "nombres")
        oNuevoRegistro.setValue(txtApellidos.text, forKey: "apellidos")
        oNuevoRegistro.setValue(txtDni.text, forKey: "dni")
        oNuevoRegistro.setValue(txtServicioElegido.text, forKey: "servicio")
        oNuevoRegistro.setValue(Double(txtCosto.text!), forKey: "costo")
        oNuevoRegistro.setValue(Double(txtCantidad.text!), forKey: "cantidad")
        oNuevoRegistro.setValue(Double(txtTotal.text!), forKey: "totalPagar")
        
        do {
            try oContexto.save()
            mostrarAlerta(mensaje: "Se registró con éxito")
            consultarClientes()
            limpiarFormulario()
        }
        catch (let oError as NSError) {
            mostrarAlerta(mensaje: "Error al grabar: \(oError.userInfo)")
        }
    }
    
    // Limpieza
    func limpiarFormulario() {
        txtNombres.text = ""
        txtApellidos.text = ""
        txtDni.text = ""
        txtServicioElegido.text = ""
        txtCosto.text = "0.0"
        txtCantidad.text = "1"
        txtTotal.text = "0.0"
    }
    
    // Acción agregar Cliente
    @IBAction func btnAgregar(_ sender: UIButton) {
        if(!formularioEsValido()) {
            mostrarAlerta(mensaje: "Todos los campos son obligatorios")
        } else {
            if(!servicioEsSeleccionado()) {
                mostrarAlerta(mensaje: "Seleccione un servicio")
            } else {
                registrarCliente()
            }
        }
    }
    
    // Picker View de Servicio
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return oListaServicio.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        oServicio = oListaServicio[row]
        txtServicioElegido.text = oServicio.Nombre
        txtCosto.text = String(oServicio.PrecioServicio)
        generarCalculos()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return oListaServicio[row].Nombre
    }
    
    // Table View de Cliente
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oListaCliente.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oCelda = tableView.dequeueReusableCell(withIdentifier: "CeldaCliente", for: indexPath as IndexPath) as! ClienteTableViewCell
        let oCliente: Cliente = oListaCliente[ indexPath.row] as! Cliente
        
        oCelda.NombreCliente?.text = String(oCliente.nombres!) + " " + String(oCliente.apellidos!)
        oCelda.DniCliente?.text = String(oCliente.dni!)
        oCelda.ServicioCliente?.text = String(oCliente.servicio!)
        oCelda.TotalPagarCliente?.text = "Total a pagar: " + String(oCliente.totalPagar)
        return oCelda
    }
    
}

