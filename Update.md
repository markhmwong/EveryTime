
# Update Log

### To do
Clean up each file
Progress
    - AboutViewController (done)
    - Cells (maybe not as i'm redesigning the entire view into a modal sheet)
    - MainViewController (done)
    - Separate timer
    - RecipeViewController

## Version Features
- clean up code 1.1.5
- redo the add step/add recipe UI 1.1.5
- swipe to reset (mainview cell and recipeview cell)


- apple watch 1.2
- be able to pause in the recipe detail view 1.2
- repeat (toggle) (auto reset) 1.2 - be weary of local notifications, new ID system
- allow user to choose sound 1.2
- choose notifications on/off in the app 1.2
- theming 1.3

- tags for easier step adding 1.3
- dark mode 1.3

### Far future
- cross step notifications
- simultaneous steps?

## Version 1.1.1
- House cleaning
- Main View UI Adjustments
    - larger font for clarity
    - dark green tinted font
    - Added highlight to time
    - Start button now has border
    - cell view highlighted when selected


## Version 1.1 20/3/2019

### Fixed

- An error occured when a recipe that is paused, reset, then unpaused, caused the timer to continue without taking into account the pause interval
    Fixed by ensuring the it is updated when the reset and unpause buttons are handled.
- The timer did not begin again when transitioning to and from the About page. There was a call to stop the timer on the home view but starting the timer again was not called. The delegate is now used to access the start timer call.
- Completion indicator on step cell made larger for easier viewing
- Sound now plays for the last step
- Step options menu now functions appropriately - by appearing and hiding in it's proper states.
    The step options menu disappeared on the initial touch and would not return but the following touches responded normally. Fixed by updating the state on the main thread when the button is pressed
- In the Recipe View Controller, the top right buttons have been replaced by one button that presents an action sheet with more options to apply to the Recipe. The old buttons (edit, reset, delete) have now migrated here.
- Some small internal house cleaning
- Adjusting the timer +15/-15 seconds was clumsy, now shows the correct time between two views.
- Background timer not working for Recipe View Controller. Add the same update method from main view to recipe view (happens when the user sets the application into the background and returns)
- Added a top summary view of the recipe in the recipe detail page.
- Check local notifications

### App Store What's New
Quick Update
• Notifies when the recipe is complete
• Calculation fixes regarding the timers when pausing and running in the background
• Summary space on Recipe details page
• UI adjustments, text spacing and sizes

Full details
• Local notifications added, triggers when a Recipe is complete
• Pause bug occurs when the user pauses then resets and then returns to the main view to unpause. It now calculates the time properly
• Time adjustment +15/-15, now working as intended
• Timer now runs in background when on the Recipe detail page. In 1.0, the algorithm didn't work as intended
• Bundled edit, delete, reset buttons on the Recipe detail page in one button to show an action sheet. Before there were three buttons littered on the top right
• Added a top tableview header summary on the Recipe detail page showing the current step title and time and the next step title and time
• Bottom menu animation logic now improved. Initial interactions had the step options not reveal itself unless scrolled
• Completion dot now made larger, before it was the size of an atom
• The Recipes now continue to run when returning from the About page previously the Recipes would halt when viewing the about page and returning to the main view
• Alert now plays even when the step is offscreen on the Recipe detail page and on the last step after completion, previously it didn't play on the final step
