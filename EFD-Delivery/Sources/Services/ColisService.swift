//
//  ColisService.swift
//  EFD-Delivery
//
//  Created by Yanis Lammari on 01/03/2025.
//

import Foundation

class ColisService {
    private static var instance: ColisService!

    var api: API {
        return API.getInstance()
    }
    
    var authService: AuthService {
        return AuthService.getInstance()
    }
    
    static func getInstance() -> ColisService {
        if self.instance == nil {
            self.instance = ColisService()
        }
        return self.instance
    }
    
    func getColisOfLivraison(completion: @escaping ([Colis]) -> Void) -> Void {
        let request = api.request(route: "/deliveryman/colis", method: "GET", token: self.authService.token)
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                return
            }
            let colis = json.compactMap(ColisFactory.newInstance(dict:))
            DispatchQueue.main.async {
                completion(colis)
            }
        }
        task.resume()
    }
    
    func getColisOfLivraisonById(id: String, completion: @escaping ([Colis]) -> Void) -> Void {
        let request = api.request(route: "/deliveryman/colis/\(id)", method: "GET", token: self.authService.token)
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                return
            }
            let colis = json.compactMap(ColisFactory.newInstance(dict:))
            DispatchQueue.main.async {
                completion(colis)
            }
        }
        task.resume()
    }
    
    func uploadPhotoColis(id: String, token: String, photoData: Data, completion: @escaping () -> Void) -> Void {
        // Construction de l'URL pour la route /upload/:id
        guard let url = URL(string: "\(api.baseUrl)/upload/\(id)") else {
            print("URL invalide")
            completion()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("BEARER \(token)", forHTTPHeaderField: "Authorization")
        
        // Création d'une boundary unique pour le multipart form-data
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Construction du corps de la requête en multipart/form-data
        var body = Data()
        let fieldName = "photo"
        let fileName = "photo.jpg"   // Nom du fichier, modifiable si nécessaire
        let mimeType = "image/jpeg"  // Le type MIME de la photo
        
        // Ajout de la partie pour le fichier
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(photoData)
        body.append("\r\n".data(using: .utf8)!)
        // Fin du multipart
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Exécution de la requête via URLSession
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erreur lors de l'upload : \(error)")
            } else {
                print("Upload réussi")
            }
            DispatchQueue.main.async {
                completion()
            }
        }
        task.resume()
    }
}
