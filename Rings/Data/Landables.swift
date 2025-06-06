//
//  Landables.swift
//  Sectional Rings
//
//  Created by Chuck Deerinck on 4/24/25.
//

import Foundation
import SwiftUI
import Combine

class Landables: ObservableObject { //}, RandomAccessCollection {
    @Published var landables:[Landable]
    
    init() {
        self.landables = defaultLandables()
    }
    
    func describe() {
        for each in self.landables {
            print(each.description())
        }
    }
}

func defaultLandables() -> [Landable] {
    
    var landables:[Landable] = []
    
    //Id,Location,Sectional,Lat,Lon,Elev,Length,Width,x,y,x,y,Note,,,Err x,Err y
    
    landables.append(Landable("L78","Jacumba","Los-Angeles",32.6166667,116.163889,2844,25,60,13399.314908174289,10551.152841596131,"Gliderport.  Winch launch by schedule."))
    landables.append(Landable("OCA6","Emory Ranch","Los-Angeles",32.7475,116.02,480,24,40,13725.981274756932,10201.737363966142,"Low bushes on both sides."))
    landables.append(Landable("L54","Agua Caliente","Los-Angeles",32.9558333,116.295,1220,25,60,13090.630176449406,9619.37823458283,"Closed by NOTAM.  Land near centerline."))
    landables.append( Landable("KCRQ","McClellan-Palomar","Los-Angeles",33.12825,117.28,331,49,150,10908.858480374505,9266.976299879081,"Busy GA airport.  Some gliders present."))
    landables.append( Landable("L08","Borrego Valley","Los-Angeles",33.2597222,116.322222,522,50,75,13015.706697875405,8890.682708585247,"Aero-retreivable"))
    landables.append(Landable("CL35","Warner Springs","Los-Angeles",33.2838889,116.667222,2880,35,70,12245.493338134676,8836.926481257557,"Gliderport.  Aerotows 9am-5pm, 7 days per week."))
    landables.append(Landable("54CL","Lake Riverside Estates","Los-Angeles",33.5213889,116.795833,3410,35,40,11954.790241267556,8221.716324062878,"Private, but glider friendly.  Aero-retreivable."))
    landables.append(Landable("CA89","Skylark / Elsinore","Los-Angeles",33.6311111,117.300556,1262,27,100,10845.922758372344,7955.921644498187,""))
    landables.append(Landable("HMT","Hemet-Ryan","Los-Angeles",33.7338889,117.021667,1515,43,100,11454.30140439323,7657.275937122127,"Gliderport.  No local tows.  Aero-retreivable.  gliderstrip to N is 25' wide."))
    landables.append(Landable("CN64","Desert Center","Los-Angeles",33.74772,115.32525,559,42,50,15164.512063377746,7549.7634824667475,"Clear on both sides, OK for Open Class."))
    landables.append(Landable("UDD","Bermuda Dunes","Los-Angeles",33.7483333,116.273889,73,50,0,13084.636298163485,7612.479081015719," "))
    landables.append(Landable("BNG","Banning","Los-Angeles",33.9230556,116.849722,2222,49,0,11819.927979834352,7170.483434099154,"Closure announced."))
    landables.append(Landable("REI","Redlands","Los-Angeles",34.0852778,117.146389,1574,45,0,11169.59218581203,6755.365900846433,""))
    landables.append(Landable("L22","Yacca Valley","Los-Angeles",34.1277778,116.407778,3224,43,0,12769.957688152683,6600.070133010882,""))
    landables.append(Landable("L35","Big Bear","Los-Angeles",34.2636111,116.853611,6752,58,75,11795.952466690673,6277.532769044739,"Aero-retreivable"))
    landables.append(Landable("NXP","Twentynine Palms Self"," ",34.2833333,116.1675,2051,80,0,13297.418977313648,6161.060943168077,""))
    landables.append(Landable("L26","Hesperia","Los-Angeles",34.3772222,117.315833,3390,39,0,10791.977853799062,5996.8058041112445,""))
    landables.append(Landable("46CN","Crystal","Los-Angeles",34.4847222,117.826667,3420,27,0,9680.113431760892,5722.051753325271,""))
    landables.append(Landable("APV","Apple Valley","Los-Angeles",34.5705556,117.187778,3062,65,0,11067.696254951386,5471.189359129383,""))
    landables.append(Landable("5CA4","Ludlow","Los-Angeles",34.7533333,116.154167,1700,26,0,13282.434281598848,5020.234340991536,""))
    landables.append(Landable("DAG","Barstow-Daggett","Los-Angeles",34.8536111,116.786667,1930,64,0,11918.826971552035,4715.615719467956,""))
    landables.append(Landable("","Chiriaco Summit","Los-Angeles",0.0,0.0,1711,40,0,14325.369103348938,7782.707134220072,""))
    landables.append(Landable("","Blythe","Los-Angeles",0.0,0.0,400,65,0,16507.14079942384,7830.4904474002415,""))
    landables.append(Landable("TNP","Twentynine Palms","Los-Angeles",0.0,0.0,1888,55,0,13779.926179330212,6582.151390568319,""))
    landables.append(Landable("","General Fox","Los-Angeles",0.0,0.0,2351,72,0,8828.982715160246,5056.071825876662,""))
    landables.append(Landable("","Agua Dulce","Los-Angeles",0.0,0.0,2633,42,0,8625.190853438964,5680.241354292623,""))
    landables.append(Landable("","Santa Paula","Los-Angeles",0.0,0.0,250,26,0,7003.846777097588,6086.3995163240625,""))
    landables.append(Landable("","Santa Ynez","Los-Angeles",0.0,0.0,674,28,0,4807.090385307886,5381.595646916566,""))
    landables.append(Landable("","Mountain Valley","Los-Angeles",0.0,0.0,4220,37,0,8385.43572200216,4115.337847642079,""))
    landables.append(Landable("","CalCity","Los-Angeles",0.0,0.0,2454,60,0,9263.53889088945,3983.933736396614,""))
    landables.append(Landable("","Rosamond","Los-Angeles",0.0,0.0,2415,36,0,8858.952106589844,4718.602176541717,""))
    landables.append(Landable("","Inyokern","Los-Angeles",0.0,0.0,2457,71,0,9653.140979474252,2651.9738814993952,""))
    landables.append(Landable("","Karn Valley","Los-Angeles",0.0,0.0,2614,35,0,8394.426539431042,2469.7999999999997,""))
    landables.append(Landable("","Desert Air Sky Ranch","Los-Angeles",0.0,0.0,0,30,0,13980.721101908533,8266.513180169286,""))
    landables.append(Landable("","Baker","Los-Angeles",0.0,0.0,922,31,0,13411.302664746128,3568.8162031438933,""))
    landables.append(Landable("","Jean","Los-Angeles",0.0,0.0,2835,46,0,14987.692653943104,2263.7344619105197,""))
    
    return landables
}
