
# Update Log

## To do (Priority list) 
- add recipe tableview white
- email feedback (in info)
- the entire adding process

## To do in near future (not a priority)
- settings button on main view
- section headers for info page
- notifications for recipes toggle
- themes

## Planned Version Features

- clean up code 1.1.5
- redo the add step/add recipe UI 1.2

- apple watch 1.2
- be able to pause in the recipe detail view 1.2
- repeat (toggle) (auto reset) 1.2 - be weary of local notifications, new ID system
- allow user to choose sound 1.2
- choose notifications on/off in the app 1.2
- theming 1.3

- tags for easier step adding 1.3
- dark mode 1.3

- siri shortcuts 1.4

### Far future / conceptual features
- cross step notifications
- simultaneous steps?
- attach music to a certain step

### Requested Main Features
- siri shortucts
- apple watch
- redo adding process (priority!)
- tags
- save recipes to add into other recipes
- save steps to add into other steps


# Version History Log

## Version 1.1.2



## Version 1.1.1 (Submitted 24/3/2019)

- sharing
- App review
- House cleaning
- Main View UI Adjustments
    - larger font for clarity
    - dark green tinted font
    - Added highlight to time
    - Start button now has border
    - cell view highlighted when selected
    - view cleaned up anchors
    - pills for start stop and complete/incomplete steps
AddStep
    - 
Clean up each file
    - Progress
    - AboutViewController (done)
    - Cells (maybe not as i'm redesigning the entire view into a modal sheet)
    - MainViewController (done)
    - Separate timer
    - RecipeViewController (headerview done)
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


