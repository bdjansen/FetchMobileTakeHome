# ``RecipesTests``

### Summary: Include screen shots or a video of your app highlighting its features
* The main functionality of the app is to load and display the list of recipes. I added the ability to refresh the list based on the requirements of the project.
* I added the ability to filter recipes based on the name or cuisine using a search bar.

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I focused primarily on the architecture to make it simple and testable. I believe the most important aspect for the health of a codebase is for it to be easy to read and change.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
I spent about six hours on this project including testing and documentation.
* I spent 1 hour on initial architectural setup and data retrieval. The initial app just displayed the recipe list.
* I spent the next 2 hours setting up the viewmodels and views. This included decided which features I wanted to include within the app.
* I spent 2 hours strictly on image caching with CoreData. I initially started with NSCache to get it prepared, but this was my first time using CoreData to implement caching with persistence. I had to spend time learning how to use CoreData.
* I tried to write tests as I planned object functionality.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
* I initially wanted to use ``List`` as the main layout of the view, but I was having trouble in iOS 16 with the ``.task`` modifier. I ended up using ``VStack`` instead.
* I debated having the list view model map the recipes to a list of cell view models, but figured having them be created as more cells are created would save on memory.
* I chose to use an actor for the ``ImageCache`` to show that I understand the purpose and benefit of the actor type. In theory if a thread tried to get an image from the cache while the cache was setting the same image key, it would result in a cache hit. I debated making the service an actor as well, but did not want the image loads waiting for other network calls.
* I chose not to save the persistance container for the ``ImageCache`` because I wanted to make sure it uses the network call on app start.

### Weakest Part of the Project: What do you think is the weakest part of your project?
I Think the weakest part of my project is the image caching, mostly from my inexperience with 

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
