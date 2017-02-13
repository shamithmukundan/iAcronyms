# iAcronyms

iPhone app to look up meanings of Acronyms or Initialisms.

Carthage is used as dependency manager with the following project

1. AFNetworking
2. MBProgressHUD

To run project 

1. Ensure carthage is installed. Else download and install pkg from https://github.com/Carthage/Carthage/releases
2. Via terminal run the following command at root of project.

    `carthage update --platform iOS`
    
    This command will download the AFNetworking and MBProgressHUD framework at iAcronyms/Carthage/Build/iOS/
3. Run the build via xCode.

App supports iOS 10.0 and later.

Details of api which is used to fetch the meanings is given below.

http://www.nactem.ac.uk/software/acromine/rest.html

==============================================================================

Launch of the app will take you to "Search Definitions" screen
Search of valid acronyms/initialisms will show results.
If any result has variations, selection of the cell will take you to the "Variations" screen.

==============================================================================
