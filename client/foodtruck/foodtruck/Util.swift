//
//  Util.swift
//  foodtruck
//
//  Created by Yifan Ying on 10/25/15.
//  Copyright © 2015 Yifan Ying. All rights reserved.
//

import Foundation
import UIKit

class Util {
    
    static let dict = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "environment", ofType: "plist")!)
    
    enum DeivceType {
        case iPhone5
        case iPhone6
        case iPhone6Plus
    }
    
    static let DAY_MAP:[Int:String] = [0:"Monday", 1:"Tuesday", 2:"Wednesday", 3:"Thursday", 4:"Friday", 5:"Saturday", 6:"Sunday"]
    
    class func getEnvProperty(_ key: String) -> String {
        return dict!.object(forKey: key) as! String
    }
    
    // convert string to json object
    class func JSONParseArray(_ string: String) -> [AnyObject]{
        if let data = string.data(using: String.Encoding.utf8) {
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject] {
                    return array
                }
            } catch {
                print("error")
            }
        }
        return [AnyObject]()
    }
    
    class func convertToHours(_ seconds: Int) -> String {
        var hourStr: String!
        var minuteStr: String!
        
        hourStr = seconds/3600 < 10 ? "0\(seconds/3600)" : "\(seconds/3600)"
        minuteStr = seconds%3600/60 < 10 ? "0\(seconds%3600/60)" : "\(seconds%3600/60)"
        return "\(hourStr!):\(minuteStr!)"
    }
    
    class func loadImage(_ imageView: UIImageView, imageUrl: String) {
        if let url: URL = URL(string: imageUrl) {
            getDataFromUrl(url) { (data, response, error)  in
                DispatchQueue.main.async { () -> Void in
                    guard let data = data, error == nil else { return }
                    imageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    class func getDataFromUrl(_ url:URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: NSError? ) -> Void)) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            completion(data, response, error as NSError?)
            }) .resume()
    }
    
    // retrieve street and city name
    class func retrieveEssentialAddressPart(_ address:String) -> String {
        let addressArr: [String] = address.components(separatedBy: ",")
        let length = addressArr.count
        var result = addressArr[0].trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines)
        
        for index in 1...length-2 {
            result += ", \(addressArr[index])"
        }
        
        return result
    }
    
    class func getDeviceType() -> DeivceType {
        let screenSize = UIScreen.main.bounds.size
        let height = max(screenSize.width, screenSize.height)
        
        switch height {
        case 568:
            return .iPhone5
        case 667:
            return .iPhone6
        case 736:
            return .iPhone6Plus
        default:
            return .iPhone6
        }
    }
    
    // Mon: 0, Tue: 1, Wed: 2, Thu: 3, Fri: 4, Sat: 5, Sun: 6
    class func getDayOfWeek() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        return day - 1
    }
    
    class func getDayStrOfWeek() -> String? {
        let day = getDayOfWeek()
        return DAY_MAP[day]
    }
    
    class func getSecondsOfDay() -> Int? {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        return hour * 3600 + minute * 60
    }
}

