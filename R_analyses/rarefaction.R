## rarefaction analysis on Trinity output
## 2025-05-16, eric pante

# one month old juveniles: 
r1 =c(328597059, 300000000, 200000000, 100000000, 50000000, 10000000, 1000000)
t1 =c(476642,    474667,    457903,    405933,    340391,   189375,   62932)

# nexly hatched
r2 =c(87985565, 80000000, 70000000, 50000000, 25000000, 10000000, 1000000)
t2 =c(275986,   274371,   271203,   260549,   223361,   163931,   55823)

# combined plot
plot(t1~r1, type='l', axes=F, ylab="n. transcripts (x1000)", xlab="n. reads (millions)")
axis(side=1, at=c(300000000, 200000000, 100000000, 50000000, 1000000),label=c(300, 200, 100, 50, 1))
axis(side=2, at=c(400000,300000,200000,100000),label=c(400,300,200,100))
lines(r2,t2, lty=2, col="blue")
legend("bottomright", 
		legend=c("recently hatched juveniles", "one month old juveniles"), 
		col=c("blue", "black"), 
		lty=c(2,1), 
		bty='n')
