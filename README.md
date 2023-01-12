# MovieStar
MovieStar is an IOS application for listing current movies. You can add your favorite movies to the favorite list and also you can discover new recomended movies or actors in app. This app use TMDB API's

For first run the app on your system follow these steps;

1. Clone the branch to your mac. This method will keep the files in an updatable structure.

1.1. You must be sure the cocoapods are already installed on your system. If the cocoapods are not installed yet, you should to be add cocoapods firstly. Other steps are accepted with cocoapods already installed. If you don't know how to add cocoapods to your system you can check this link: https://stackoverflow.com/questions/20755044/how-do-i-install-cocoapods

2. Run the terminal. Do not open the xCode when you before the 7th step. 

3. Find the folder where you cloned the files via Finder, find the FilmListem folder without accessing the file contents.

4. Write on the terminal "cd" add space and drag and drop your FilmListem file to your terminal window. Then, press enter. 

5. After that, write "pod init" on your terminal then press the enter. 

6. When pod initilized, again write "pod install" on your terminal.

7. When installation was complete, you can run your app with the .xworkspace extension. Don't use the .xcodeproj version, If you use this version probably you can't see the images, labels or another data which one is pulled on the API or xCode throw an error.

8. Go to "Links" file in the xCode and find the "api" constant and add your api key which one is taken on themoviedb.org website. If you don't have an API key on tmdb you can get your own with these link: https://developers.themoviedb.org/3/getting-started/authentication  

9. If you think had a problem about the code you can contact with me. 
