/* ViewController.swift --> Clima. Created by Angela Yu on 01/09/2019.*/

import UIKit

// Agregamos como súper clase secundaria, la clase UITextFieldDelegate para poder controlar el teclado.
class WeatherViewController: UIViewController, UITextFieldDelegate {

    // IBOutlets de la interfaz para el text field, el símbolo SF del clima, el número de la temperatura y la ciudad
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    // Variables globales
    var city: String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Definimos a nuestra clase ViewController como el encargado de manejar el Text Field
        searchTextField.delegate = self
    }

    // Función que controla el bot{on de búsqueda de la aplicación.
    @IBAction func searchButton(_ sender: UIButton) {
        print(searchTextField.text!)
        // Indicamos que terminamos de escribir en el TextField
        searchTextField.endEditing(true)
    }
    
    // Función para definir lo que queremos que realice la aplicación cuando el usuario presione "Enter" en el keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        // Indicamos que terminamos de escribir en el TextField
        searchTextField.endEditing(true)
        return true
    }
    
    // Función que se activa cuando se llama al método .endEditing(true)
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Capturamos en una variable global, el nombre de la ciudad que escribió el usuario
        city = searchTextField.text
        // Borramos el texto que haya dentro del TextField
        searchTextField.text = ""
    }
    
    // Función que valida si el usuario ha terminado de escribir texto, para que funcione el botón de Enter o de buscar.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // Usamos el parámetro "textField" que representa cualquier textField que tengamos en nuestra interfaz.
        if(textField.text != "") {
            return true
        } else {
            textField.placeholder = "Type something"
            // El siguiente método hace que el programa espere 1.0 segundos para realizar lo que tenga en su bloque de código.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                textField.placeholder = "Search"
            }
            return false
        }
    }
    
}

