# Requires `/lyt`  
# Requires `/support/globals/log`  

# -------------------

# This file contains various configuration options for different parts of the app

# ## The level of logging:  
#     0 = No logging
#     1 = Errors
#     2 = Errors & warnings
#     3 = Errors, warnings, and messages (default)
#

# ## Central system configuration
LYT.config =
  
  # ### LYT.rpc function config
  rpc:
    # The service's server-side URL
    url: "/DodpMobile/Service.svc" # No default - must be present
  
  # ### LYT.protocol config
  protocol:
    # The reading system attrs to send with
    # the `setReadingSystemAttributes` request  
    # (No default - must be present)
    readingSystemAttributes:
      manufacturer: "NOTA"
      model:        "LYT"
      serialNumber: "1"
      version:      "1"
      config:       null
  
  # ### LYT.service config
  service:
    # The number of attempts to make when logging on
    # (multiple attempts are only made if the log on
    # process fails _unexpectedly_, i.e. connection
    # drops etc.) . If the server explicitly rejects
    # the username/password, `service` won't stupidly
    # try the same combo X more times.
    logOnAttempts: 3 # default: 3
    guestUser: "guest"
    guestLogin: "guest"
  
  # ### LYT.book module config

  book:
    states:
      pending:    'InProduction'
      available:  'Available'
      
  # ### LYT.bookshelf module config
  bookshelf:
    # Number of books to load per page
    pageSize: 5 # default: 5
    # Number of books to show on bookshelf (whitout show more)... 
    maxShow: 20


  mobileMessage:
    GetVersion:
      url: "/mobileMessage/MobileMessage.svc/GetVersion"
    NotifyMe:
      url: "/mobileMessage/MobileMessage.svc/NotifyMe"
    LogError:
      url: "/mobileMessage/MobileMessage.svc/LogError"


  # ### LYT.google config
  google:
    # Autocomplete options
    autocomplete:
      # The URL to request results from
      url: "http://suggestqueries.google.com/complete/search?output=chrome&hl=dk&q="
  
  # ### LYT.catalog config
  catalog:
    # Full (free text) search options
    search:
      url: "/CatalogSearch/search.asmx/SearchCatalog" # No default - must be present
      pageSize: 10 # Default: 10
    
    # Autocomplete options
    autocomplete:
      # The URL to request results from
      url: "/CatalogSearch/search.asmx/Autocomplete" # No default - must be present
      
      # The options to pass to jQuery UI's `.autocomplete()`
      options:
        # Minimum length of text before autocompleting
        minLength: 2   # default: 1
        
        # Delay before autocompleting (milliseconds)
        delay:     300 # default: 300
    
    suggestions:
      url: "/CatalogSearch/search.asmx/GetPushItems"
    
    details:
      url: "/CatalogSearch/search.asmx/GetItemById"
  
  # ### LYT.player config
  player:
    # The minimum time between lastmark updates (milliseconds)
    lastmarkUpdateInterval: 10000 # Default: 10000 (i.e. 10 secs)
    playAttemptLimit: 10
    # Fakeend disabled because it triggers a race condition in
    # the section loading code.
    useFakeEnd: false
    readSpeed:
      slow:         0.5
      normal_slow:  0.8
      normal:       1
      normal_fast:  1.5
      fast:         2
      fast_extra:   2.5
      fast_ultra:   3
      ultra_fast:   4

  segment:
    preload:
      queueSize: 3
    imagePreload:
      timeout: 1000000000
      attempts: 5
  
  # ### LYT.DTBDocument config
  dtbDocument:
    # Whether to use the `forceclose=true` parameter
    useForceClose: yes # Default: yes
    # Number of attempts to make when fetching a file
    attempts:      3   # Default: 3
  
  # ### LYT.NCCDocument config
  nccDocument:
    metaSections:
      # Note: the format is "attribute value": "attribute type"
      "dbbintro":        "class" # elements whose `class` attribute is "dbbintro"
      #"dbbcopyright":    "class" # elements whose `class` attribute is "dbbcopyright"
      #"rearcover":       "class" # elements whose `class` attribute is "rearcover"
      #"summary":         "class" # elements whose `class` attribute is "summary"
      #"rightflap":       "class" # elements whose `class` attribute is "rightflap"
      #"leftflap":        "class" # elements whose `class` attribute is "leftflap"
      #"extract":         "class" # elements whose `class` attribute is "extract"
      #"authorbiography": "class" # elements whose `class` attribute is "authorbiography"
      #"title":           "class" # elements whose `class` attribute is "title"
      
      #"GBIB":     "ref"   # elements whose `ID` attribute is "GBIB"
      #"GINFO":    "ref"   # elements whose `ID` attribute is "GINFO"
      #"GFLAP":    "ref"   # elements whose `ID` attribute is "GFLAP"
  
  # default page redirect page
  defaultPage:
    hash: '#bookshelf'