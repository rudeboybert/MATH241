Grammar of Graphics Revisited
========================================================
author: Albert Y. Kim
date: Monday 2015/04/27



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

The (x,y) positions on the map are distortions of the [actual locations](http://www.creativedataprojects.com/wp-content/uploads/2011/06/real-tube-map-1.gif).  The Beck map:

* Compresses geographically spread out suburban stations
* Expands out geographically compressed urban stations
* **Most importantly**:  it only uses straight lines at 45 and 90 degree lines.



Subway Map Convention
========================================================

Almost every subway map in the world follows this format.

* [Paris](http://parisbytrain.com/wp-content/uploads/2014/08/paris-metro-map.jpg)
* [Seoul](http://cdnstatic-2.mydestination.com/seoul/Pictures/Pages/Maps/seoul-subway-map.gif)
* [Moscow](http://thecityfix.com/files/2014/03/Moscow-metro-map.gif)

Brain Candy:  Cameron Booth's [Interstate subway map](http://cdn.visualnews.com/wp-content/uploads/2012/02/USInterstatesasaSubwayMap_4f32a6dc9a6f0.jpg)


