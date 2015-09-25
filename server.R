library(ggplot2)
library(markdown)

shinyServer(
        function(input,output,session) {
                environment<-environment()
                
                rValues<-reactive({data.frame(x=rnorm(input$obs,input$mn,input$std))})
                
                output$CapPlot<-renderPlot({
                        
                        g<-ggplot(rValues(), aes(x=x),environment=environment) +
                                geom_density(aes(y=..density..),size=1,alpha=.2,fill="darkgreen") +
                                geom_segment(aes(x = input$lsl, y = 0, xend = input$lsl, yend = .3),size=1,colour="blue",linetype="dashed")+
                                geom_segment(aes(x = input$usl, y = 0, xend = input$usl, yend = .3),size=1,colour="blue",linetype="dashed")+
                                
                                labs(x="Measurement")+
                                theme(plot.title = element_text(size = 14, face = "bold", colour = "black", vjust = +1))+
                                ggtitle(expression(atop("Process Capability Plot")))+
                                
                                annotate("text",x=input$lsl,y=.33,label= paste0("LSL=",input$lsl),size=3,color="blue")+
                                annotate("text",x=input$usl,y=.33,label= paste0("USL=",input$usl),size=3,color="blue")
                                
                        
                        d <- ggplot_build(g)$data[[1]]
                        
                        g <- g + geom_area(data = subset(d, x > input$usl), aes(x=x, y=y), fill="red")
                        g <- g + geom_area(data = subset(d, x < input$lsl), aes(x=x, y=y), fill="red")
                        g
                })
                
                # calculate the cpk
                cpkVal<<-reactive({
                  cpu<-(input$usl-input$mn)/(3*input$std)
                  cpl<-(input$mn-input$lsl)/(3*input$std)
                  round(min(cpu,cpl),2)
                })
                
                output$cpk<-renderText({
                        input$goButton
                        isolate(cpkVal())
                })
                
                area<<-reactive({
                  Zu=(input$usl-input$mn)/input$std
                  Zl=(input$mn-input$lsl)/input$std
                  area1<-pnorm(Zu,lower.tail = FALSE)
                  area2<-pnorm(Zl,lower.tail = FALSE)
                  area1+area2
                })
                
                output$totArea<-renderText({
                        input$goButton
                        isolate(sprintf("%.2f %%", 100*area()))
                })
                
                output$dpmo<-renderText({
                        input$goButton
                        isolate(round(area()*1000000,0))
                })
                
                output$sigmaLevel<-renderText({
                        input$goButton
                        isolate(round(0.8406+sqrt(29.37-2.221*log(area()*1000000)),2))
                })
                
                output$ResultsInterp<-renderText({
                        input$goButton
                        isolate(if(cpkVal()>1.33) {"Pass"} else {"Fail"})
                })
                
                
                output$interp<-renderText({
                  input$goButton
                  
                  isolate(if (cpkVal()<1){ 
                    case1.str0<-strong("Conclusion:")
                    case1.str1<-p("Your process Cpk < 1")
                    case1.str2<-p("Your process is incapable of producing a product that meets customer specifications.")
                    case1.str3<-strong("Recommendations:")
                    case1.str4<-p("You need to work on either reducing process variation (standard deviation), centering the process mean between specification limits, or both.")
                    HTML(paste(case1.str0,case1.str1, case1.str2,case1.str3,case1.str4, sep = '<br/>'))
                  }
                          else if (cpkVal()==1) { 
                            case1.str0<-strong("Conclusion:")
                            case1.str1<-p("Your process Cpk = 1")
                            case1.str2<-p("Your process is just capable of producing a product that meets customer specifications. However, if the process shifts slightly without immediate correction, it will become incapable.")
                            case1.str3<-strong("Recommendations:")
                            case1.str4<-p("You need to work on either reducing process variation (standard deviation), centering the process mean between specification limits, or both.")
                            HTML(paste(case1.str0,case1.str1, case1.str2,case1.str3,case1.str4, sep = '<br/>'))
                          }
                  
                          else if (cpkVal()>1 & cpkVal()<=1.33) { 
                            case1.str0<-strong("Conclusion:")
                            case1.str1<-p("Your process Cpk > 1 and <= 1.33")
                            case1.str2<-p("Your process is marginally capable of producing a product that meets customer specifications. By time, the process may allow some shifts that can go undetected. Hence, there is some risk that the process performance deteriorates.")
                            case1.str3<-strong("Recommendations:")
                            case1.str4<-p("In order to avoid deterioration in process performance you need to work harder to improve the Cpk by reducing the process variation.")
                            HTML(paste(case1.str0,case1.str1, case1.str2,case1.str3,case1.str4, sep = '<br/>'))
                          }
                          
                          else if (cpkVal()>1.33) { 
                            case1.str0<-strong("Conclusion:")
                            case1.str1<-p("Your process Cpk > 1.33")
                            case1.str2<-p("Your process is highly capable of producing a product that meets customer specifications. This is the preferable performance of a process. You need to maintain this level of capability.")
                            case1.str3<-strong("Recommendations:")
                            case1.str4<-p("Since your process performance is excellent you need to maintain current capability by having control procedures on the current process state.")
                            HTML(paste(case1.str0,case1.str1, case1.str2,case1.str3,case1.str4, sep = '<br/>'))
                          }
                  
                          )
                })
        }
)