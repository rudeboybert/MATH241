Grammar of Graphics Revisited
========================================================
author: Albert Y. Kim
date: Monday 2015/04/27



Administrative Notes
========================================================

* Juniors and younger:  new course next year [MATH 243](http://academic.reed.edu/math/courses.html) Statistical Learning.  This will be about machine learning on [big data](http://cdn.meme.am/instances/500x/47510205.jpg).
* Andrew Bray giving a [talk](http://academic.reed.edu/math/seminars/index.html) this Thursday at 4:10 in Physics 123.



London Underground Map
========================================================

Behold, [the London Underground map](https://www.tfl.gov.uk/cdn/static/cms/documents/standard-tube-map.pdf), in all of its glory!



Iterating to Perfection
========================================================

* [Original Map?](http://i.guim.co.uk/static/w-1920/h--/q-95/sys-images/Guardian/Pix/pictures/2009/11/25/1259167036833/London-Underground-Maps-008.jpg)
* [Round 2](http://i.guim.co.uk/static/w-1920/h--/q-95/sys-images/Guardian/Pix/pictures/2009/11/25/1259167039725/London-Underground-Maps-011.jpg)
* [Harold Beck 1931](http://i.guim.co.uk/static/w-1920/h--/q-95/sys-images/Guardian/Pix/pictures/2009/11/25/1259167037855/London-Underground-Maps-009.jpg)
* [Harold Beck 1936](http://i.guim.co.uk/static/w-1920/h--/q-95/sys-images/Guardian/Pix/pictures/2009/11/25/1259167033647/London-Underground-Maps-005.jpg)



Mapping of Variables to Aesthetics
========================================================

Think in terms of **aesthetics**, as defined by [The Grammar of Graphics](http://www.cs.uic.edu/~wilkinson/TheGrammarOfGraphics/GOG.html)

* **color of line**: which line of underground (Bakerloo, Picadilly, Northern, etc.)
* **type of point**: standard station vs interchange station
* **(x, y) position and line**: relative ordering of stations, *NOT* actual geographic location of station.
* **blue lines**: River Thames



(x,y) Position and Line
========================================================

The (x,y) positions on the map are distortions of the actual locations.  Check out the geographically faithful [map](http://www.creativedataprojects.com/wp-content/uploads/2011/06/real-tube-map-1.gif).




(x,y) Position and Line
========================================================

The Beck map:

* Compresses geographically spread out suburban stations
* Expands out geographically compressed urban stations
* **Most importantly**:  it only uses straight lines at 45 and 90 degree angles.



Subway Map Convention
========================================================

Almost every subway map in the world follows this format.

* [Paris](http://parisbytrain.com/wp-content/uploads/2014/08/paris-metro-map.jpg)
* [Seoul](http://cdnstatic-2.mydestination.com/seoul/Pictures/Pages/Maps/seoul-subway-map.gif)
* [Moscow](http://thecityfix.com/files/2014/03/Moscow-metro-map.gif)

Brain Candy:  Cameron Booth's [Interstate subway map](http://cdn.visualnews.com/wp-content/uploads/2012/02/USInterstatesasaSubwayMap_4f32a6dc9a6f0.jpg)



Exercise
========================================================

Open `dataset.csv` on Moodle or [GitHub](https://raw.githubusercontent.com/rudeboybert/MATH241/master/Lec34%20Grammar%20of%20Graphics%20Revisited/dataset.csv), load in R, and for each of the 4 levels of `group`:

* Compute the means and sd's for both x and y
* Compute the correlation coefficient between x and y using the cor() function
* Get the coefficients of the linear regression y~x.



Anscombe's Quartet
========================================================

This dataset is known as [Anscombe's Quartet](http://en.wikipedia.org/wiki/Anscombe's_quartet) which has near identical summary statistics (means, standard deviations, correlation coefficients, and regression coefficient).

They were developped to demonstrate both the importance of graphing data before analyzing it and the effect of outliers on statistical properties.



PLOS Biology Paper
========================================================

Go to my Twitter account and check-out my retweet of [@rhobott](https://twitter.com/RhoBott) of a [PLOS Biology paper](https://twitter.com/RhoBott/status/591283297365327872).



Example
========================================================

Adriana Escobedo-Land's thesis:

* Let's consider her [problem](https://github.com/rudeboybert/MATH241/blob/master/Lec34%20Grammar%20of%20Graphics%20Revisited/adriana/ARA%20details.txt):
* Analysis


Some Nice Morals
========================================================

* [Don't fear simplicity](https://twitter.com/kevin_c_chen/status/462254750109802496)
* It's a question of tools
    + You can't use a water bottle to extinguish a forest fire.
    + You don't need a fire hydrant to extinguish a candle.


