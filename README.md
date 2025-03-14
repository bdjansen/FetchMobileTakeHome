# ``RecipesTests``

### Summary: Include screen shots or a video of your app highlighting its features

Thank you for the opportunity to showcase this application to Fetch!

The main functionality of the app is to load and display the list of recipes. 

<img src="https://github.com/user-attachments/assets/ab34741e-8456-4006-881c-82f0942ee368" width="200" />

I added the ability to refresh the list based on the requirements of the project.

<img src="https://github.com/user-attachments/assets/97845b9f-ae27-495e-bde4-c772d0c4b685" width="200" />

I added the ability to filter recipes based on the name or cuisine using a search bar.

<img src="https://github.com/user-attachments/assets/295ecea9-e1f7-49fa-9f9f-f9d7f2244610" width="200" />

I added an error state for network errors.

<img src="https://github.com/user-attachments/assets/6f8edee5-f53e-47aa-81f1-06156865fd32" width="200" />

I added a state for empty recipe lists, also as an error state.

<img src="https://github.com/user-attachments/assets/d8a3b859-2045-4b37-805e-57509333b7ef" width="200" />

I wanted to add swipe actions to support linking source and youtube to Safari, but I wrote more about being unable to use ``List`` in the tradeoffs section.

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I focused primarily on the architecture to make it simple and testable. I started with the API abstractions and repositories to provide easy data access for views. I created view models to provide view state and hide dependency usage from the SwiftUI view classes. I believe the most important aspect for the health of a codebase is for it to be easy to read, test, and change.


### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
I spent about 6 hours on this project including testing and documentation. I wrote tests as I developed components. Notes:
* I spent 1 hour on data layer, including initial architectural setup and API calls.
* I spent the next 2 hours setting up the viewmodels and views. This includes deciding which features I wanted to include within the app.
   * This also includes playing with extra features. Filtering made it through the final result, but I also tried showing a detail view and swipe actions. I removed the detail view after re-reading the instructions ("one screen") and did not want to use ``List`` because I did not want bugs in the "production" version of this.
* I spent 2 hours strictly on image caching with CoreData. I initially started with NSCache to get the logic functional, but this was my first time using CoreData to implement caching with persistence. This also included the time to learn how to use CoreData.
* I spent 1 hour on refactoring, GitHub setup, and documentation.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
* I initially wanted to use ``List`` as the main layout of the view, but I was having bugs in iOS 16 with the ``.task`` modifier. Some cells were not receiving the modifier, so they were failing to load any image. I ended up using ``LazyVStack`` instead. I initially wanted to use ``swipeActions`` as a way to incorporate the url links, but this modifier does not work with stack views. I preferred having it work without bugs rather than have a choppy experience with an extra feature.
* I debated having the RecipeListViewModel map the recipes to a list of cell view models, but figured having them be created as the lazy stack created cells would save on memory.
* I chose to use an actor for the ``ImageCache`` to show that I understand the purpose and benefit of the actor type. In theory if a thread tried to get an image from the cache while the cache was setting the same image key, it would result in a cache hit. I debated making the repository an actor as well, but I did not want separate image loads to be waiting on each other.
* I chose not to save the persistance container for the ``ImageCache`` because I wanted to make sure it uses the network call on app start.

### Weakest Part of the Project: What do you think is the weakest part of your project?
Architecturally, I think the weakest part of my project is the ImageCache, mostly from my inexperience with CoreData. I tested to make sure everything was functional with caching, but I believe if I spent more time with the library I would find a more modern approach to using it. Getting it functional was my top priority, so I am still happy with the result.

Visually, the weakest part of the app are the error states. I added the error states to show I considered them, but did not want to spend extra time improving the UX and seem like I was spending too much time on the exercise.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
I initially had a ``RecipeListService`` to add a business logic layer to separate the data and view layers. I opted against because the only benefit would be pulling which photo type to use with a ``getImage(recipe:)`` function. With the size of the app, I did not think this was worth it.
