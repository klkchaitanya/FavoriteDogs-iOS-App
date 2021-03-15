
FAVORITE DOGS APP

DESCRIPTION
-----------
This IOS application displays the user, photos of the dogs of selected dog breed. Users can add photos to their favorites list and view all their favorite dog photos at one place. They can remove photos from favorites if they change their mind!


IMPLEMENTATION
--------------
The entry screen of the application consists of a Tab view controller with two tabs: ‘Dog Breeds’ and ‘Favorite Dogs’ 1) Dog Breeds View Controller: This view calls the Dog API, gets the list of all dog breeds and displays them in a list in Table View. On selecting one of the dog breeds, app navigates to 'Breed Collection View' screen which displays images of the dogs of selected breed. 
2) Breed Photo Collection View Controller: This view displays a list of images of the selected dog breed in a collection view. All images in collection view have a place-holder and this view displays alert whenever there is a problem with internet connection. Here, users can add images to their favorites list. On selecting the image, the app adds the image to the persistence storage, displaying an alert that image has been saved. Same image cannot be added to persistence storage more than once. If tried to add duplicate, app displays an alert saying that ‘Image already exists in favorites'. 3) Favorite Dogs collection view: This is second tab of the entry screen of the application. This view queries the persistence storage for saved dog images and displays them in a collection view. Users can delete the favorite images by tapping on them. On selecting an image, it is deleted from the persistence storage and displays an alert saying that image has been deleted. If no images are found in persistence storage, it displays a label that ‘No Images are found’ in the background of collection view.Favorite dog app displays alerts when there is no internet connection and displays a message in background, if internet connection is so slow. Also displays alerts when there is a failure receiving response from Dog-API.
FEATURES/FRAMEWORKS
-------------------
- Favorite dogs app uses Core data persistence framework to save data. All images are saved to core data when added to favorites list. Core data model is in the file 'FavoriteDogs.xcdatamodeld' and data controller code is implemented in 'Controller/DataController.swift'. 
- Favorite Dogs app uses Dog-API https://dog.ceo/dog-api/ to get list of various dog breeds and images of the selected dog breed. The Dog-API network communication code is all encapsulated in 'Client/DogClient.swift' file.


APIs
----
Dog API - https://dog.ceo/dog-api/


HOW TO BUILD
------------
1) Clone or download this repository as zip file
2) Open 'FavoriteDogs.xcodeproj' file in XCode
3) Build and run project!


REQUIREMENTS
------------
Xcode 10.3+
Swift 5+


LICENSE
-------
klkchaitanya/FavoriteDogs-iOS-App is licensed under the Apache License 2.0