/* weatherManager.swift --> Clima. Created by Miguel Torres on 09/02/23. */

import Foundation

/* Protocolo para el WeatherManager. Este protocolo puede escribirse en cualquiera de los archivos .swift de la aplicación, siempre que esté fuera de cualquier clase o estructura. Pero por convención siempre se debe crear en el archivo de la clase o estructura que lleva su mismo nombre inicial. */
protocol WeatherManagerDelegate {
    // Prototipo de la función que requiere cualquier clase o estructura que implemente este protocolo.
    func receiveWeatherModel(weatherO: WeatherModel)
}

/// Se encarga de abrir la caja organizadora que representa la estructura WeatherData, llenarla con datos obtenidos en formato JSON con una llamada a la API de OpenWeather que realizó al inicio, y después construir con las piezas importantes de esa caja, un modelo útil para la aplicación que se representa como un objeto de la estructura WeatherModel. Este objeto lo manda a la clase WeatherViewController para que podamos utilizarlo en la interfaz de la aplicación.
struct WeatherManager {
    // URL básica para la llamada a la API de OpenWeather.
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=2efea90cc5e2995e5cd1d2ab8bd09bbc&units=metric"
    
    // Variable delegate
    var delegate: WeatherManagerDelegate?
    
    // Prepara la variable urlString con la información necesaria para llamar a la función que hace el request.
    func fetchWeather(_ cityName: String) {
        // Unimos la URL básica de la llamada a la API de OpenWeather con el nombre de la ciudad que obtenemos del textField.
        let urlString = "\(weatherURL)&q=\(cityName)"
        // Ahora, nuestra variable llamada urlString contiene toda la información necesaria para hacer una llamada a la API.
        performRequest(urlString) // Equivalente a self.performRequest(urlString)
    }
    
    
    // Los comentarios iniciales de la función performRequest están en el código de referencia
    func performRequest(_ urlString: String) {
        // Se crea un objeto que almacena la ubicación de un recurso (local o externo), en forma de un safeOptional
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
                    // Se manda a llamar a la función de esta misma estructura que crea un objeto tipo WeatherData a partir del archivo JSON de la API (variable data)
                    if let weatherObject = parseJSON(weatherData: safeData) {
                        self.delegate?.receiveWeatherModel(weatherO: weatherObject)
                    }
                }
            }
            task.resume() // Todas las tareas se inician es modo suspendido, para activarlas debemos usar este método.
        }
    }
    
    // Función para crear un objeto a partir de la información del formato JSON obtenido de la API
    /// Esta función construye un objeto en lenguaje Swift a partir de información obtenida en formato JSON desde la API de OpenWeather. Primero se crea un objeto reutilizable de tipo JSONDecoder, para extraer la información que se obtuvo de la API que se encuentra en formato JSON, con el objetivo de ingresarla a un objeto en lenguaje Swift. Utilizamos una estructura do-catch para prevenir posibles errores durante la ejecución de la aplicación, en caso de que se presente cualquier tipo de error, se salta toda la parte del "do" y se va directamente al bloque de "catch". Dentro del bloque "do" de esa estructura, creamos un objeto de tipo WeatherData (la estructura creada específicamente para recibir la información de la API), usando el objeto decodificador de tipo JSONDecoder y su método .decode, que pide como parámetro el tipo de dato del que se quiere formar el objeto (le indicamos que sea de tipo WeatherData), y la variable de la cual va a tomar toda la información para crear dicho objeto. Si esto es exitoso, a partir de la siguiente línea ya tenemos un objeto de la estructura WeatherData con toda la información recibida de la API y podemos consultarla por medio de las rutas que nos indique la extensión JSON Viewer Pro de Google Chrome al momento de llamar a la API desde ese navegador, o bien, analizando cuál es la ruta que debemos de utilizar, de acuerdo a la estructura WeatherData. A partir de aquí, solamente creamos explícitamente tres variables que reciben la información necesaria para construir un objeto de tipo WeatherModel, que será utilizado directamente para el manejo de la información que vamos a mostrar en nuestra aplicación.
    /// - Parameter weatherData: Recibe una variable de tipo Data, creada durante la llamada a la API, en la función performRequest.
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weatherObject = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weatherObject
        } catch {
            print(error)
            return nil
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
