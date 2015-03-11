# File: UtahLevel3Design.R
# Purpose: Example area GRTS survey design for Omernik level 3 ecoregions within Utah
# Programmer: Tony Olsen
# Date: February 28, 2005

#######
# Load sp library
#######
# Load psurvey.design library
#######

# Read dbf file
att <- read.dbf('eco_l3_ut')
head(att)

###### Four Example GRTS designs are given. Each can be run independently.

##### Equal probability GRTS survey design
Equaldsgn <- list(None=list(panel=c(PanelOne=115),
														seltype='Equal'
														)
								)

sample(100000000,1) # run to get random seed

Equalsites <- grts(design=Equaldsgn,
									src.frame='shapefile',
									in.shape='eco_l3_ut', 
									att.frame=att,
									type.frame='area',
									DesignID='UTEco3EQ',
									shapefile=TRUE,
									prj='eco_l3_ut',
									out.shape='Eco3.EqualSites'									
									)




##### Unequal Probability GRTS survey design.
# what are the ecoregions?
levels(att$LEVEL3_NAM)

UnEqualdsgn <- list(None=list(panel=c(PanelOne=115),
														seltype='Unequal',
														caty.n=c("Central Basin and Range"=25,
																		 "Colorado Plateaus"=25,
																		 "Mojave Basin and Range"=10,
																		 "Northern Basin and Range"=10,
																		 "Southern Rockies"=10,
																		 "Wasatch and Uinta Mountains"=25,
																		 "Wyoming Basin"=10)
														)
								)

sample(100000000,1) # run to get random seed

UnEqualsites <- grts(design=UnEqualdsgn,
									src.frame='shapefile',
									in.shape='eco_l3_ut',  
									att.frame=att,
									type.frame='area',
									mdcaty='LEVEL3_NAM',									
									DesignID='UTEco3UN',
									shapefile=TRUE,
									prj='eco_l3_ut',
									out.shape='Eco3.UnEqualSites'									
									)

#summarize sites selected
addmargins( table( UnEqualsites$mdcaty,UnEqualsites$panel) )


##### Stratified GRTS survey design.
Stratdsgn <- list("Central Basin and Range"=list(panel=c(PanelOne=25),
														seltype='Equal'),
									"Colorado Plateaus"=list(panel=c(PanelOne=25),
														seltype='Equal'),
									"Mojave Basin and Range"=list(panel=c(PanelOne=10),
														seltype='Equal'),
									"Northern Basin and Range"=list(panel=c(PanelOne=10),
														seltype='Equal'),
									"Southern Rockies"=list(panel=c(PanelOne=10),
														seltype='Equal'),
									"Wasatch and Uinta Mountains"=list(panel=c(PanelOne=25),
														seltype='Equal'),
									"Wyoming Basin"=list(panel=c(PanelOne=10),
														seltype='Equal')
								)

sample(100000000,1) # run to get random seed

Stratsites <- grts(design=Stratdsgn,
									src.frame='shapefile',
									in.shape='eco_l3_ut',  
									att.frame=att,
									type.frame='area',
									stratum='LEVEL3_NAM',									
									DesignID='UTEco3ST',
									shapefile=TRUE,
									prj='eco_l3_ut',
									out.shape='Eco3.Stratify.Sites'									
									)

# summarize sites selected
addmargins( table( Stratsites$stratum,Stratsites$panel) )


##### Panels for surveys over time with unequal probability GRTS survey design
#			 with over sample.
Paneldsgn <- list(None=list(panel=c(Panel_1=50, Panel_2=50, Panel_3=50,
																			Panel_4=50, Panel_5=50),
														seltype='Unequal',
														caty.n=c("Central Basin and Range"=64,
																		 "Colorado Plateaus"=63,
																		 "Mojave Basin and Range"=15,
																		 "Northern Basin and Range"=15,
																		 "Southern Rockies"=15,
																		 "Wasatch and Uinta Mountains"=63,
																		 "Wyoming Basin"=15),
														over=100
														)
								)

sample(100000000,1) # run to get random seed

Panelsites <- grts(design=Paneldsgn,
									src.frame='shapefile',
									in.shape='eco_l3_ut',  
									att.frame=att,
									type.frame='area',
									mdcaty='LEVEL3_NAM',									
									DesignID='UTEco3Pan',
									shapefile=TRUE,
									prj='eco_l3_ut',
									out.shape='Eco3.PanelSites'									
									)

# summarize sites selected
addmargins( table(Panelsites$mdcaty,Panelsites$panel) )

