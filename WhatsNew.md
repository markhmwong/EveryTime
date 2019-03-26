#  Whats New Description for App Store

## Version 1.1.2 To Be Done
Recipe View
    - Pause Button repalces add recipe
    - Add Recipe moved within Settings

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