/* ViewController.swift --> Clima. Created by Miguel Torres on 04/02/2023 .*/

import UIKit

// Agregamos como súper clase secundaria, la clase UITextFieldDelegate para poder controlar el TextField.
/// Controla la vista principal, implementa protocolos de UITextFieldDelegate y WeatherManagerDelegate
class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
    
    /* Llave para usar la API de OpenWeather: 2efea90cc5e2995e5cd1d2ab8bd09bbc */
    
    // Creamos el objeto de la estructura WeatherManager, sobre este objeto vamos a definir este clase como el delegado de la estructura WeatherManager
    var weatherManager = WeatherManager()
    
    // IBOutlets de la interfaz para el text field, el símbolo SF del clima, el número de la temperatura y la ciudad
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    // Creamos un objeto de la clase UITextField
    @IBOutlet weak var searchTextField: UITextField!
    
    // Variables globales
    var city: String? = nil
    
    // Tenemos que "iniciar sesión" de este ViewController, en la clase UITextField para que pueda acceder a todos los métodos delegados.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Definimos a nuestra clase ViewController como el "encargado" de comunicarse con el protocolo UITextFieldDelegate para manejar el UITextField.
        searchTextField.delegate = self // El delegado de la clase UITextField es la representación de todas las clases que pueden implementar el protocolo UITextFieldDelegate, aquí estamos diciendo que ese delegado es este ViewController que es de tipo UITextFieldDelegate.
        // Prueba para modificar la imagen con un SFSymbol programaticamente
        conditionImageView.image = UIImage(systemName: "sun.max.circle")
        // Asignamos el delegate de WeatherManager a la clase WeatherViewController
        weatherManager.delegate = self
    }

    // Función que controla el botón de búsqueda de la aplicación.
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
        // Mandamos a la variable global como parámetro del método fetchWeather, usando Optional Binding.
        if let city = searchTextField.text {
            weatherManager.fetchWeather(city)
        }
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
    
    // Función para implementar el delegate design pattern en nuestra aplicación
    func receiveWeatherModel(_ weatherManager: WeatherManager, _ weatherO: WeatherModel) {
        print("Hola!! ", weatherO.conditionName)
        // conditionImageView.image = UIImage(systemName: weatherO.conditionName)
    }
    
    // Función para imprimir el posible error en la consola al momento de probar la aplicación
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
}

