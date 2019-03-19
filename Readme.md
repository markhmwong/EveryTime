
# Update Log

## Version 1.1

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

### To do

- minor ui adjustments (colours to suit the logo)
- repeat (toggle) (auto reset)
- pause in recipe view
- redo the add step/add recipe UI
