library(shiny)
# setting the Women data and regression model
data(women)
women$Hcm<-women[,1]*2.54
women$Wkg<-women[,2]*0.453592
fit<-lm(Wkg ~ Hcm, data=women)

# functions for the defferent calculations

# calculate the current BMI based on input height and weight
bmicalc<-function(w,h) w/(h/100)^2
# calculate the desired weight based on input desired BMI
w_calc<-function(b,h) b*(h/100)^2

# calculate the change of weight to the desired weight
change<-function(w,nw) {
  wch<-w-nw
  if(wch<=0) {paste("gain ",abs(round(wch,1)), " kg")}
  else {paste("loose ", abs(round(wch,1)), " kg")}
}

# both xlimFunc and ylimFunc are designed to allow dynamic axis for the figures based on the inout and calculated values
xlimFunc<-function(d,c) {
  if(15<=d & d<=30 & 15<=c & c<=30) { 
    x1<-15
    x2<-30
    }
  else if(d>=c) {
    if (d<=30) {x2<-30} else {x2<-d+5}
    if (c>=15) {x1<-15} else {x1<-c-5}
  }
  else {
    if (c<=30) {x2<-30} else {x2<-c+5}
    if (d>=15) {x1<-15} else {x1<-d-5}
  }
  c(x1,x2)
}

ylimFunc<-function(d,c) {
  if(d<=75 & d>=50 & c<=75 & c>=50) {
    y1=50
    y2=75
  }
  else if (d>c) {
    if(d>75) y2=d+2 else y2=75
    if(c<50) y1=c-2 else y1=50
  }
  else if (c>d) {
    if(c>75) y2=c+2 else y2=75
    if(d<50) y1=d-2 else y1=50
  }
  c(y1,y2)
}



shinyServer(
  function(input,output){
    output$in_h<-renderPrint(input$height)
    output$in_w<-renderPrint(input$weight)
    output$BMIc<-renderPrint(round({bmicalc(input$weight,input$height)},1))
    output$newBMI<-renderPlot({
      plot(15:30,rep(1,16), type = "l", xlab = "BMI", ylab = "", yaxt="n",lwd=3,
           xlim = xlimFunc(input$BMIp,round(bmicalc(input$weight,input$height),1)))
      text(16, 0.9, "BMI too low", cex=1.1, col="red")
      text(27, 0.9, "BMI too high", cex=1.1, col="red")
      abline(v=18.5, col="red", lwd=5)
      abline(v=25, col="red", lwd=5)
      BMIp<-input$BMIp
      abline(v=BMIp,col="blue",lwd=2)
      BMIcur<-round(bmicalc(input$weight,input$height),1)
      abline(v=BMIcur,col="purple",lwd=2)
      text(27, 1.4, paste("Desired BMI=", BMIp),col = "blue", cex=1.2)
      text(27, 1.3, paste("Current BMI=", BMIcur),col="purple", cex=1.2)
    })
    
    # updating the new weight based on input
    nw<-reactive(round(w_calc(input$BMIp,input$height),1))
    output$newWeight<-renderPrint(nw())
    
    output$change<-renderPrint(change(input$weight,nw()))
    
    output$compW<-renderPlot({
      plot(women$Hcm, women$Wkg, ylim=ylimFunc(nw(),input$weight),
           xlab="Height (cm)", ylab="Weight (kg)")
      abline(lm(women$Wkg ~ women$Hcm), col="blue")
      abline(v=input$height, col="red", lwd=2)
      yp<-reactive(predict(fit, newdata = data.frame(Hcm = input$height)))
      points(input$height, yp() , col="red", pch=16)
      points(input$height, input$weight , col="purple", pch=17)
      points(input$height, nw() , col="blue", pch=17)
      mtext(paste("The average weight for women your height -", round(yp(),2)), col="red")
      text(input$height,input$weight, paste("Your current weight -", input$weight), pos=4, col="purple")
      text(input$height,nw(), paste("Your desired weight -", nw()), pos=4, col="blue")
      
    })
    
  }
)