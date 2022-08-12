
# Project - *Vegan-Food-Finder *


## Description:
Vegan Restaurant Finder is an app that helps people looking for vegan restaurants. The app utilizes yelp api to get List of vegan restaurants. The user can ask the app to recommend them a good restaurant based on weights that user pickles, when the user is in a different time zone they can check the operating hours of the restaurant at any given date, from there user can navigate to create an event and then store it in the calendar view(the event is also deletable). User can also get the directions to the restaurant by using apple’s native maps app

**Mvp**

- [x]User can sign up to create a new account by using authentication tools
- [x]User can login/logout from the account 
- [x]User can see the Home view content with its content
- [x]User can see the search view content with it’s content 
- [x]User can also view calendar
- [x]User can tap search to look for restaurants and narrow down to the desired restaurant
- [x]User can view different categories as they navigate the search view
- [x]After hitting on a restaurant user will be able to see detailed view of the restaurant
- [x]See Tweet details in a Details view
- [x]In Details view user can see can a see the address, contacts,operating hours, feedback from previous customer 
-[x]View controller that handles the recommendation algorithm 

The following **stretch** features are implemented:

**Stretches**
- [x]Favo restaurants View(Will show only liked restaurants on this view)
- [x]Placing the Favorite restaurant on the top the list of restaurants by liking 
- [x]User will be able to undo like by sliding the restaurant row to the right

**Milestones**
- [x]Create login/logout Authentication is done by using backend database
- [x]After login or sign and being authenticated HomeView should fetch the data and display it 
- [x]recommendation feature for suggestion of a good restaurant based on the weight they provide for each scale
- [x]integrate calendar kit and event kit
- [x]User can delete and add events to the calendar
- [x]categorize restaurants based on price, rating, adn distance in the SearchView. 
- [x]Create an favo view for liked restaurants 
- [x]Create details view for when a restaurant is taped on to show the details of the restaurant 
- [x]Create datepicker view that allows users to pick a date and then check the operating hours of the restaurant
- [x]Allow the user to check the restaurant’s operating hours based on their timezone 

**Ambiguous Problems**
- [x]Recommendations View: build and implement an algorithm where if the user asks for a restaurant recommendation, the app will recommend a restaurant by gathering the data from all the restaurants within a certain distance to run the algorithm that will compare them based pricing, distance, and ratings.

- [x]Date manipulation: manipulate the time strings that were provided by the api to convert dates between different time zones to allow the user to check the operating hours of the restaurant based on their local time.
- 
**Screen Archetypes**
* Login Screen
 Users login here or navigate to the sign up View

* SignUp Screen
 Users can create an account
* Home Screen
 User can view the vegan based restaurants that are provided 
* User can get directions to any of the restaurants
Search Screen
* User can view all restaurants
* User can use both text and scope button filtration to narrow down the search 
* Details Screen
 User can view the details of the chosen restaurant
* Recommendations Screen
 User can use the recommendation feature to get a restaurant
* LikedRestaurants Screen
 User can view their liked restaurant 
* Calendar Screen 
 User can create/delete/edit events and store them
* date Picker Screen 
 User can pick any date to check what are the operating hours(in the user’s time Zone) and (restaurant’s time zone)

## Video Walkthrough
Here's a walkthrough of implemented user stories:

https://drive.google.com/drive/folders/1QG1FowZGwlOxKi0paaLtCNPoVCNkPI6j?usp=sharing
