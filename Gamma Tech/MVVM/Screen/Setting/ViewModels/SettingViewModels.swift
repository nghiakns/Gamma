//
//  SettingViewModels.swift
//  WebView
//
//  Created by Kim Nghĩa on 08/03/2023.
//

import Foundation
import Alamofire

class SettingViewModels {
    func loginWithEmail(eventHandle: String, email: String, password: String, language: String, phoneName: String, uID: String, model: String, completion: @escaping (_ isSuccess: Bool, _ mess: String) -> Void) {
        let url = BaseApiRespositories.url
        if !email.isEmpty && !password.isEmpty {
            let params = ["cm": eventHandle,
                          "email": email,
                          "password": password,
                          "language": language,
                          "phonename": phoneName,
                          "uID": uID,
                          "model": model
            ] as [String : Any]
            AF.request(url, method: .get, parameters: params).responseData { res in
                if let data = res.data {
                    let json = String(data: data, encoding: String.Encoding.utf8) ?? ""
                    let isSuccess = json.lowercased().contains(ResourceText.networkResSuccess.localizedString())
                    if isSuccess {
                        completion(isSuccess, ResourceText.homeAlertLoginSuccess.localizedString())
                    } else {
                        completion(false, json)
                    }
                } else {
                    completion(false, ResourceText.commonAlertError.localizedString())
                }
            }
        } else {
            completion(false, ResourceText.homeAlertChangeLanguage.localizedString())
        }
    }
    
    func loginWithDeviceAdd(deviceAdd: String, key: String, lang: String, phoneName: String, uID: String, model: String, completion: @escaping (_ isSuccess: Bool, _ mess: String) -> Void) {
        let url = "http://\(deviceAdd)/public/authen.lp"
        if !deviceAdd.isEmpty && !key.isEmpty {
            let params = ["key": key,
                          "language": lang,
                          "phonename": phoneName,
                          "uID": uID,
                          "model": model
            ] as [String : Any]
            AF.request(url, method: .get, parameters: params).responseData { res in
                if let data = res.data {
                    let json = String(data: data, encoding: String.Encoding.utf8) ?? ""
                    let isSuccess = json.lowercased().contains(ResourceText.networkResSuccess.localizedString())
                    if isSuccess {
                        completion(isSuccess, ResourceText.homeAlertLoginSuccess.localizedString())
                    } else {
                        completion(false, json)
                    }
                } else {
                    completion(false, ResourceText.commonAlertError.localizedString())
                }
            }
        } else {
            completion(false, ResourceText.homeAlertChangeLanguage.localizedString())
        }
        
    }
    
    func logout(eventHandle: String, email: String, language: String, phoneName: String, uID: String, model: String) {
        let url = BaseApiRespositories.url
        let params = ["cm": eventHandle,
                      "email": email,
                      "language": language,
                      "phonename": phoneName,
                      "uID": uID,
                      "model": model
        ] as [String : Any]
        AF.request(url, method: .get, parameters: params).responseData { res in
            print(res.response?.statusCode)
        }
    }
    
    func resetPassword(eventHandle: String, email: String, phoneName: String, uID: String, model: String) {
        let url = BaseApiRespositories.url
        let params = ["cm": eventHandle,
                      "email": email,
                      "phonename": phoneName,
                      "uID": uID,
                      "model": model
        ] as [String : Any]
        AF.request(url, method: .get, parameters: params).responseData { res in
            print(res.response?.statusCode)
        }
    }
}
