#------------------------------------------------
# Extra Stuff: How did I get ggplot's default colors #F8766D and #00BFC4?
#------------------------------------------------
# Using this function, you can pick off colors from the color wheel below.
gg_color_hue <- function(n) {
  hues = seq(15, 375, length=n+1)
  hcl(h=hues, l=65, c=100)[1:n]
}

# For example for the plots above we had two cases, so we set n=2
gg_color_hue(n=2)

# Create color wheel
r  <- seq(0,1,length=201)
th <- seq(0,2*pi, length=201)
d  <- expand.grid(r=r,th=th)
gg <- with(d,data.frame(d,x=r*sin(th),y=r*cos(th),
                        z=hcl(h=360*th/(2*pi),c=100*r, l=65)))
ggplot(gg) +
  geom_point(aes(x,y, color=z), size=3)+
  scale_color_identity()+labs(x="",y="") +
  coord_fixed()
