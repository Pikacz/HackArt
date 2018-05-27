import UIKit
import PocketSVG


class Painting {
  let hitPaths: [Int: SVGBezierPath]
  let highlightPaths: [Int: SVGBezierPath]
  let framePath: SVGBezierPath
  let background: UIImage?
  
  let image: UIImage
  
  

  let data: [Int: InfoData]
  
  
  init(name: String?, image: UIImage, backgroundIamge: UIImage? = nil) {
    
    if let name: String = name,
       let url: URL = Bundle.main.url(forResource: name, withExtension: "svg") {
      var hit: [Int: SVGBezierPath] = [:]
      var highlight: [Int: SVGBezierPath] = [:]
      var frame: SVGBezierPath!
      
      for path: SVGBezierPath in SVGBezierPath.pathsFromSVG(at: url) {
        if Painting.isFrame(path: path) {
          frame = path
        } else if let hitId: Int = Painting.hitId(path: path) {
          hit[hitId] = path
        } else if let highlightId: Int = Painting.highlightId(path: path) {
          highlight[highlightId] = path
        }
      }
      self.hitPaths = hit
      self.highlightPaths = highlight
      self.framePath = frame
    } else {
      self.hitPaths = [:]
      self.highlightPaths = [:]
      self.framePath = SVGBezierPath(rect: CGRect.zero)
    }
    
    self.image = image
    self.background = backgroundIamge
    self.data = name == "Witkacy" ? witData : birdsData
  }
  
  
  private static func isFrame(path: SVGBezierPath) -> Bool {
    return path.id == "frame"
  }
  
  
  private static func hitId(path: SVGBezierPath) -> Int? {
    guard let pathId: String = path.id else { return nil }
    guard pathId.hasPrefix("hit_") else { return nil }
    return Int(pathId[pathId.index(pathId.startIndex, offsetBy: 4)...])
  }
  
  private static func highlightId(path: SVGBezierPath) -> Int? {
    guard let pathId: String = path.id else { return nil }
    guard pathId.hasPrefix("highlight_") else { return nil }
    return Int(pathId[pathId.index(pathId.startIndex, offsetBy: 10)...])
  }
}






fileprivate let birdsData: [Int: InfoData] = [
  1: InfoData(
    title: "Autor",
    text:
    """
    Józef Chełmoński pewnego dnia, wrócił ze spaceru z mrowiskiem.
    Może nie byłoby w tym nic szczególnie zadziwiającego,
    gdyby nie fakt, że mrowisko zostało umieszczone w jednym z pokojów.
    """
  ),
  2: InfoData(
    title:"Kuropatwy",
    text:
    """
    Kuropatwy są jednymi z najkrócej żyjących ptaków w Polsce (5 lat).
    """
  ),
  3: InfoData(
    title: "Autor",
    text:
    """
    Ojciec Chełmońskiego był wójtem wsi Boczki.
    """
  ),
  4: InfoData(
    title: "Przepis na kuropatwę",
    text:
    """
    Kuropatwę myjemy, osuszamy, całą dokładnie nacieramy solą, pieprzem, jałowcem i czosnkiem,
    tak natartą wkładamy do lodówki na 12 godzin. Następnie cienkimi plasterkami słoniny i boczku
    obkładamy całego ptaka, zapewni to jędrność mięsa. Przygotowaną kuropatwę wkładamy do naczynia
    żaroodpornego i wkładamy do piekarnika na 280 stopni na 30-40 minut, podczas pieczenia polewać
    czerwonym wytrawnym winem. Gotową odstawić w ciepłe miejsce na około 15 minut, w tym czasie na
    płynie z pieczenia przygotowujemy sos, dodajemy grzyby, śliwki wędzone, przyprawy i gotujemy aż
    płyn się zredukuje, gotowym polewamy ptaki, układamy na talerzu z buraczkami i zieleniną.
    """
    )
]

fileprivate let witData: [Int: InfoData] = [
  1: InfoData(
    title: "Autor",
    text:
    """
    Zaręczył się z poznaną w Zakopanem Jadwigą Janczewską, ale trudny okres narzeczeństwa skończył się tragicznie: 21 lutego 1914 roku Jadwiga popełniła samobójstwo.
    Wydarzyło się to po kłótni obojga - Jadwiga była w ciąży, Witkacy panicznie bał się konsekwencji wydawania potomstwa
    w świecie, którego przyszłość budził w nim najgorsze obawy - przez co obwiniał się za tę tragedię. Pisał w listach
    do Malinowskiego. - "Chcę mieć cyjanek potasu dlatego, żeby w każdej chwili być panem swego życia".
    """
  ),
  2: InfoData(
    title: "Autor",
    text:
    """
    Około 1925 roku Witkacy zarzucił malarstwo olejne i założył "Firmę Portretową S.I. Witkiewicz",
    stanowiącą główne źródło utrzymania. Klient musiał się stosować do zasad "Regulaminu",
    z których ostatnia oznajmiała: "Nieporozumienia wykluczone". Przez kilkanaście lat namalował kilka tysięcy portretów.
    Nie każdy jednak mógł dostąpić zaszczytu uwiecznienia. Niektóre prośby o wizerunek były odrzucane bezapelacyjnym: "Nie widzę powodu!"
    """
  ),
  3: InfoData(
    title: "Autor",
    text:
    """
    5 września 1939 roku wyruszył wraz z Czesławą Oknińską na wschód.
    Para uciekinierów dotarła do wsi Jeziory na Polesiu, gdzie 18 września - na wieść o wkroczeniu Armii Czerwonej
    do Polski - targnęli się na życie (mimo zażycia silnej dawki luminalu Oknińska przeżyła).
    """
  ),
  4: InfoData(
    title: "Autor",
    text:
    """
    Był dociekliwym eksperymentatorem w doświadczaniu ekstremalnych doznań, wszelako czynił to w celach poznawczych,
    stąd też - by uniknąć uzależnienia - jego seanse narkotyczne odbywały się pod pełną kontrolą lekarską.
    Witkiewicz przedstawia swój stosunek do narkotyków i przeżycia związane z ich zażywaniem w swojej książce
    "Narkotyki, nikotyna, alkohol, kokaina, peyotl, morfina, eter + appendix".
    """
  ),
  5: InfoData(
    title: nil,
    text:
    """
    Obraz ten jest młodzieńczą pracą Witkacego zaliczającą się do tzw. potworów - tj. kompozycji figuralnych
    przedstawiających na ogół fantastyczne, często zdeformowane postacie ludzkie - wykonywanych przez niego w latach 1906-1914.
    Inspirowane były one utworami literackimi - powieściami lub sztukami teatralnymi bądź stanowiły zapis własnych pomysłów
    artysty.
    """
  ),
]



struct InfoData {
  var title: String?
  var text: String
}





extension SVGBezierPath {
  
  var transform: CATransform3D {
    if let transform = svgAttributes["transform"] as? CGAffineTransform {
      return  CATransform3DMakeAffineTransform(transform)
    }
    
    return CATransform3DIdentity
  }
  
  
  var id: String? {
    return svgAttributes["id"] as? String
  }
  
  
}
