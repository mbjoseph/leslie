library(shiny)

server <- function(input, output) {
  calcs <- reactive({
    A0 <- matrix(0, nrow=4, ncol=4)
    A0[1, 2] <- input$fc2 # fecundity, class 2
    A0[1, 3] <- input$fc3 # fecundity, class 3
    A0[1, 4] <- input$fc4 # fecundity, class 4
    A0[2, 1] <- input$tp1 # transition probability, class 1 to 2
    A0[3, 2] <- input$tp2 # transition probability, class 2 to 3
    A0[4, 3] <- input$tp3 # transition probability, class 3 to 4
    A0[4, 4] <- input$sp4 # survival probability, class 4
    lambda <- eigen(A0)$values[1] # dominant eigenvalue
    rvec <- eigen(A0)$vectors[, 1] # right eigenvector
    lvec <- eigen(t(A0))$vectors[, 1] # left eigenvector
    emat <- array(dim=c(4, 4)) # elasticity matrix
    for (i in 1:4){
      for (j in 1:4){
        emat[i, j] <- A0[i, j] * lvec[i] * rvec[j] / (lambda * t(lvec) %*% rvec)
      }
    }
    emat <- matrix(as.numeric(emat), nrow=4, ncol=4)
    rownames(emat) <- c("Class 1", "Class 2", "Class 3", "Class 4")
    colnames(emat) <- rownames(emat)
    rownames(A0) <- rownames(emat)
    colnames(A0) <- rownames(emat)
    x0 <- c(10, 0, 0, 0) # initial pop'n
    x <- array(NA, dim=c(4, input$timesteps))
    x[,1] <- x0
    Nt <- array(NA, dim=ncol(x)) # total population
    px <- array(dim=c(4, ncol(x))) # proportion in each age class
    for (t in 2:input$timesteps){
      x[,t] <- A0 %*% x[, t-1]
      Nt[t] <- sum(x[, t])
      px[,t] <- x[, t]/Nt[t]
    }
    
    list(A0=A0, emat=emat, x=x, Nt=Nt, px=px, Lambda=lambda)
  })
  
  output$elastTab <- renderTable({
    calcs()$emat
  }
  )
  
  output$Lesliemat <- renderTable({
    calcs()$A0
  }
  )
  
  output$plot <- renderPlot({
    out <- calcs()
    title <- paste("Dominant eigenvalue = ", round(Re(out$Lambda), 3))
    time_seq <- 1:ncol(out$x)
    plot(x=time_seq, 
         y=out$Nt, 
         type="l", 
         xlab="Time", 
         ylab="Log(population size)", 
         lty=2, 
         log="y", 
         main=title)
    colors <- c('purple', 'red', 'dark orange', 'blue')
    for (i in seq_along(colors)) {
      lines(time_seq, y = out$x[i, ], col = colors[i])
    }
    ypos <- max(abs(out$Nt), na.rm=TRUE)
    legend(x=1, y=ypos, c("Class 1", "Class 2", "Class 3", "Class 4"), 
           col=c("purple", "red", "dark orange", "blue"),
           text.col="black", lty=c(1, 1, 1, 1))
  })
}

