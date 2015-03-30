Shiny Apps
========================================================
author: Albert Y. Kim
date: Monday 2015/03/30




Creating Web Apps via Shiny
========================================================

Today we will create **interactive** web applications via Shiny.  Shiny allows you to do so
without knowing HTML, JavaScript, CSS, etc...

We won't be harnessing the full power of Shiny (i.e. using `server.R` and `ui.R` files),
but rather a simplified version using R Markdown.

For a tutorial on using Shiny fully see
[http://shiny.rstudio.com/tutorial/](http://shiny.rstudio.com/tutorial/).



Example
========================================================
Rich Majerus is Vice President of Research of [Third Coast Analytics](http://www.thirdcoastanalytics.com/): a consulting company which provides statistics, analysis, and data management services for higher education.

Go to the webpage and click on the map on the bottom left of the page.  This was made via Shiny.



Chief Components
========================================================

There are two chief components building a Shiny app:

* `inputPanel`:  Where your app takes **inputs** and stores them in an object called `input`.  Ex: text, numerical values, sliders, radio buttons, etc.
* `renderSOMETHING`: After processing the inputs and data, Shiny **renders** an output: plots, table, text, etc.





Create New Shiny App
========================================================

* Install and load the `shiny` package
* Go to File -> New File -> R Markdown -> Shiny
* Select "Shiny Document"
* Create a new directory and save the .Rmd file in that directory
* Click "Run Document"
* Focus only on the "Inputs and Outputs" example



Example:  Input Panel
========================================================

The `inputPanel( ... )` section takes in two inputs (separated by a comma):

* `selectInput()` which assigns a value to `n_breaks` based on a selection menu, formats the input box, and selects 20 as the default option.
* `sliderInput()` which assigns a value to `bw_adjust` based on a slider, formats the input box, and sets 1 as the default value.




Example:  Input Panel
========================================================

Note:

* All possible `inputPanel()` options are listed in "Widgets" on the cheatsheet.
* Type `?selectInput`, for example, to get a sense for the arguments.



Example:  Rendering Output
========================================================

The `renderPlot({ ... })` plots a histogram of the `eruptions` from the Old Faithful Geyser data set `faithful`.

Note:

* The inputted `n_breaks` and `bw_adjust`, are stored within the `input`.  For example, to interactively use `n_breaks`, we need to specify `input$n_breaks`.
* There are curly braces in the `renderPlot({})`
* All possible rendering options are listed in "render functions" on the cheatsheet
* Each type of rendering must be done separately



Exercise
========================================================

Add a menu input option that allows you to specify the color of the smoother line.



Publishing on the Web
========================================================

* Go to [https://www.shinyapps.io/](https://www.shinyapps.io/) and create an account.
* Go to [https://www.shinyapps.io/admin/#/dashboard](https://www.shinyapps.io/admin/#/dashboard) and complete Steps 1-3.
* In your outputed Shiny app pop-up page, click on "Publish" on the top right.



















