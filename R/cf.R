### Extract coefficient (or params) from common stats model lm/glm/lme/lmer/glmer/t-test. 

cf <- function(x, addci = TRUE, pv.style = 1, signif = 2,
               expcf = ifelse("glm" %in% class(x)  &
                              family(x)$family == "binomial",
                              TRUE, FALSE), ...){
    xcf  <- data.frame()
    xclass <- class(x)


    ## linear model.
    if(xclass[1] == "lm" ){
        tabformat <- sprintf("%%.%if",signif)
        xcf <- coef(summary(x))
        xcf <- as.data.frame(xcf)
        names(xcf) <- c("Est.", "s.e.", "t", "P(>|t|)")
        if(length(tabformat) ==  1){
            xcf[,1:3] <- sapply(xcf[,1:3], function(x) sprintf(tabformat, x))

        }
        else{
            for(i in 1:3)
                xcf[,i] <- sprintf(tabformat[i], xcf[,i])
        }
        xcf[,4] <- pv(xcf[,4], style = pv.style)
        if(addci){
            xci <- confint(x)
            xcf[,c("lower 95% ci",
                   "upper 95% ci")] <- sapply(xci,
                                              function(x)
                                                  sprintf(tabformat[1], x) )
        }      
    }
    ## general linear model.     
    else if(xclass[1] == "glm"){
        tabformat <- sprintf("%%.%if",signif)
        xcf <- coef(summary(x))
        xcf <- as.data.frame(xcf)
        names(xcf) <- c("Est.", "s.e.", "z", "P(>|z|)")
        if(expcf){
            xcf[["exp(Est.)"]] <- sprintf(tabformat[1], exp(xcf[,"Est."]))
        }     
        if(length(tabformat) ==  1){
            xcf[,1:3] <- sapply(xcf[,1:3], function(x) sprintf(tabformat, x))
            
        }
        else{
            for(i in 1:3)
                xcf[,i] <- sprintf(tabformat[i], xcf[,i])
        }
        xcf[,4] <- pv(xcf[,4], style = pv.style)
        if(addci){
            xci <- exp(suppressMessages(confint(x)))
            xcf[,c("lower 95% ci",
                   "upper 95% ci")] <- sapply(xci, function(x) sprintf(tabformat[1], x) )
        }          
    }
    ## mixed-effect linear model.
    else if(xclass[1] == "lme" ){
        tabformat <- sprintf("%%.%if",signif)
        xcf <- summary(x)$tTable
        xcf <- as.data.frame(xcf)
        names(xcf) <- c("Est.", "s.e.", "df", "t", "P(>|t|)")
        if(length(tabformat) ==  1){
            xcf[,c(1:2, 4)] <- sapply(xcf[,c(1:2, 4)], function(x) sprintf(tabformat, x))
        }
        else{
            for(i in 1:3)
                xcf[, c(1:2, 4)[i]] <- sprintf(tabformat[i], xcf[,c(1:2, 4)[i]])
        }
        xcf[,5] <- pv(xcf[,5], style = pv.style)
        if(addci){
            xci <- intervals(x)$fixed[,c(1,3)]
            xcf[,c("lower 95% ci",
                   "upper 95% ci")] <- sapply(xci, function(x) sprintf(tabformat[1], x) )
        }    
    }
    ## t-test.
    else if(xclass[1] == "htest" ){
        if(x$method != "Paired t-test"){
            tabformat <- sprintf("%%.%if",signif)
            xcf <- data.frame(x$estimate[1], x$estimate[2], -diff(x$estimate),
                              x$statistic, x$parameter, x$p.value, row.names = "")
            nn1 <- sub("^mean in group (.*)|mean of (.*)$", "mean(\\1\\2)",              
                       names(x$estimate))
            names(xcf) <- c(nn1, "Diff.", "t", "df", "P(>|t|)")
            if(length(tabformat) ==  1){
                xcf[,1:4] <- sapply(xcf[,1:4],
                                    function(x) sprintf(tabformat, x))
            }
            else{        
                xcf[, 1:3] <- sapply(xcf[,1:3],
                                     function(x) sprintf(tabformat[1], x))
                xcf[,4] <- sprintf(tabformat[2], xcf[,4])
            }
            xcf[,5] <- sprintf("%.1f", xcf[,5])
            xcf[,6] <- pv(xcf[,6], style = pv.style)
            if(addci){
                xci <- x$conf.int
                xcf[,c("lower 95% ci",
                       "upper 95% ci")] <- sapply(xci,
                                                  function(x)
                                                      sprintf(tabformat[1], x))
            }
        }
        else if(x$method == "Paired t-test"){
            tabformat <- sprintf("%%.%if",signif)
            xcf <- data.frame(x$estimate[1], x$statistic,
                              x$parameter, x$p.value,
                              row.names = "")
            names(xcf) <- c("mean diff.", "t", "df", "P(>|t|)")
            if(length(tabformat) ==  1){
                xcf[,1:2] <- sapply(xcf[,1:2],
                                    function(x) sprintf(tabformat, x))
            } 
            else{        
                xcf[, 1] <- sapply(xcf[,1],
                                   function(x) sprintf(tabformat[1], x))
                xcf[,2] <- sprintf(tabformat[2], xcf[,2])
            }
            xcf[,3] <- sprintf("%.1f", xcf[,3])
            xcf[,4] <- pv(xcf[,4], style = pv.style)
            if(addci){
                xci <- x$conf.int
                xcf[,c("lower 95% ci",
                       "upper 95% ci")] <- sapply(xci,
                                                  function(x)
                                                      sprintf(tabformat[1], x))
            }          
        }
    }        
    ## lmer
    else if(xclass[1] %in% c("lmerMod", "lmerModLmerTest") ){
        tabformat <- sprintf("%%.%if",signif)
        if(xclass[1] %in% "lmerMod")
            x  <- lmerTest::as_lmerModLmerTest(x)
        xcf <- summary(x)$coefficient
        xcf <- as.data.frame(xcf)
        names(xcf) <- c("Est.", "s.e.", "df", "t", "P(>|t|)")
        if(length(tabformat) ==  1){
            xcf[,c(1:2, 4)] <- sapply(xcf[,c(1:2, 4)],
                                      function(x) sprintf(tabformat, x))
        }
        else{
            for(i in 1:3)
                xcf[, c(1:2, 4)[i]] <- sprintf(tabformat[i], xcf[,c(1:2, 4)[i]])
        }
        xcf[,5] <- pv(xcf[,5], style = pv.style)
        if(addci){
            xci <- suppressMessages(confint(x, parm = "beta_"))
            xcf[,c("lower 95% ci",
                   "upper 95% ci")] <- sapply(xci,
                                              function(x) sprintf(tabformat[1], x) )
        }    
    }
    ## glmer
    else if(inherits(x, "glmerMod") ){
        tabformat <- sprintf("%%.%if",signif)
        xcf <- summary(x)$coefficient
        xcf <- as.data.frame(xcf)
        names(xcf) <- c("Est.", "s.e.", "Z", "P(>|Z|)")
        if(length(tabformat) ==  1){
            xcf[,c(1:2, 3)] <- sapply(xcf[,c(1:2, 3)],
                                      function(x) sprintf(tabformat, x))
        }
        else{
            for(i in 1:3)
                xcf[, c(1:3)[i]] <- sprintf(tabformat[i], xcf[,c(1:3)[i]])
        }
        xcf[,4] <- pv(xcf[,4], style = pv.style)
        if(addci){
            xci <- suppressMessages(confint(x, parm = "beta_"))
            xcf[,c("lower 95% ci",
                   "upper 95% ci")] <- sapply(xci,
                                              function(x) sprintf(tabformat[1], x) )
        }    
    }
    ## other model.
    else{
        stop("Not yet implemented for this type of model.")
        return(NULL)
    }
    as.data.frame(xcf)
}


