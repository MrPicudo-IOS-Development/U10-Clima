/* ViewController.swift --> Clima. Created by Miguel Torres on 04/02/2023 .*/

import UIKit
// Framework necesario para acceder a la ubicación del dispositivo
import CoreLocation

// Agregamos como súper clase secundaria, la clase UITextFieldDelegate para poder controlar el TextField.
/// Controla la vista principal.
class WeatherViewController: UIViewController {
    
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
    
    // Objeto encargado de obtener la ubicación del dispositivo
    let locationManager = CLLocationManager()
    
    // Tenemos que "iniciar sesión" de este ViewController, en la clase UITextField para que pueda acceder a todos los métodos delegados.
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Asignación de delegates */
        
        // Definimos a nuestra clase ViewController como el "encargado" de comunicarse con el protocolo UITextFieldDelegate para manejar el UITextField.
        searchTextField.delegate = self // El delegado de la clase UITextField es la representación de todas las clases que pueden implementar el protocolo UITextFieldDelegate, aquí estamos diciendo que ese delegado es este ViewController que es de tipo UITextFieldDelegate.
        // Asignamos el delegate de WeatherManager a la clase WeatherViewController
        weatherManager.delegate = self
        // Asignamos el delegate de CLLocation a la clase WeatherViewController
        locationManager.delegate = self
        
        /* Métodos necesarios a la carga de la interfaz */
        
        // Solicitamos los permisos para acceder a la ubicación
        locationManager.requestWhenInUseAuthorization()
        // Solicitamos la localización de 1 solo uso, internamente llama a un método que se encuentra en un protocolo delegate.
        locationManager.requestLocation()
        
    }
    
}


// MARK: - UITextFieldDelegate

// Bloque de código relacionado a la implementación del protocolo UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    
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
    
}


// MARK: - WeatherManagerDelegate

// Bloque de código relacionado a la implementación del protocolo WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    
    /// Implementa el design delegate pattern creado en WeatherManager. Esta función recibe toda la información del objeto swift que se construyó con la API de Open Weather y manda sus datos a la interfaz, pero como es llamada desde el Completion Handler, depende al 100% de que éste termine para poder utilizar los datos.
    func receiveWeatherModel(_ weatherManager: WeatherManager, _ weatherO: WeatherModel) {
        // Usamos un DispatchQueue para poder mandar la información del objeto a la Interfaz de Usuario
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weatherO.conditionName)
            self.temperatureLabel.text = weatherO.stringTemperature
            self.cityLabel.text = weatherO.cityName
        }
    }
    
    // Función para imprimir el posible error en la consola al momento de probar la aplicación
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
}


// MARK: - CLLocationManagerDelegate

// Bloque relacionado a la implementación del protocolo CCLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    /* Para que funcione la ubicación en la App, se necesitan 2 métodos implementados del protocolo en esta extensión */
    
    // Método 1 del protocolo
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location receive.")
        // Usamos un optional binding para obtener la última ubicación del arreglo de CLLocation que se manda al llamar esta función
        if let location = locations.last {
            // Ya que recibimos la ubicación no es necesario seguirla pidiendo, ya que solo necesitamos una vez los datos.
            locationManager.stopUpdatingLocation()
            // Las variables lat y lon son de tipo CLLocationDegrees que son un typealias de Double.
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(" Latitude: \(lat) \n Longitude: \(lon)")
            weatherManager.fetchWeather(lat, lon)
        }
    }
    
    // Método 2 del protocolo
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    // Botón que consulta a la API con la ubicación del dispositivo
    @IBAction func locationButton(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}


/* Notas de prueba:
 
 // Prueba para modificar la imagen con un SFSymbol programaticamente
 conditionImageView.image = UIImage(systemName: "sun.max.circle")
 
*/
