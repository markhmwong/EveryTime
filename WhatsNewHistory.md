## Version 1.1.16
- All new theming feature beginning with Dark Mint as our first new theme. Dark Mint brings a darker colour palette bringing easier viewing at night and less eye strain. This update will begin a series of new themes for the future.

## Version 1.1.15
- Add Start/Pause Button to fullscreen mode
- Internal house keeping that you won't see
- Minor UI Improvements

## Version 1.1.14

Minor UI Changes - You may notice slight changes to fonts, colours and layout. Any major changes will be listed
Existing and new steps can now be edited
New Recipe options menu
Steps have the ability to either skip a step or return to the previous step while in full screen mode
While creating a new Recipe, it is now easier to recreate existing steps by using the copy button
New Recipes will now show the correct step name rather than an unknown

## Version 1.1.13 

Major Updates
Full screen view
The Recipe view now contains a button for a full screen view of the header view that shows the current timer. The new feature contains a minimal design of larger text for clarity with details of the current step and next step.
Adding Recipe
When creating a new Recipe, you can now chose whether the timer starts immediately or later
Revamped the UI in this section
Whats New
You'll find this within Settings. With a list of all the relevant updates made.
Minor Updates
Email feedback in support now added
Minor UI changes throughout the app

Bugs
When adding a new step, the value would be 0 despite a different value selected on the picker. It now correctly displays the correct values and does not "reset" to 0.

## Version 1.1.12
Adding Recipe/Steps
- Textfields now have a default value
- Keyboard is now removed from selecting hours/minutes/seconds in favor of the picker view
Main View    
- The current working step now appears on the main view
- Adding a recipe now moved to the top right navigation bar and removed from the bottom
- Clearing all recipes is now located within Settings
Other
- Typo in settings caption


## Version 1.1.11
Taptic Feedback
- Now on pause buttons
Recipe View
- Pause Button replaces add recipe
- "Add Recipe" moved within Settings
- You can now swipe to reset and swipe to delete a step
Add Step
-  Pressing done now submits new step
iPhone 5 screen size support
- Fixed unintended overlapping text and buttons throughout the app
- Overlay view for adding steps/receips increased to support height of device

## Version 1.1.1
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

