library(shiny)
library(markdown)

shinyUI(fluidPage(
        titlePanel("Process Capability Calculator"),
        sidebarLayout(
                sidebarPanel(
                        sliderInput("obs","Select the sample size",value = 5000,min=1000,max=6000,step = 500),
                        numericInput("usl","Upper Specification Limit (USL)",25),
                        numericInput("lsl","Lower Specification Limit (LSL)",18),
                        numericInput("mn","Sample Mean",20),
                        numericInput("std","Standard Deviation",2),
                        
                        actionButton("goButton", "Calculate")
                ),
                
                mainPanel(
                        tabsetPanel(
                                tabPanel("Overview",
                                         
                                         withMathJax(),
                                         h3('About Process Capability'),
                                         p('Process Capability study is 
                                           a way to measure the performance 
                                           and capability of a process to meet 
                                           customer specifications. The Process Capability 
                                           Index (Cpk) uses both the process variability and 
                                           the process specifications to determine 
                                           whether the process is "capable". The larger the index, 
                                           the less likely it is that any item will be outside the 
                                           customer specifications.'),
                                         
                                         br(),
                                         
                                         strong('Example'),
                                         
                                         p('Steel cylinders manufactured by a company should have their diameters-as specified by customers- between 42 and 54 mm. The current process produces cylinders with average diameter of 49 mm with a 2-mm standard deviation. The capability of this process to meet customer specifications can be measured with the Cpk as the minimum between two values as represented in the formula:'),
                                         
                                         withMathJax("$$\\min{\\left[ \\frac{\\mbox{USL} - \\mu} {3\\sigma}, \\frac{\\mu - \\mbox{LSL}} {3\\sigma}\\right]}$$"),
                                         
                                         p('where,'),
                                         p('USL: the customer upper specification limit (54)'),
                                         p('LSL: the customer lower specification limit (42)'),
                                         p('mu: the mean diameter produced by the process (49)'),
                                         p('Sigma: the process standard deviation (2)'),
                                         
                                         h3('About the Application'),
                                         
                                         p('This application helps you calculate your process capability index by providing the above as input variables. Additionally, it calculates the Defect Per Million Opportunity (DPMO) which is the expected number of defected items per million produced. This is represented by the red area under the curve outside the lines of specification limits.'),
                                         p('Besides, the application calculates the Sigma Level of the process using the formula:'),
                                         
                                         withMathJax("$$0.8406+\\sqrt{29.37-2.221*ln(DPMO)}$$"),
                                         
                                         p('Sigma Level is a measure of the defect rate of a process based on the DPMO estimate. The higher the Sigma Level, the better the performance is. For example, a process of 6-sigma level has 3.4 defects per million opportunity. Whereas a process of 3-sigma level has 66,807 DPMO.'),
                                         
                                         h3('ui.R and server.R files'),
                                         p('Visit this link to view the ui.R and server.R files in github'),
                                         tags$a(href='https://github.com/Mohammedkb/CpkCalculator',"https://github.com/Mohammedkb/CpkCalculator"),
                                         
                                         h3('Application developed by:'),
                                         p('Mohammed K. Barakat')
                                         
                                         ),
                                
                                tabPanel("Get Started",
                                         h3('How to use the Application'),
                                         p('To calculate the Process Capability Index using this application you need to follow these steps:'),
                                         
                                         tags$ol("1. Go to the 'Run Application' tab"),
                                         tags$ol("2. Select the sample size of the items produced by your process. The larger the sample size, the more accurate the results are. Sample size ranges from 1000 to 6000"),
                                         tags$ol("3. Specify the Upper Specification Limit of the quality feature (e.g. cylinder diameter) accepted by your customer"),
                                         tags$ol("4.	Specify the Lower Specification Limit of the quality feature (e.g. cylinder diameter) accepted by your customer"),
                                         tags$ol("5.	Specify the  estimated mean of the process for the quality feature (e.g. diameter) based on the sample you selected"),
                                         tags$ol("6.	Specify the estimated variability of the process (expressed as a Standard Deviation) for the quality feature (e.g. diameter)"),
                                         tags$ol("7.	Hit the 'Calculate' button to calculate Process Capability measures"),
                                         tags$ol("8.	Study the resulted Process Capability Plot and output measures"),
                                         tags$ol("9.	Read the conclusion and recommendations to improve your current process in the 'Results Interpretation' tab"),
                                         br(),
                                         h4("The application produces the below output:"),
                                         
                                         tags$li("The Process Capability Plot. This is a normal distribution curve showing the process variation compared to the USL and LSL. Green area shows within-specs probability, whereas the red area(s) show out-of-specs probability. The plot is updated directly upon changing any input value."),
                                         br(),
                                         tags$li("The Process Capability Index (Cpk)"),
                                         br(),
                                         tags$li("Percentage Defective. This is the percentage of out-of-specs items your process is producing currently"),
                                         br(),
                                         tags$li("Defect Per Million Opportunity (DPMO). This is the number of defected items the process is probable to produce out of a million items"),
                                         br(),
                                         tags$li("The Process Sigma Level. This is the measure of the defect rate of the process based on the DPMO estimate")
                                         ),
                                
                                tabPanel("Run Application",
                                         plotOutput("CapPlot"),
                                         h3('Process Capability measures'),
                                         h4('Process Capability Index (Cpk)'),
                                         verbatimTextOutput("cpk"),
                                         h4('Percentage Defective'),
                                         verbatimTextOutput("totArea"),
                                         h4('Defect Per Million Opportunity (DPMO)'),
                                         verbatimTextOutput("dpmo"),
                                         h4('Process Sigma Level'),
                                         verbatimTextOutput("sigmaLevel")
                                         ),
                                tabPanel("Results Interpretation",
                                         br(),
                                         htmlOutput("interp")
                                         )
                        )
                        
                )
        )
                
))
