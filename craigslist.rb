require 'open-uri'
require 'feedjira'

class Craigslist

  CITIES = ["auburn", "bham", "dothan", "shoals", "gadsden", "huntsville",
            "mobile", "montgomery", "tuscaloosa", "anchorage", "fairbanks",
            "kenai", "juneau", "flagstaff", "mohave", "phoenix", "prescott",
            "showlow", "sierravista", "tucson", "yuma", "fayar", "fortsmith",
            "jonesboro", "littlerock", "texarkana", "bakersfield", "chico",
            "fresno", "goldcountry", "hanford", "humboldt", "imperial",
            "inlandempire", "losangeles", "mendocino", "merced", "modesto",
            "monterey", "orangecounty", "palmsprings", "redding", "sacramento",
            "sandiego", "sfbay", "slo", "santabarbara", "santamaria",
            "siskiyou", "stockton", "susanville", "ventura", "visalia",
            "yubasutter", "boulder", "cosprings", "denver", "eastco",
            "fortcollins", "rockies", "pueblo", "westslope", "newlondon",
            "hartford", "newhaven", "nwct", "delaware", "washingtondc",
            "daytona", "keys", "fortlauderdale", "fortmyers", "gainesville",
            "cfl", "jacksonville", "lakeland", "lakecity", "ocala", "okaloosa",
            "orlando", "panamacity", "pensacola", "sarasota", "miami",
            "spacecoast", "staugustine", "tallahassee", "tampa", "treasure",
            "westpalmbeach", "albanyga", "athensga", "atlanta", "augusta",
            "brunswick", "columbusga", "macon", "nwga", "savannah",
            "statesboro", "valdosta", "honolulu", "boise", "eastidaho",
            "lewiston", "twinfalls", "bn", "chambana", "chicago", "decatur",
            "lasalle", "mattoon", "peoria", "rockford", "carbondale",
            "springfieldil", "quincy", "bloomington", "evansville",
            "fortwayne", "indianapolis", "kokomo", "tippecanoe", "muncie",
            "richmondin", "southbend", "terrehaute", "ames", "cedarrapids",
            "desmoines", "dubuque", "fortdodge", "iowacity", "masoncity",
            "quadcities", "siouxcity", "ottumwa", "waterloo", "lawrence",
            "ksu", "nwks", "salina", "seks", "swks", "topeka", "wichita",
            "bgky", "eastky", "lexington", "louisville", "owensboro", "westky",
            "batonrouge", "cenla", "houma", "lafayette", "lakecharles",
            "monroe", "neworleans", "shreveport", "maine", "annapolis",
            "baltimore", "easternshore", "frederick", "smd", "westmd",
            "boston", "capecod", "southcoast", "westernmass", "worcester",
            "annarbor", "battlecreek", "centralmich", "detroit", "flint",
            "grandrapids", "holland", "jxn", "kalamazoo", "lansing",
            "monroemi", "muskegon", "nmi", "porthuron", "saginaw", "swmi",
            "thumb", "up", "bemidji", "brainerd", "duluth", "mankato",
            "minneapolis", "rmn", "marshall", "stcloud", "gulfport",
            "hattiesburg", "jackson", "meridian", "northmiss", "natchez",
            "columbiamo", "joplin", "kansascity", "kirksville", "loz", "semo",
            "springfield", "stjoseph", "stlouis", "billings", "bozeman",
            "butte", "greatfalls", "helena", "kalispell", "missoula",
            "montana", "grandisland", "lincoln", "northplatte", "omaha",
            "scottsbluff", "elko", "lasvegas", "reno", "nh", "cnj",
            "jerseyshore", "newjersey", "southjersey", "albuquerque", "clovis",
            "farmington", "lascruces", "roswell", "santafe", "albany",
            "binghamton", "buffalo", "catskills", "chautauqua", "elmira",
            "fingerlakes", "glensfalls", "hudsonvalley", "ithaca",
            "longisland", "newyork", "oneonta", "plattsburgh", "potsdam",
            "rochester", "syracuse", "twintiers", "utica", "watertown",
            "asheville", "boone", "charlotte", "eastnc", "fayetteville",
            "greensboro", "hickory", "onslow", "outerbanks", "raleigh",
            "wilmington", "winstonsalem", "bismarck", "fargo", "grandforks",
            "nd", "akroncanton", "ashtabula", "athensohio", "chillicothe",
            "cincinnati", "cleveland", "columbus", "dayton", "limaohio",
            "mansfield", "sandusky", "toledo", "tuscarawas", "youngstown",
            "zanesville", "lawton", "enid", "oklahomacity", "stillwater",
            "tulsa", "bend", "corvallis", "eastoregon", "eugene", "klamath",
            "medford", "oregoncoast", "portland", "roseburg", "salem",
            "altoona", "chambersburg", "erie", "harrisburg", "lancaster",
            "allentown", "meadville", "philadelphia", "pittsburgh", "poconos",
            "reading", "scranton", "pennstate", "williamsport", "york",
            "providence", "charleston", "columbia", "florencesc", "greenville",
            "hiltonhead", "myrtlebeach", "nesd", "csd", "rapidcity",
            "siouxfalls", "sd", "chattanooga", "clarksville", "cookeville",
            "jacksontn", "knoxville", "memphis", "nashville", "tricities",
            "abilene", "amarillo", "austin", "beaumont", "brownsville",
            "collegestation", "corpuschristi", "dallas", "nacogdoches",
            "delrio", "elpaso", "galveston", "houston", "killeen", "laredo",
            "lubbock", "mcallen", "odessa", "sanangelo", "sanantonio",
            "sanmarcos", "bigbend", "texoma", "easttexas", "victoriatx",
            "waco", "wichitafalls", "logan", "ogden", "provo", "saltlakecity",
            "stgeorge", "burlington", "charlottesville", "danville",
            "fredericksburg", "norfolk", "harrisonburg", "lynchburg",
            "blacksburg", "richmond", "roanoke", "swva", "winchester",
            "bellingham", "kpr", "moseslake", "olympic", "pullman", "seattle",
            "skagit", "spokane", "wenatchee", "yakima", "charlestonwv",
            "martinsburg", "huntington", "morgantown", "wheeling",
            "parkersburg", "swv", "wv", "appleton", "eauclaire", "greenbay",
            "janesville", "racine", "lacrosse", "madison", "milwaukee",
            "northernwi", "sheboygan", "wausau", "wyoming", "micronesia",
            "puertorico", "virgin", "brussels", "bulgaria", "zagreb",
            "copenhagen", "bordeaux", "rennes", "grenoble", "lille", "loire",
            "lyon", "marseilles", "montpellier", "cotedazur", "rouen", "paris",
            "strasbourg", "toulouse", "budapest", "reykjavik", "dublin",
            "luxembourg", "amsterdam", "oslo", "bucharest", "moscow",
            "stpetersburg", "ukraine", "bangladesh", "micronesia", "jakarta",
            "tehran", "baghdad", "haifa", "jerusalem", "telaviv", "ramallah",
            "kuwait", "beirut", "malaysia", "pakistan", "dubai", "vietnam",
            "auckland", "christchurch", "wellington", "buenosaires", "lapaz",
            "belohorizonte", "brasilia", "curitiba", "fortaleza",
            "portoalegre", "recife", "rio", "salvador", "saopaulo",
            "caribbean", "santiago", "colombia", "costarica", "santodomingo",
            "quito", "elsalvador", "guatemala", "managua", "panama", "lima",
            "puertorico", "montevideo", "caracas", "virgin", "cairo",
            "addisababa", "accra", "kenya", "casablanca", "tunis"]

  def self.search opts
    new(opts).search
  end

  attr_reader :items
  attr_reader :rss
  attr_reader :opts
  attr_reader :urls

  # Public: new instance to search craigslist.
  #
  # opts - Hash of values to either pass to craigslist or use.
  #        :cities - Array of cities to search in (default ['reno']. See
  #                  CITIES.
  #        :group - String of either all, owner, or dealer (default all).
  #
  #        all other opts are defined by craigslist's API.
  def initialize opts
    my_opts = opts.dup
    my_opts.delete :format

    @cities = my_opts.delete(:cities)|| ['reno']
    @group  = my_opts.delete(:group) || 'all'
    @opts   = my_opts
    @items  = []
  end

  # Public: search craigslist.
  def search
    @items.clear

    @urls = @cities.map do |city|
              "http://#{city}.craigslist.org/search/#{group}?#{@opts.to_query}&format=rss"
            end

    @urls.each do |url|
      open(url) do |rss|
        @items << Feedjira::Feed.parse(rss.read).entries
        p @items
      end
    end

    @items.flatten!

    self
  end

  def group
    {
      'all'   => 'sss',
      'owner' => 'sso',
      'dealer'=> 'ssq',
    }[@group]
  end

end
