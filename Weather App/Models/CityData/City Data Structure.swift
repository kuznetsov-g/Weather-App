//
//  JSON City Structure.swift
//
//
//  Created by Георгий iMac on 21.12.2020.
//

import Foundation
import UIKit

// JSON data structure from Yandex for requesting coordinates by object name.
// Used to find coordinates and correct city name
struct CityJSON : Decodable {
    var response: ResponseStruct
}

struct ResponseStruct: Decodable {
    var GeoObjectCollection: GeoObjectCollectionStruct
}

struct GeoObjectCollectionStruct: Decodable {
    var featureMember    : [FeatureMemberStruct]
    var metaDataProperty : MetaDataPropertyStructForResultCount
}

struct MetaDataPropertyStructForResultCount: Decodable {
    var GeocoderResponseMetaData: GeocoderResponseMetaDataStruct
}

struct GeocoderResponseMetaDataStruct: Decodable {
    var request: String
    var found  : String
}

struct FeatureMemberStruct: Decodable {
    var GeoObject : GeoObjectStruct
}

struct GeoObjectStruct: Decodable {
    var metaDataProperty : MetaDataPropertyStruct
    var Point            : PointStruct
}

struct MetaDataPropertyStruct: Decodable {
    var GeocoderMetaData : GeocoderMetaDataStruct
}

struct GeocoderMetaDataStruct: Decodable {
    var Address : AddressStruct
}

struct AddressStruct: Decodable {
    var Components : [ComponentsStruct]
}

struct ComponentsStruct: Decodable {
    var kind: String
    var name: String                        //name of the city
}

struct PointStruct: Decodable {
    var pos : String                        //coordinates in the format 56.229434 58.01045 (longitude / latitude)
}
