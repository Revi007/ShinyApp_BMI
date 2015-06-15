library(shiny)
shinyUI(fluidPage(
  title="What is your preffered BMI?",
  hr(),
  fluidRow(
    h3('This simple application helps you to set your weight goal by - '),
    h5('1. calculate your current BMI based on your height and weight'),
    h5('2. Allow you to set your desired BMI, and calculates the weight goal'),
    h5('3. Visualize your current vs. desired BMI'),
    h5('4. Compare your current and desired weight with the Women average weight data, so you can compare yourself to the average population weight.'),
    h5('The Women data is taken from the R dataset package, it consists of the average weight of women between the age of 30-39 in USA, for different heights.'),
    h5('The women data was used to create a linear regressin model for predicting the average weight of women at the desired height.'),
    h3('Remember - healthy BMI range is 18.5 - 25'),
    h3('You are invited to enter your data and play around.')
  ),
  fluidRow(
    column(3,
           h3('Your input data:'),
           numericInput('height','Your height in cm - ',180, min = 100,max = 220,step=1),
           numericInput('weight','Your weight in kg - ',73, min = 0,max = 220,step=1),
           sliderInput('BMIp','Desired BMI',value = 22.5, min=18.5, max=35,step = 0.5)
    ),
    column(3,
           h3('BMI results'),
           h4('Based on Your input:'),
           h5('Height'),verbatimTextOutput("in_h"),
           h5('Weight'),verbatimTextOutput("in_w"), 
           h5('Your current BMI - '),verbatimTextOutput("BMIc"),
           h5("Your desired weight is -"),verbatimTextOutput("newWeight"),
           h5('To achieve your desired BMI you should'), verbatimTextOutput("change")
    ),
    column(6,
           h4('Current vs. Desired BMI'),
           h5('The red line set the healthy range of BMI values.'),
           plotOutput('newBMI'),
           h4('Current vs. Desired BMI - and comparison to the average women weight'),
           h5('The black points and regression line represent the average women weight for the different heights.'),
           h5('Along the red line( your height) you can see your current vs. desired weight, in comparison to the average women weight.'),
           plotOutput('compW')
    )
  )
))