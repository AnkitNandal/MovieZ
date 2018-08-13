# Moviez
Moviez is a sample to show how we should use searchbar to fetch anything from net online.

# Architecture
  -MVVM
  -MVC
  
# WebServices Interaction:
1) Each web service is processed under NSOperation Call that processes initial request and later on handover to Network Core Classes.

Example:

       # KSearchOperation
        # KServiceOperation
	        # KBaseOperation


  #KServiceOperation: Network Call/callback are handled here.


# URL Handler Core Classes:
Separate dedicated classes are designed to incorporate any changes that are handled at each level.

         KService
         KResponse
         RequestBody
         KRequest
         NetworkError
         KServiceConfig.