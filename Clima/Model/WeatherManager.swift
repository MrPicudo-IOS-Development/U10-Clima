/* weatherManager.swift --> Clima. Created by Miguel Torres on 09/02/23. */

import Foundation

struct WeatherManager {
    // URL básica para la llamada a la API de OpenWeather.
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=2efea90cc5e2995e5cd1d2ab8bd09bbc&units=metric"
    
    // Función que prepara la variable urlString con la información necesaria y la usa para llamar a la función que hace el request.
    func fetchWeather(_ cityName: String) {
        // Unimos la URL básica de la llamada a la API de OpenWeather con el nombre de la ciudad que obtenemos del textField.
        let urlString = "\(weatherURL)&q=\(cityName)"
        // Ahora, nuestra variable llamada urlString contiene toda la información necesaria para hacer una llamada a la API.
        performRequest(urlString) // Equivalente a self.performRequest(urlString)
    }
    
    
    // Los comentarios iniciales de la función performRequest están en el código de referencia
    func performRequest(_ urlString: String) {
        if let url = URL(string: urlString) {
            // Los objetos de la clase URLSession sirven para hacer Networking entre la aplicación y una API
            let session = URLSession(configuration: .default)
            // Usamos un trailing closure para llamar a la función que se encuentra en el parámetro del handler de .dataTask
            let task = session.dataTask(with: url) {data, response, error in // La tarea de un objeto URLSession sirve para "ingresar la dirección web".
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    // let dataString = String(data: safeData, encoding: .utf8)
                    parseJSON(weatherData: safeData) // Equivalente a self.parseJSON(weatherData: safeData), dentro de un closure***
                }
            }
            task.resume() // Todas las tareas se inician es modo suspendido, para activarlas debemos usar este método.
        }
    }
    
    // Función para crear un objeto a partir de la información del formato JSON obtenido de la API
    func parseJSON(weatherData: Data) {
        // Creamos un objeto reutilizable para decodificar el archivo JSON
        let decoder = JSONDecoder()
        // Usamos un método del objeto decoder que necesita un tipo de dato (nuestra estructura WeatherData), junto con la variable weatherData que viene de un safeOptional.
        do { // Estructura Do-Catch para trabajar con posibles errores.
            // Creamos un objeto de tipo weatherData usando el decodificador.
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            // Creamos las constantes que pasaremos como parámetros para construir el objeto del WeatherModel
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            // Construimos el objeto de la estructura WeatherModel
            let weatherObject = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            print(weatherObject.conditionName)
            print(weatherObject.stringTemperature)
            
        } catch {
            print(error)
        }
    }
     
}




/* Código de referencia para entender cómo se implementó el closure en el paso 3

// Función que hace el request a la API, siguiendo los 4 pasos necesarios para hacer un Networking en Swift.
func performRequest(_ urlString: String) {
    // 1.- Creamos un objeto de tipo URL, con una cadena simple, usando optional binding.
    if let url = URL(string: urlString) {
        // 2.- Creamos una URLSession que será el objeto encargado de hacer el Networking.
        let session = URLSession(configuration: .default) // Es equivalente a un navegador, dentro de la APP.
        
        // 3.- Creamos una tarea para el objeto URLSession.
        let task = session.dataTask(with: url, completionHandler: handler(data:response:error:)) // Regresa un objeto de tipo URLSessionDataTask
        /* La información del .dataTask anterior dice:
         Creates a task that retrieves the contents of a URL based on the specified URL request object, and calls a handler upon completion */
        
        // 4.- Iniciamos la tarea de tipo URLSessionDataTask creada, con su método resume()
        task.resume() // "After you create the task, you must start it by calling its resume() method
    }
}

// Creamos la función que será llamada dentro de los parámetros de la creación de task (URLSessionDataTask)
func handler(data: Data?, response: URLResponse?, error: Error?) {
    if error != nil { // Si no hay un error en la creación se nuestra tarea, la variable error se hace igual a nil.
        print(error!) // Mostramos el tipo de error que hubo.
        return // Salimos de la función, como esta parte se realiza primero, nunca vamos a llegar a lo siguiente de la función handler si hubo un error.
    }
    // Ya validamos que no haya errores, usamos un optional binding para hacer el unwrap de la variable data.
    if let safeData = data {
        // Creamos una cadena a partir de la información de la variable safeData, indicando que estamos trabajando con el protocolo  de codificación de caracteres de la red estandarizado: UFT8
        let dataString = String(data: safeData, encoding: .utf8)
        // Imprimimos la información que obtenemos a través de la API, ya decodificada.
        print("Información de la API: \n\n", dataString!)
    }
}

*/
