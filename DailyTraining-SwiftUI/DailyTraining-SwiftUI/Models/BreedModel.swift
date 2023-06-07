//
//  BreedModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/11/23.
//

import Foundation

/*
 [
   {
     "weight": {
       "imperial": "7  -  10",
       "metric": "3 - 5"
     },
     "id": "abys", <------
     "name": "Abyssinian", <------
     "cfa_url": "http://cfa.org/Breeds/BreedsAB/Abyssinian.aspx",
     "vetstreet_url": "http://www.vetstreet.com/cats/abyssinian",
     "vcahospitals_url": "https://vcahospitals.com/know-your-pet/cat-breeds/abyssinian",
     "temperament": "Active, Energetic, Independent, Intelligent, Gentle", <------
     "origin": "Egypt",
     "country_codes": "EG",
     "country_code": "EG",
     "description": "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.", <------
     "life_span": "14 - 15",
     "indoor": 0,
     "lap": 1,
     "alt_names": "",
     "adaptability": 5,
     "affection_level": 5,
     "child_friendly": 3,
     "dog_friendly": 4,
     "energy_level": 5, <------
     "grooming": 1,
     "health_issues": 2,
     "intelligence": 5,
     "shedding_level": 2,
     "social_needs": 5,
     "stranger_friendly": 5,
     "vocalisation": 1,
     "experimental": 0,
     "hairless": 0, <------
     "natural": 1,
     "rare": 0,
     "rex": 0,
     "suppressed_tail": 0,
     "short_legs": 0,
     "wikipedia_url": "https://en.wikipedia.org/wiki/Abyssinian_(cat)", <------
     "hypoallergenic": 0,
     "reference_image_id": "0XYvRd7oD", <------
     "image": { <------
       "id": "0XYvRd7oD",
       "width": 1204,
       "height": 1445,
       "url": "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg"
     }
   }
 ]
 */


struct BreedModel: Codable, Identifiable {
    let id: String
    let name: String
    let temperament: String
    let description: String
    let energy_level: Int
    let hairless: Int
    
    let wikipedia_url: String?
    let reference_image_id: String?
    let alt_names: String?
    
//    var description: String {
//        return "breed with name: \(name) and id \(id), energy level: \(energyLevel) isHairless: \(isHairless ? "YES" : "NO")"
//    }
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case temperament
//        case description = "description"
//        case energyLevel = "energy_level"
//        case hairless = "hairless"
//        //case wikipedia = "wikipedia_url"
//        //case referenceImageId = "reference_image_id"
//        //case altNames = "alt_names"
//        //case image
//    }
    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//
//        id = try values.decode(String.self, forKey: .id)
//        name = try values.decode(String.self, forKey: .name)
//        temperament = try values.decode(String.self, forKey: .temperament)
//        breedExplaination = try values.decode(String.self, forKey: .breedExplaination)
//        energyLevel = try values.decode(Int.self, forKey: .energyLevel)
//
//        let hairless = try values.decode(Int.self, forKey: .isHairless)
//        isHairless = hairless == 1
//
//        //wikipedia = try values.decode(String.self, forKey: .wikipedia)
//        //referenceImageId = try values.decode(String.self, forKey: .referenceImageId)
//        altNames = try values.decode(String.self, forKey: .altNames)
//    }
    
//    init(name: String,
//         id: String,
//         explaination: String,
//         temperament: String,
//         energyLevel: Int,
//         isHairless: Bool,
//         //referenceImageId: String,
//         //wikipedia: String,
//         altNames: String,
//         image: BreedImage?) {
//            self.name = name
//            self.id = id
//            self.breedExplaination = explaination
//            self.energyLevel = energyLevel
//            self.temperament = temperament
//
//            self.isHairless = isHairless
//            //self.wikipedia = wikipedia
//            //self.referenceImageId = referenceImageId
//            self.altNames = altNames
//        }
    
    static func example1() -> BreedModel {
        return BreedModel(id: "abys",
                          name: "Abyssinian",
                          temperament: "Active, Energetic, Independent, Intelligent, Gentle",
                          description: "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
                        energy_level: 5,
                          hairless: 0,
                          wikipedia_url: "https://en.wikipedia.org/wiki/American_Curl",
                          reference_image_id: "xnsqonbjW",
                          alt_names: "Turkish Cat, Swimming cat"
                     )
    }

    static func example2() -> BreedModel {
        return BreedModel(id: "cypr",
                          name: "Cyprus",
                          temperament: "Affectionate, Social",
                          description: "Loving, loyal, social and inquisitive, the Cyprus cat forms strong ties with their families and love nothing more than to be involved in everything that goes on in their surroundings. They are not overly active by nature which makes them the perfect companion for people who would like to share their homes with a laid-back relaxed feline companion.",
                          energy_level: 4,
                          hairless: 1,
                          wikipedia_url: "https://en.wikipedia.org/wiki/American_Curl",
                          reference_image_id: "xnsqonbjW",
                          alt_names: "Turkish Cat, Swimming cat"
                     )
    }
}
