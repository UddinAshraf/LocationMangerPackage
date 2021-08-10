//
//  Locale+Extension.swift
//  TiseLocationManager
//
//  Created by Ashraf Uddin on 10/8/21.
//

import CoreLocation
extension Locale {
    static var isoCallingCodes = ["AW":297,"AF":93,"AO":244,"AI":1264,"AX":358,"AL":355,"AD":376,"AE":971,"AR":54,"AM":374,"AS":1684,"AG":1268,"AU":61,"AT":43,"AZ":994,"BI":257,"BE":32,"BJ":229,"BF":226,"BD":880,"BG":359,"BH":973,"BS":1242,"BA":387,"BL":590,"BY":375,"BZ":501,"BM":1441,"BO":591,"BR":55,"BB":1246,"BN":673,"BT":975,"BW":267,"CF":236,"CA":1,"CC":61,"CH":41,"CL":56,"CN":86,"CI":225,"CM":237,"CD":243,"CG":242,"CK":682,"CO":57,"KM":269,"CV":238,"CR":506,"CU":53,"CW":5999,"CX":61,"KY":1345,"CY":357,"CZ":420,"DE":49,"DJ":253,"DM":1767,"DK":45,"DO":1849,"DZ":213,"EC":593,"EG":20,"ER":291,"EH":212,"ES":34,"EE":372,"ET":251,"FI":358,"FJ":679,"FK":500,"FR":33,"FO":298,"FM":691,"GA":241,"GB":44,"GE":995,"GG":44,"GH":233,"GI":350,"GN":224,"GP":590,"GM":220,"GW":245,"GQ":240,"GR":30,"GD":1473,"GL":299,"GT":502,"GF":594,"GU":1671,"GY":592,"HK":852,"HN":504,"HR":385,"HT":509,"HU":36,"ID":62,"IM":44,"IN":91,"IO":246,"IE":353,"IR":98,"IQ":964,"IS":354,"IL":972,"IT":39,"JM":1876,"JE":44,"JO":962,"JP":81,"KZ":77,"KE":254,"KG":996,"KH":855,"KI":686,"KN":1869,"KR":82,"XK":383,"KW":965,"LA":856,"LB":961,"LR":231,"LY":218,"LC":1758,"LI":423,"LK":94,"LS":266,"LT":370,"LU":352,"LV":371,"MO":853,"MF":590,"MA":212,"MC":377,"MD":373,"MG":261,"MV":960,"MX":52,"MH":692,"MK":389,"ML":223,"MT":356,"MM":95,"ME":382,"MN":976,"MP":1670,"MZ":258,"MR":222,"MS":1664,"MQ":596,"MU":230,"MW":265,"MY":60,"YT":262,"NA":264,"NC":687,"NE":227,"NF":672,"NG":234,"NI":505,"NU":683,"NL":31,"NO":47,"NP":977,"NR":674,"NZ":64,"OM":968,"PK":92,"PA":507,"PN":64,"PE":51,"PH":63,"PW":680,"PG":675,"PL":48,"PR":1939,"KP":850,"PT":351,"PY":595,"PS":970,"PF":689,"QA":974,"RE":262,"RO":40,"RU":7,"RW":250,"SA":966,"SD":249,"SN":221,"SG":65,"GS":500,"SJ":4779,"SB":677,"SL":232,"SV":503,"SM":378,"SO":252,"PM":508,"RS":381,"SS":211,"ST":239,"SR":597,"SK":421,"SI":386,"SE":46,"SZ":268,"SX":1721,"SC":248,"SY":963,"TC":1649,"TD":235,"TG":228,"TH":66,"TJ":992,"TK":690,"TM":993,"TL":670,"TO":676,"TT":1868,"TN":216,"TR":90,"TV":688,"TW":886,"TZ":255,"UG":256,"UA":380,"UY":598,"US":1,"UZ":998,"VA":379,"VC":1784,"VE":58,"VG":1284,"VI":1340,"VN":84,"VU":678,"WF":681,"WS":685,"YE":967,"ZA":27,"ZM":260,"ZW":263]

    /// The calling code of the region.
    var callingCode: String? {
        guard let regionCode = regionCode, let callingCode = Locale.isoCallingCodes[regionCode] else { return nil }
        return String(callingCode)
    }
}
