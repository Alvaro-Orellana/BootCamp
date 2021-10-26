/**
 1. Escribe una estructura Cartel que tenga dos propiedades
 almacenadas: titulo y textoPrincipal.
 
 2. Agrega, a la estructura Cartel, una propiedad computada de solo
 lectura: textoHtml, de manera tal que devuelva en formato HTML
 todo junto, ejemplo:
 titulo: "La vida en Australia"
 textoPrincipal: "La vida en Australia es fantástica"

 textoHtml: "<h1><La vida en Australia/h1><p>La vida en Australia es fantástica</p>"

 3. Se tiene una clase Condominio con una colección de propietarios,
 donde un propietario es una tupla de Nombre: String, y Deuda:
 Double.
 
 La función obtenerMaximoDeudor() busca al máximo deudor la
 primera vez recorriendo el arreglo de deudores. En invocaciones
 posteriores devuelve el valor ya obtenido:
 
 Ahora implementa este mismo comportamiento usando una
 propiedad lazy.
 
 
 4. Tomando el código fuente original del enunciado del ejercicio 3,
 modifícalo usando didSet para que cuando se agregue un nuevo
 propietario, la propiedad maximoDeudor vuelva al valor nil, y
 pueda volver a ser calculada cuando se llame dicha propiedad.
 Ejemplo:
 let condominio = Condominio()
 print(condominio.obtenerMaximoDeudor()?.Nombre) // Pedro

 condominio.propietarios.append((Nombre: "Tomás", Deuda: 1828282))
 print(condominio.obtenerMaximoDeudor()?.Nombre) // Tomás

 5. Usando una variable de tipo, crea una clase que, cuando se crea
 una instancia nueva, imprima en consola: “Ya existen N instancias
 de este tipo”, donde N es número total de instancias creadas
 hasta el momento.
 */


class Condominio2 {
    
    var propietarios: [(Nombre:String, Deuda:Double)] = [
        (Nombre:"Juan", Deuda:3900.0),
        (Nombre:"Pedro", Deuda:12900.0),
        (Nombre:"Gastón", Deuda:120.0),
        (Nombre:"Isabela", Deuda:0.0)]
    
    var maximoDeudor: (Nombre:String, Deuda:Double)? = nil
    
    func obtenerMaximoDeudor() -> (Nombre:String, Deuda:Double)? {
        if maximoDeudor == nil {
            calcMaximoDeudor()
        }
        return maximoDeudor
    }
    
    func calcMaximoDeudor() {
        var maxDeud = propietarios[0]
        for propietario in propietarios {
            if propietario.Deuda > maxDeud.Deuda {
                maxDeud = propietario
            }
        }
        maximoDeudor = maxDeud
    }
}

let condominio = Condominio2()
let maxDeudor = condominio.obtenerMaximoDeudor()
print(maxDeudor?.Nombre) // Pedro



struct Deudor: Comparable {
    static func < (lhs: Deudor, rhs: Deudor) -> Bool {
        lhs.Deuda < rhs.Deuda
    }
    
    var Nombre: String
    var Deuda: Float
}

struct Condominio {
    
    var propietarios: [Deudor] = []
    var maximoDeudor: Deudor? {
        return propietarios.max(by: <)
    }
    
    init() {
        propietarios = [
            Deudor(Nombre:"Juan", Deuda:3900.0),
            Deudor(Nombre:"Pedro", Deuda:12900.0),
            Deudor(Nombre:"Gastón", Deuda:120.0),
            Deudor(Nombre:"Isabela", Deuda:0.0)
        ]
    }
}



let condominio = Condominio()
let maxDeudor = condominio.maximoDeudor
print(maxDeudor?.Nombre) // Pedro

condominio.propietarios.append(Deudor(Nombre: "Tomás", Deuda: 1828282))
print(condominio.maximoDeudor?.Nombre) // Tomás
