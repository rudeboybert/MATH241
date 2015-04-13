Text Mining Package
========================================================
author: Albert Y. Kim
date: Monday 2015/04/13







Choice of Language Matters
========================================================

[How MLB Announcers Favor American Players Over Foreign Ones](http://www.theatlantic.com/entertainment/archive/2012/08/how-mlb-announcers-favor-american-players-over-foreign-ones/261265/)



Issue with Text Data: Character Encoding
========================================================
Working with text data can be a real PITA, as there are many different [character encodings](http://www.iana.org/assignments/character-sets/character-sets.xhtml), i.e. how characters are represented on a computer.

Converting between them can be a real nuissance as some characters don't translate well, like accented letters, spaces, punctuation.

We'll use UTF-8.



Natural Language Processing
========================================================

Natural language processing (NLP) is a field of computer science, artificial intelligence, and linguistics concerned with the interactions between computers and human (natural) languages.



tm Package
========================================================

The `tm` (text mining) package puts many such tools at our disposal, including

* Word stemming:  constitution, constitutional, constitutions
* stopword removal

```r
stopwords("english")
```

```
  [1] "i"          "me"         "my"        
  [4] "myself"     "we"         "our"       
  [7] "ours"       "ourselves"  "you"       
 [10] "your"       "yours"      "yourself"  
 [13] "yourselves" "he"         "him"       
 [16] "his"        "himself"    "she"       
 [19] "her"        "hers"       "herself"   
 [22] "it"         "its"        "itself"    
 [25] "they"       "them"       "their"     
 [28] "theirs"     "themselves" "what"      
 [31] "which"      "who"        "whom"      
 [34] "this"       "that"       "these"     
 [37] "those"      "am"         "is"        
 [40] "are"        "was"        "were"      
 [43] "be"         "been"       "being"     
 [46] "have"       "has"        "had"       
 [49] "having"     "do"         "does"      
 [52] "did"        "doing"      "would"     
 [55] "should"     "could"      "ought"     
 [58] "i'm"        "you're"     "he's"      
 [61] "she's"      "it's"       "we're"     
 [64] "they're"    "i've"       "you've"    
 [67] "we've"      "they've"    "i'd"       
 [70] "you'd"      "he'd"       "she'd"     
 [73] "we'd"       "they'd"     "i'll"      
 [76] "you'll"     "he'll"      "she'll"    
 [79] "we'll"      "they'll"    "isn't"     
 [82] "aren't"     "wasn't"     "weren't"   
 [85] "hasn't"     "haven't"    "hadn't"    
 [88] "doesn't"    "don't"      "didn't"    
 [91] "won't"      "wouldn't"   "shan't"    
 [94] "shouldn't"  "can't"      "cannot"    
 [97] "couldn't"   "mustn't"    "let's"     
[100] "that's"     "who's"      "what's"    
[103] "here's"     "there's"    "when's"    
[106] "where's"    "why's"      "how's"     
[109] "a"          "an"         "the"       
[112] "and"        "but"        "if"        
[115] "or"         "because"    "as"        
[118] "until"      "while"      "of"        
[121] "at"         "by"         "for"       
[124] "with"       "about"      "against"   
[127] "between"    "into"       "through"   
[130] "during"     "before"     "after"     
[133] "above"      "below"      "to"        
[136] "from"       "up"         "down"      
[139] "in"         "out"        "on"        
[142] "off"        "over"       "under"     
[145] "again"      "further"    "then"      
[148] "once"       "here"       "there"     
[151] "when"       "where"      "why"       
[154] "how"        "all"        "any"       
[157] "both"       "each"       "few"       
[160] "more"       "most"       "other"     
[163] "some"       "such"       "no"        
[166] "nor"        "not"        "only"      
[169] "own"        "same"       "so"        
[172] "than"       "too"        "very"      
```



Note on Color Choice
========================================================

To see all the possible color palette options in R, run the following code:


```r
library(RColorBrewer)
par(mar = c(0, 4, 0, 0))
display.brewer.all()
par(mar = c(0, 0, 0, 0))
```



Note on Color Choice
========================================================

* The first cluster are **sequential** palettes i.e. indicate highs and lows
* The next are **qualitative** i.e. they don't convey any real order, just groups
* The last are **diverging** i.e. they diverge from some middle point

In the case of creating wordclouds today, sequential is appropriate since we want to convey highs and lows, but there is no divergence point



Note on Color Choice
========================================================
The following commands generate the HEX codes representing colors on the [color wheel](http://simple.wikipedia.org/wiki/Color_wheel)

```r
brewer.pal(8, "Purples")
brewer.pal(8, "Set3")
```


Today's Exercise
========================================================
We're revisiting OkCupid essay data. Using:

* the `stringr` and `tm` packages
* basic set operations in R

We're going to evaluate both

* the top 500 words used by men, that ARE NOT in the top 500 words used by women
* the top 500 words used by women, that ARE NOT in the top 500 words used by men


